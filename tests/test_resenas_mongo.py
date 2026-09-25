"""Integration tests: private mongod process + unique MariaDB database; no Atlas writes."""
from pathlib import Path
import concurrent.futures
import http.cookiejar
import json
import os
import shutil
import socket
import stat
import subprocess
import tempfile
import time
import urllib.error
import urllib.request
import uuid

ROOT = Path(__file__).resolve().parents[1]
PHP = os.environ.get('TEST_PHP', r'C:\xampp\php\php.exe')
MYSQL = os.environ.get('TEST_MYSQL', r'C:\xampp\mysql\bin\mysql.exe')
MONGOD = shutil.which('mongod')
assert MONGOD, 'Instala mongod o agrégalo al PATH para las pruebas aisladas.'
NAME = 'todoaqui_test_' + uuid.uuid4().hex[:12]
FOLDER = Path(tempfile.mkdtemp(prefix=NAME))
ENV = os.environ.copy()
processes, handles = [], []
created = False
requests = 0

def port():
    with socket.socket() as s:
        s.bind(('127.0.0.1', 0))
        return s.getsockname()[1]

def start(command, logname):
    handle = open(FOLDER / logname, 'w', encoding='utf-8')
    handles.append(handle)
    proc = subprocess.Popen(command, cwd=FOLDER, env=ENV, stdout=handle, stderr=handle,
                            creationflags=getattr(subprocess, 'CREATE_NO_WINDOW', 0))
    processes.append(proc)
    return proc

def ready(number):
    for _ in range(100):
        try:
            with socket.create_connection(('127.0.0.1', number), timeout=.2):
                return
        except OSError:
            time.sleep(.1)
    raise AssertionError('El servidor temporal no inició: ' + str(FOLDER))

def sql(statement, db=True):
    command = [MYSQL, '-u', 'root', '--default-character-set=utf8mb4', '-N', '-B']
    if db:
        command += ['-D', NAME]
    result = subprocess.run(command, input=statement, text=True, encoding='utf-8', capture_output=True)
    assert result.returncode == 0, result.stderr
    return result.stdout.strip()

def php(code):
    result = subprocess.run([PHP, '-r', code], cwd=FOLDER, env=ENV, text=True, encoding='utf-8', capture_output=True)
    assert result.returncode == 0, result.stderr
    return result.stdout

def client():
    return urllib.request.build_opener(urllib.request.HTTPCookieProcessor(http.cookiejar.CookieJar()))

def request(who, method, route, data=None, expected=200):
    global requests
    req = urllib.request.Request(BASE + route, method=method,
        data=None if data is None else json.dumps(data).encode(), headers={'Content-Type': 'application/json'})
    try:
        response = who.open(req, timeout=20)
    except urllib.error.HTTPError as e:
        response = e
    body = response.read().decode('utf-8')
    assert response.status == expected, (method, route, expected, response.status, body)
    result = json.loads(body)
    assert result['success'] == (expected < 400), result
    requests += 1
    return result

def multipart(who, route, data, files, expected=200):
    global requests
    boundary = 'review' + uuid.uuid4().hex
    body = ('--'+boundary+'\r\nContent-Disposition: form-data; name="datos"\r\n\r\n'+json.dumps(data)+'\r\n').encode()
    for content in files:
        body += ('--'+boundary+'\r\nContent-Disposition: form-data; name="Imagenes[]"; filename="untrusted.php"\r\nContent-Type: image/jpeg\r\n\r\n').encode()+content+b'\r\n'
    body += ('--'+boundary+'--\r\n').encode()
    req=urllib.request.Request(BASE+route,data=body,headers={'Content-Type':'multipart/form-data; boundary='+boundary})
    try: response=who.open(req,timeout=20)
    except urllib.error.HTTPError as error: response=error
    content=response.read().decode('utf-8')
    assert response.status==expected,(expected,response.status,content)
    requests+=1
    return json.loads(content)

try:
    mongo_port, http_port = port(), port()
    ENV.update(MONGODB_URI=f'mongodb://127.0.0.1:{mongo_port}', MONGODB_DATABASE=NAME)
    (FOLDER / 'mongo').mkdir()
    uploads = FOLDER / 'review-uploads'; uploads.mkdir()
    ENV['RESENAS_IMAGENES_DIR'] = str(uploads)
    mongo = start([MONGOD, '--dbpath', str(FOLDER / 'mongo'), '--bind_ip', '127.0.0.1', '--port', str(mongo_port)], 'mongo.log')
    ready(mongo_port)
    sql('CREATE DATABASE ' + NAME + ' CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci', False)
    created = True
    sql((ROOT / 'database/crear_bd_tablas.sql').read_text(encoding='utf-8').replace('todoaqui_db', NAME))
    for name in ['api', 'app', 'config']:
        shutil.copytree(ROOT / name, FOLDER / name)
    cfg = FOLDER / 'config/database.php'
    cfg.write_text(cfg.read_text(encoding='utf-8').replace('todoaqui_db', NAME), encoding='utf-8')
    # Remove credentials from the isolated copy. MongoDB must use the local environment.
    (FOLDER / 'config/api_keys.php').write_text('<?php', encoding='utf-8')
    (FOLDER / 'vendor').mkdir()
    (FOLDER / 'vendor/autoload.php').write_text("<?php require '" + (ROOT / 'vendor/autoload.php').as_posix() + "';", encoding='utf-8')
    password = php("echo password_hash('Prueba123!', PASSWORD_DEFAULT);")
    for n in range(1, 5):
        role = 'Administrador' if n == 1 else 'Cliente'
        sql("INSERT INTO Usuarios (Nombres,Apellidos,Correo,Telefono,Usuario,Contrasena,TipoUsuario) "
            f"VALUES ('Prueba','Mongo','test{n}@example.com','5000000{n}','test{n}','{password}','{role}')")
    sql("INSERT INTO Categorias (Nombre) VALUES ('Prueba'); INSERT INTO Productos(CategoriaID,Nombre,Precio,Cantidad) VALUES "
        "(1,'Producto A',12,10),(1,'Producto B',20,10),(1,'Producto C',30,10);")
    for n in [2, 3]:
        sql(f"INSERT INTO Ordenes(UsuarioID,DireccionPago,DireccionEnvio,Subtotal,Total,Estado) VALUES ({n},'Casa','Casa',32,32,'Entregada');"
            f"INSERT INTO DetalleOrdenes(OrdenID,ProductoID,Cantidad,PrecioUnitario,Subtotal) VALUES ({n-1},1,1,12,12),({n-1},2,1,20,20);")
    # A pre-existing imported numeric ID and BSON date must be preserved.
    php("require 'app/services/ResenasMongo.php'; $db=conexionMongoDB(); "
        "$db->Resenas->insertOne(['ResenaID'=>50,'UsuarioID'=>4,'ProductoID'=>3,'Calificacion'=>3,'Comentario'=>null,'Estado'=>'Publicada','FechaResena'=>new MongoDB\\BSON\\UTCDateTime(new DateTimeImmutable('2026-08-06T21:00:00Z'))]); prepararResenasMongo($db);")
    # Contradictory SQL review: every read/statistic must ignore this legacy table.
    sql("INSERT INTO Resenas(UsuarioID,ProductoID,Calificacion,Comentario) VALUES(4,3,1,'Solo SQL')")
    start([PHP, '-S', f'127.0.0.1:{http_port}', '-t', str(FOLDER)], 'http.log')
    ready(http_port)
    BASE = f'http://127.0.0.1:{http_port}/api/'
    visitor, admin, owner, other = [client() for _ in range(4)]
    for n, who in [(1, admin), (2, owner), (3, other)]:
        request(who, 'POST', 'auth/login.php', {'Usuario': f'test{n}', 'Contrasena': 'Prueba123!'})
    old = request(visitor, 'GET', 'resenas/?id=50')['data']
    assert old['FechaResena'] == '2026-08-06 15:00:00' and old['Calificacion'] == 3
    assert 'UsuarioID' not in old and '_id' not in old
    request(visitor, 'POST', 'resenas/', {'ProductoID': 1, 'Calificacion': 4}, 401)
    request(owner, 'POST', 'resenas/', {'ProductoID': 3, 'Calificacion': 4}, 409)
    request(owner, 'POST', 'resenas/', {'ProductoID': {'$gt': 0}, 'Calificacion': 4}, 400)
    request(owner, 'POST', 'resenas/', {'ProductoID': 1, 'Calificacion': 6}, 400)
    review = request(owner, 'POST', 'resenas/', {'ProductoID': '1', 'Calificacion': '4', 'Comentario': 'Mi reseña'}, 201)['ResenaID']
    assert review > 50 and isinstance(review, int)
    assert sql('SELECT COUNT(*) FROM Resenas') == '1', repr(sql('SELECT COUNT(*) FROM Resenas'))
    request(owner, 'POST', 'resenas/', {'ProductoID': 1, 'Calificacion': 4}, 409)
    review2 = request(other, 'POST', 'resenas/', {'ProductoID': 1, 'Calificacion': 2}, 201)['ResenaID']
    catalog = request(visitor, 'GET', 'catalogo/')['data']['Productos']
    a = next(x for x in catalog if x['ProductoID'] == 1)
    assert a['Calificacion'] == 3 and a['Resenas'] == 2 and a['ResenasDisponibles']
    mine = request(owner, 'GET', 'cuenta/?recurso=resenas')['data']
    assert len(mine) == 1 and mine[0]['Producto'] == 'Producto A'
    request(other, 'PUT', f'resenas/?id={review}', {'Comentario': 'Ajeno'}, 404)
    request(other, 'DELETE', f'resenas/?id={review}', expected=404)
    request(admin, 'PUT', f'resenas/?id={review}', {'Comentario': 'Ajeno'}, 403)
    request(owner, 'PUT', f'resenas/?id={review}', {'UsuarioID': 3}, 400)
    request(owner, 'PUT', f'resenas/?id={review}', {'Calificacion': 5, 'Comentario': None})
    request(admin, 'PUT', f'resenas/?id={review}', {'Estado': 'Oculta'})
    request(visitor, 'GET', f'resenas/?id={review}', expected=404)
    assert len(request(visitor, 'GET', 'resenas/?ProductoID=1')['data']) == 1
    assert request(owner, 'GET', f'resenas/?id={review}')['data']['Estado'] == 'Oculta'
    request(owner, 'PUT', f'resenas/?id={review}', {'Estado': 'Publicada'}, 400)
    assert len(request(admin, 'GET', 'resenas/')['data']) == 3
    a = next(x for x in request(visitor, 'GET', 'catalogo/')['data']['Productos'] if x['ProductoID'] == 1)
    assert a['Calificacion'] == 2 and a['Resenas'] == 1
    # Name edits read live from SQL; review documents never embed stale identities.
    product = request(admin, 'GET', 'productos/?id=1')['data']
    fields = ['CategoriaID', 'SKU', 'Nombre', 'Descripcion', 'Precio', 'Cantidad', 'Imagen', 'Estado']
    changed = {k: product[k] for k in fields}; changed['Nombre'] = 'Nombre actualizado'
    request(admin, 'PUT', 'productos/?id=1', changed)
    assert request(owner, 'GET', 'cuenta/?recurso=resenas')['data'][0]['Producto'] == 'Nombre actualizado'
    request(owner, 'PUT', 'cuenta/?recurso=perfil', {'Nombres': 'Nuevo nombre'})
    assert request(owner, 'GET', 'cuenta/?recurso=resenas')['data'][0]['ResenaID'] == review
    assert php("require 'config/mongodb.php'; echo conexionMongoDB()->Usuarios->countDocuments() + conexionMongoDB()->Productos->countDocuments();") == '0'
    # Optional review images: files are isolated and MongoDB stores only their paths.
    jpg=(ROOT/'frontend/public/productos/laptop-backpack.jpg').read_bytes()
    payload={'ProductoID':2,'Calificacion':5,'Comentario':'Con fotos','Imagenes':[]}
    multipart(visitor,'resenas/',payload,[jpg],401)
    multipart(owner,'resenas/',payload,[jpg]*4,400)
    multipart(owner,'resenas/',payload,[jpg,b'<?php echo 1; ?>'],400)
    multipart(owner,'resenas/',payload,[jpg+b'x'*(2*1024*1024)],400)
    assert not list(uploads.iterdir())
    rid=multipart(owner,'resenas/',payload,[jpg]*3,201)['ResenaID']
    photos=request(owner,'GET',f'resenas/?id={rid}')['data']['Imagenes']
    assert len(photos)==3 and len(set(photos))==3
    assert all((uploads/Path(path).name).read_bytes()==jpg for path in photos)
    eligible=request(owner,'GET','cuenta/?recurso=productos-resenables')['data']
    assert {p['ProductoID'] for p in eligible}=={1,2}
    assert len(next(r for r in request(owner,'GET','cuenta/?recurso=resenas')['data'] if r['ResenaID']==rid)['Imagenes'])==3
    multipart(other,f'resenas/?id={rid}&_method=PUT',{'Imagenes':[]},[jpg],404)
    multipart(admin,f'resenas/?id={rid}&_method=PUT',{'Estado':'Oculta'},[jpg],403)
    multipart(owner,f'resenas/?id={rid}&_method=PUT',{'Comentario':'Solo texto'},[])
    assert request(owner,'GET',f'resenas/?id={rid}')['data']['Imagenes']==photos
    multipart(owner,f'resenas/?id={rid}&_method=PUT',{'Imagenes':photos},[jpg],400)
    multipart(owner,f'resenas/?id={rid}&_method=PUT',{'Imagenes':['/productos/falso.jpg']},[],400)
    multipart(owner,'resenas/',payload,[jpg],409)
    assert len(list(uploads.iterdir()))==3
    # Windows directory ReadOnly makes PHP is_writable false even when uploads work.
    previous_mode = uploads.stat().st_mode
    try:
        if os.name == 'nt':
            uploads.chmod(stat.S_IREAD)
            assert php("echo is_writable(getenv('RESENAS_IMAGENES_DIR')) ? 'yes' : 'no';") == 'no'
            probe = uploads / '.write-probe'
            probe.write_bytes(b'test')
            probe.unlink()
        multipart(owner,f'resenas/?id={rid}&_method=PUT',{'Imagenes':photos[:2]},[jpg])
        saved = request(owner, 'GET', f'resenas/?id={rid}')['data']['Imagenes']
        assert len(saved) == 3 and saved[:2] == photos[:2]
        assert (uploads / Path(saved[2]).name).read_bytes() == jpg
    finally:
        if os.name == 'nt':
            uploads.chmod(previous_mode)
    assert not (uploads/Path(photos[2]).name).exists() and len(list(uploads.iterdir()))==3
    multipart(owner,f'resenas/?id={rid}&_method=PUT',{'Imagenes':[]},[])
    assert not list(uploads.iterdir())
    # Exactly 2 MiB is accepted; deleting the review removes its files.
    exact=jpg+b'x'*(2*1024*1024-len(jpg))
    multipart(owner,f'resenas/?id={rid}&_method=PUT',{'Imagenes':[]},[exact])
    request(owner,'DELETE',f'resenas/?id={rid}')
    assert not list(uploads.iterdir())
    # Delete guards include imported Mongo-only references, independently of SQL FKs.
    sql('DELETE FROM Resenas')
    request(admin, 'DELETE', 'usuarios/?id=4', expected=409)
    request(admin, 'DELETE', 'productos/?id=3', expected=409)
    request(admin, 'DELETE', 'resenas/?id=50')
    request(admin, 'DELETE', 'usuarios/?id=4')
    request(admin, 'DELETE', 'productos/?id=3')
    request(owner, 'DELETE', f'resenas/?id={review}')
    request(other, 'DELETE', f'resenas/?id={review2}')
    assert request(visitor, 'GET', 'resenas/')['data'] == []
    request(owner, 'DELETE', f'resenas/?id={review}', expected=404)
    # Real parallel PHP workers: compound uniqueness allows exactly one review per pair.
    def attempt(_):
        return php("require 'app/models/Resena.php'; try { echo crearResena(null,2,['ProductoID'=>2,'Calificacion'=>5]); } catch(DomainException $e) { echo 'duplicate'; }")
    with concurrent.futures.ThreadPoolExecutor(max_workers=4) as pool:
        results = list(pool.map(attempt, range(4)))
    assert results.count('duplicate') == 3, results
    assert int(next(x for x in results if x != 'duplicate')) > 50
    # Outage: no SQL fallback, no leaked credentials, catalog remains usable.
    mongo.terminate(); mongo.wait(timeout=15)
    error = request(visitor, 'GET', 'resenas/', expected=503)
    assert 'mongodb://' not in json.dumps(error)
    request(owner, 'GET', 'cuenta/?recurso=resenas', expected=503)
    request(owner, 'POST', 'resenas/', {'ProductoID': 1, 'Calificacion': 4}, 503)
    request(admin, 'DELETE', 'productos/?id=1', expected=503)
    catalog = request(visitor, 'GET', 'catalogo/')['data']['Productos']
    assert catalog and all(x['ResenasDisponibles'] is False and x['Resenas'] is None for x in catalog)
    request(owner, 'GET', 'cuenta/?recurso=perfil')
    assert sql('SELECT COUNT(*) FROM Resenas') == '0'
    print(f'PASS: {requests} respuestas HTTP, BSON/IDs, CRUD MongoDB, compra entregada, permisos, moderación, promedio, nombres SQL actuales, concurrencia y caída de MongoDB.')
finally:
    for proc in reversed(processes):
        if proc.poll() is None:
            proc.terminate()
            try: proc.wait(timeout=15)
            except subprocess.TimeoutExpired: proc.kill(); proc.wait()
    for handle in handles: handle.close()
    if created:
        assert NAME.startswith('todoaqui_test_')
        sql('DROP DATABASE ' + NAME, False)
    print('Registros de las pruebas aisladas:', FOLDER)
