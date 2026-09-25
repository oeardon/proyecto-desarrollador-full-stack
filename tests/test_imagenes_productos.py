"""Multipart HTTP integration tests with a disposable database and upload directory."""
from pathlib import Path
import http.cookiejar, json, os, shutil, socket, subprocess, tempfile, time, urllib.request, urllib.error, uuid
ROOT = Path(__file__).resolve().parents[1]
PHP = os.environ.get('TEST_PHP', r'C:\xampp\php\php.exe')
MYSQL = os.environ.get('TEST_MYSQL', r'C:\xampp\mysql\bin\mysql.exe')
NAME = 'todoaqui_test_img_' + uuid.uuid4().hex[:10]
TMP = Path(tempfile.mkdtemp(prefix=NAME))
server = None
created = False
checks = 0

def sql(query, database=True):
    cmd = [MYSQL, '-u', 'root', '--batch', '--skip-column-names', '--default-character-set=utf8mb4']
    if database: cmd.append(NAME)
    return subprocess.check_output(cmd, input=query, encoding='utf-8').strip()

def client():
    return urllib.request.build_opener(urllib.request.HTTPCookieProcessor(http.cookiejar.CookieJar()))

def send(who, route, data=None, file=None, expected=200):
    global checks
    headers = {}
    body = None
    if data is not None:
        boundary = 'boundary' + uuid.uuid4().hex
        body = ('--'+boundary+'\r\nContent-Disposition: form-data; name="datos"\r\n\r\n'+json.dumps(data)+'\r\n').encode()
        if file is not None:
            body += ('--'+boundary+'\r\nContent-Disposition: form-data; name="Imagen"; filename="untrusted.php"\r\nContent-Type: image/jpeg\r\n\r\n').encode()+file+b'\r\n'
        body += ('--'+boundary+'--\r\n').encode()
        headers['Content-Type'] = 'multipart/form-data; boundary='+boundary
    req = urllib.request.Request(BASE+route, data=body, headers=headers)
    try: response = who.open(req, timeout=20)
    except urllib.error.HTTPError as error: response = error
    content = response.read().decode()
    assert response.status == expected, (response.status, expected, content)
    checks += 1
    return json.loads(content)

try:
    sql('CREATE DATABASE '+NAME+' CHARACTER SET utf8mb4', False); created=True
    sql((ROOT/'database/crear_bd_tablas.sql').read_text(encoding='utf-8').replace('todoaqui_db',NAME))
    sql("INSERT INTO Usuarios(Nombres,Apellidos,Correo,Telefono,Usuario,Contrasena,TipoUsuario) VALUES ('Test','Admin','admin@example.test','11111111','admin','unused','Administrador'),('Test','Client','client@example.test','22222222','client','unused','Cliente'); INSERT INTO Categorias(Nombre) VALUES ('Test');")
    files=['api/productos/index.php','api/respuestas.php','app/controllers/Validaciones.php','app/controllers/ProductoController.php','app/models/Sesion.php','app/models/Producto.php','app/services/ResenasMongo.php','app/services/ImagenProducto.php','config/mongodb.php','config/imagenes.php']
    for name in files:
        target=TMP/name;target.parent.mkdir(parents=True,exist_ok=True);shutil.copyfile(ROOT/name,target)
    (TMP/'config/database.php').write_text("<?php $conexion=new PDO('mysql:host=localhost;dbname="+NAME+";charset=utf8mb4','root','',[PDO::ATTR_ERRMODE=>PDO::ERRMODE_EXCEPTION,PDO::ATTR_DEFAULT_FETCH_MODE=>PDO::FETCH_ASSOC]);",encoding='utf-8')
    (TMP/'session.php').write_text("<?php session_start(); $_SESSION['UsuarioID']=(int)$_GET['id']; echo json_encode(['ok'=>true]);",encoding='utf-8')
    images=TMP/'frontend/public/productos';images.mkdir(parents=True)
    with socket.socket() as sock: sock.bind(('127.0.0.1',0)); port=sock.getsockname()[1]
    env=os.environ.copy();env['PRODUCTOS_IMAGENES_DIR']=str(images)
    log=open(TMP/'http.log','w',encoding='utf-8')
    server=subprocess.Popen([PHP,'-d','upload_max_filesize=6M','-d','post_max_size=8M','-S',f'127.0.0.1:{port}','-t',str(TMP)],cwd=TMP,env=env,stdout=log,stderr=log,creationflags=getattr(subprocess,'CREATE_NO_WINDOW',0))
    BASE=f'http://127.0.0.1:{port}/'
    for _ in range(50):
        try:
            with socket.create_connection(('127.0.0.1',port),timeout=.2): break
        except OSError: time.sleep(.1)
    admin, visitor, customer=client(),client(),client()
    send(admin,'session.php?id=1');send(customer,'session.php?id=2')
    data=dict(CategoriaID=1,SKU='TEST-IMG',Nombre='Producto test',Descripcion=None,Precio='12.00',Cantidad=2,Estado='Activo')
    jpg=(ROOT/'frontend/public/productos/laptop-backpack.jpg').read_bytes()
    send(visitor,'api/productos/',data,jpg,401);send(customer,'api/productos/',data,jpg,403)
    assert not list(images.iterdir())
    product=send(admin,'api/productos/',data,jpg,201)['ProductoID']
    old=send(visitor,f'api/productos/?id={product}')['data']['Imagen']
    assert old.startswith('/productos/producto-') and old.endswith('.jpg') and (images/Path(old).name).read_bytes()==jpg
    send(admin,f'api/productos/?id={product}&_method=PUT',{**data,'Nombre':'Editado'})
    assert send(visitor,f'api/productos/?id={product}')['data']['Imagen']==old
    send(admin,f'api/productos/?id={product}&_method=PUT',data,jpg)
    new=send(visitor,f'api/productos/?id={product}')['data']['Imagen']
    assert new!=old and (images/Path(old).name).exists()
    count=len(list(images.iterdir()))
    send(admin,'api/productos/',data,jpg,409)  # Duplicate SKU: rolls back the new file.
    send(admin,'api/productos/',{**data,'SKU':'BAD'},b'<?php echo 1; ?>',400)
    send(admin,'api/productos/',{**data,'SKU':'LARGE'},jpg+b'x'*(5*1024*1024),400)
    send(admin,'api/productos/',{**data,'SKU':'FK','CategoriaID':99999},jpg,400)
    assert len(list(images.iterdir()))==count and sql('SELECT COUNT(*) FROM Productos')=='1'
    assert send(visitor,f'api/productos/?id={product}')['data']['Imagen']==new
    print(f'OK: {checks} HTTP checks; upload, replacement, preservation, permissions, type/size rejection and rollback.')
finally:
    if server: server.terminate();server.wait(timeout=10);log.close()
    if created:
        assert NAME.startswith('todoaqui_test_img_')
        sql('DROP DATABASE '+NAME,False)
    print('Temporary artifacts:',TMP)
