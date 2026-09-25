# Transferencia de estado — TodoAquí

Fecha: 25 de septiembre de 2026.
Repositorio: `C:\xampp\htdocs\tienda_online`.
Este archivo reúne el estado para continuar en un nuevo chat. Las rutas relativas se interpretan desde la raíz del repositorio.

## Cómo retomar

1. Leer este documento y comprobar nuevamente `git status --short`, los archivos y el historial antes de editar. El usuario también modifica el proyecto mientras se trabaja.
2. Continuar en español, con acciones concretas y sin pedir confirmaciones repetidas para trabajo ya autorizado.
3. La última implementación solicitada está terminada: reseñas en MongoDB con hasta 3 imágenes opcionales de 2 MB cada una, alta y edición desde el panel de usuario, y carpeta de almacenamiento definida.
4. Después se explicó la utilidad de tres scripts/archivos de mantenimiento de `database`. La solicitud actual únicamente pide esta transferencia. No hay otra funcionalidad pendiente autorizada: esperar el siguiente encargo.
5. Respetar todos los cambios pendientes, incluidos los borrados que hizo el usuario. No ejecutar `git reset`, restaurar archivos, hacer pull/merge, importar SQL ni reemplazar bases por inferencia.
6. No mostrar credenciales. `config/api_keys.php`, `config/mail.local.php`, variables de entorno y configuraciones privadas no deben copiarse a documentación, respuestas, tests ni commits.
7. No hacer commit ni push salvo que se solicite. Los cambios descritos siguen sin commit.

## Estado actual de Git

- Rama `main`; HEAD local `084ebd3 Revert "Se modifico el proyecto"`.
- Commits locales anteriores: `ec8a7d1 Se modifico el proyecto`, `2cc025a Completar API de países y documentación de integración`.
- `git rev-list --left-right --count HEAD...origin/main` devolvió `0 6`: seis commits por detrás de la referencia remota almacenada. No se ejecutó fetch para esta transferencia; no es una afirmación sobre el servidor en tiempo real.
- Hubo anteriormente una recreación accidental con Vite, dependencias en directorios incorrectos y un revert. No volver a usar `create-vite` para instalar dependencias ni asumir que es seguro integrar todo el remoto sin revisar.
- Durante la conversación aparecieron cambios del usuario en `database/csv/productos.csv`, un nuevo `database/todoaqui_db.sql` y borrados de `database/datos_catalogo_demo.sql`, `database/modelo_nosql.json` y `database/todoaqui_150_clientes.sql`. Conservarlos; no fueron eliminaciones realizadas por la tarea de reseñas.
- Al iniciar esta transferencia, `docs/TRANSFERENCIA_ESTADO.md` tampoco existía y Git lo marcaba como eliminado. Se recreó ahora por solicitud explícita del usuario.

Captura del estado antes de recrear este documento:

```text
 M .gitignore
 M api/cuenta/index.php
 M api/productos/index.php
 M api/resenas/index.php
 M api/respuestas.php
 M app/controllers/ResenaController.php
 M app/models/Catalogo.php
 M app/models/Cuenta.php
 M app/models/Producto.php
 M app/models/Resena.php
 M app/models/Usuario.php
 M config/mongodb.php
 M database/csv/productos.csv
 D database/datos_catalogo_demo.sql
 M database/json/README.md
 D database/modelo_nosql.json
 D database/todoaqui_150_clientes.sql
 M docs/API_RECURSOS.md
 M docs/MODELO_NOSQL.md
 D docs/TRANSFERENCIA_ESTADO.md
 M frontend/package-lock.json
 M frontend/package.json
 M frontend/src/components/AddressInput.jsx
 M frontend/src/components/AdminCrud.jsx
 M frontend/src/components/CartDrawer.jsx
 M frontend/src/components/CategorySection.jsx
 M frontend/src/components/Header.jsx
 M frontend/src/components/Hero.jsx
 M frontend/src/components/ProductSection.jsx
 M frontend/src/components/QuickView.jsx
 M frontend/src/components/StoreImage.jsx
 M frontend/src/components/StoreSections.jsx
 M frontend/src/components/UserShared.jsx
 M frontend/src/data/adminSchemas.js
 M frontend/src/pages/UserPage.jsx
 M frontend/src/services/adminService.js
 M frontend/src/services/storeService.js
 M frontend/vite.config.js
?? app/services/ImagenProducto.php
?? app/services/ImagenesResena.php
?? app/services/ResenasMongo.php
?? config/imagenes.php
?? database/actualizar_imagenes_productos.php
?? database/imagenes_productos.json
?? database/preparar_resenas_mongo.php
?? database/todoaqui_db.sql
?? docs/IMAGENES_PRODUCTOS.md
?? docs/RESENAS_MONGODB.md
?? frontend/public/creditos-imagenes.html
?? frontend/public/productos/
?? frontend/src/components/ReviewImages.jsx
?? frontend/src/components/UserReviews.jsx
?? public/uploads/resenas/
?? tests/
```

No atribuir todos estos archivos a una sola tarea: hay trabajo previo y cambios del usuario mezclados. Examinar diferencias concretas antes de editar o preparar un commit.

## Entorno y comandos

- Windows / PowerShell; XAMPP.
- PHP: `C:\xampp\php\php.exe`.
- MariaDB CLI: `C:\xampp\mysql\bin\mysql.exe`.
- Base principal: `todoaqui_db`, conexión mediante `config/database.php`.
- Apache se comprobó en `http://localhost:8080`; Vite usa `http://localhost:5173`.
- Frontend React 19, React Router 7, Bootstrap 5; Sass fijado actualmente en `1.105.0`.
- `frontend/package.json`: React `^19.2.8`, Bootstrap `^5.3.8`, Vite `^8.3.0`. Leer package/lock si cambian.
- Ejecutar npm dentro de `frontend`, con `npm.cmd` para evitar restricciones de PowerShell.

```powershell
cd C:\xampp\htdocs\tienda_online\frontend
npm.cmd install
npm.cmd run dev
npm.cmd run lint
npm.cmd run build
```

`frontend/vite.config.js` prueba primero `http://localhost` y luego `http://localhost:8080`, comprobando la respuesta JSON de categorías. Es detección al iniciar Vite, no conmutación continua por petición. Build y preview no necesitan consultar la API. El proxy cubre `/tienda_online/api` y `/tienda_online/public/uploads/resenas`.

Durante este chat el ejecutor normal fallaba con `helper_unknown_error setup refresh`; los comandos funcionaron solicitando ejecución fuera del sandbox con una justificación breve. No asumir que esa condición persistirá en el nuevo chat. Escribir archivos con UTF-8 explícito; el Python predeterminado de Windows puede usar cp1252.

Herramientas locales usadas para pruebas:

- Python: `C:\Users\Estuardo\.cache\codex-runtimes\codex-primary-runtime\dependencies\python\python.exe`.
- Playwright: `C:\Users\Estuardo\.cache\codex-runtimes\codex-primary-runtime\dependencies\node\node_modules\playwright`, navegador `msedge` headless.
- MongoDB local para tests: `mongod` en PATH; se observó `C:\Program Files\MongoDB\Server\8.0\bin\mongod.exe`.
- La herramienta de navegador integrada falló al arrancar en este chat; se usó Playwright como alternativa. Consultar la habilidad de navegador si se vuelve a utilizar.

## Funcionalidades anteriores que deben conservarse

- Panel administrativo con CRUD y presentación de relaciones.
- Panel de usuario con perfil, direcciones, órdenes y detalle de factura/pago, lista de deseos, reseñas y devoluciones; enlaces con íconos.
- Inicio y catálogo conectados a MariaDB, carrito y checkout con dirección de facturación/envío, forma de pago y confirmación de pedido por correo.
- El usuario proporcionó anteriormente credenciales de Ethereal. La configuración privada del correo se preparó; el CSV ya no estaba presente. No se verificó de nuevo SMTP al crear esta transferencia. Ethereal es demostrativo: consultar la documentación del checkout antes de cambiar el correo.
- Países mediante `CountrySelect`, valor inicial Guatemala, lista en español y orden alfabético. API y configuración descritas en `docs/PAISES.md`.
- `.gitignore` conserva código de `app/services`; el usuario pidió ignorar únicamente los `.gitkeep` redundantes, no los directorios de código.
- `config/.htaccess` protege configuraciones privadas. `config/api_keys.php`, `config/mail.local.php` y el antiguo CSV de SMTP se excluyen de Git.

Documentos de referencia: `docs/PANEL_USUARIO.md`, `docs/CATALOGO_CHECKOUT.md`, `docs/PAISES.md`, `docs/CRUD_ADMINISTRACION.md`, `docs/API_RECURSOS.md`, `docs/CONVENCIONES.md`.

## Reseñas: MongoDB activo

Detalles completos: `docs/RESENAS_MONGODB.md`.

- `app/services/ResenasMongo.php`: conexión diferida, índices, contador, consultas, presentación y estadísticas.
- `app/models/Resena.php` y `app/controllers/ResenaController.php`: operaciones y reglas.
- `api/resenas/index.php`: CRUD con sesión y propiedad; `api/cuenta/index.php`: reseñas del usuario y productos que puede reseñar.
- `config/mongodb.php`: usa `MONGODB_URI`/`MONGODB_DATABASE` o la configuración privada existente; no exponerla al navegador.
- MongoDB guarda `Resenas` y un contador en `Contadores`. `ResenaID`, `UsuarioID` y `ProductoID` son enteros; fecha BSON UTC presentada en horario de Guatemala.
- Índices únicos de ResenaID y de UsuarioID/ProductoID. Una reseña por usuario/producto. Crear requiere compra en una orden Entregada.
- El propietario puede cambiar calificación, comentario e imágenes. El administrador puede moderar el estado de reseñas ajenas; no reescribir su contenido.
- Las ocultas se excluyen de consultas públicas y promedios. Se consultan desde la cuenta de su propietario.
- Los usuarios, productos, sesiones, permisos y compras siguen en MariaDB. No se duplican cambios de Usuarios/Productos hacia MongoDB: las referencias y nombres se resuelven en SQL.
- La tabla SQL Resenas es histórica; no recibe nuevas reseñas ni se usa como respaldo automático.
- Si MongoDB falla, reseñas responde 503; el catálogo mantiene productos y precios, con ResenasDisponibles=false. No inventar promedios ni escribir reseñas en SQL como alternativa.
- Se impide eliminar usuarios/productos que aún tengan reseñas MongoDB, además de las restricciones SQL.
- Los permisos Atlas fueron ajustados por el usuario y la preparación de índices/contador se completó anteriormente, conservando las 36 reseñas que había entonces. No se contó nuevamente Atlas al escribir esta transferencia.

### Imágenes opcionales de reseñas — última implementación

- Máximo **3 imágenes por reseña**, contando las conservadas y las nuevas.
- Máximo **2 MiB (2.097.152 bytes, inclusive) por archivo**, mostrado como 2 MB en la interfaz.
- JPG, PNG o WebP; validación del contenido real con finfo/getimagesize y límite adicional de 20 megapíxeles.
- Carpeta física: **`public/uploads/resenas`**.
- Ruta guardada: `/tienda_online/public/uploads/resenas/resena-<32 hex>.jpg/png/webp`.
- MongoDB guarda solamente las rutas en `Imagenes: []`, no binarios ni base64. Los documentos antiguos sin Imagenes funcionan como un arreglo vacío; no requieren migración.
- `app/services/ImagenesResena.php`: validación, nombres aleatorios, guardado y eliminación segura limitada a archivos de ese directorio.
- `config/imagenes.php`: `resenas_directorio`; variable opcional `RESENAS_IMAGENES_DIR` para el directorio físico en hosting.
- `.gitignore` excluye los archivos subidos y conserva `public/uploads/resenas/.gitkeep` y `.htaccess`. La carpeta debe tener permiso de escritura para PHP y formar parte de las copias de seguridad.
- `ReviewImages.jsx`: selector múltiple, miniaturas, contador y botones para quitar; `ReviewGallery`: galería de imágenes guardadas.
- `UserReviews.jsx`: alta y edición propias. Selecciona por nombre entre productos de órdenes entregadas sin reseña previa. Integrado en `UserPage.jsx`.
- `api/cuenta?recurso=productos-resenables` devuelve los productos comprados en órdenes entregadas del usuario de sesión; la API vuelve a validar la compra al guardar.
- `AdminCrud.jsx`/`adminSchemas.js`: alta administrativa con imágenes y galería en listado. Edición administrativa sigue destinada a moderación. El autor puede gestionar contenido desde su panel personal.
- `adminService.js` transporta también las escrituras del panel personal de reseñas; su nombre no implica saltarse permisos.
- Crear: POST multipart con `datos` JSON e `Imagenes[]` como archivos. Editar: POST multipart con `?id=ID&_method=PUT`. Las llamadas JSON anteriores siguen admitidas.
- En edición, Imagenes contiene las rutas que se conservan; omitirlo conserva todas, `[]` elimina las anteriores. No se aceptan rutas ajenas ni arbitrarias. Quitar una miniatura no borra el archivo hasta guardar.
- Campo interno Version para actualización atómica condicionada a la versión leída. No se muestra en las respuestas públicas/panel.
- Después de guardar se eliminan los archivos retirados; eliminar la reseña elimina sus imágenes. Errores determinados (validación, duplicado, conflicto) descartan las cargas nuevas. Si MongoDB deja un resultado incierto por desconexión, se conservan las cargas y se registra el incidente para revisar huérfanos: no hay transacción distribuida con el disco.
- PHP: upload_max_filesize >= 2M, post_max_size >= 8M y max_file_uploads >= 3. En desarrollo el proxy de Vite sirve la carpeta desde Apache.

## Imágenes del catálogo de productos

Detalles: `docs/IMAGENES_PRODUCTOS.md`.

La auditoría inicial encontró 108 productos: 8 con imagen y 100 sin ella. Se mantuvieron los ID 1, 2, 3, 5 y 7. Se corrigieron ID 4 (teclado RGB), 6 (monitor) y 8 (cámara de seguridad), cuyas imágenes no correspondían. Se completaron los 100 vacíos; se actualizaron 103 filas de la base principal con autorización del usuario, exclusivamente Productos.Imagen.

- 90 fotografías locales en `frontend/public/productos`; 95 rutas distintas entre locales y las 5 externas conservadas/reutilizadas.
- Fuentes con licencia: Wikimedia Commons, Pexels, Pixabay y las imágenes existentes de Unsplash. Créditos en `frontend/public/creditos-imagenes.html`, enlazados desde `StoreSections.jsx`.
- Son fotografías ilustrativas para productos ficticios de demostración, no certifican marcas, dimensiones, capacidades ni cantidades de accesorios. Se reutilizan algunas entre variantes.
- Las rutas locales son `/productos/archivo.jpg`; Vite las sirve y build las copia a dist/productos. Para hosting en subcarpeta hay que ajustar coherentemente las rutas base.
- Consulta SQL de solo lectura al generar este documento: **108 productos, 0 sin imagen**.

### Cargar imágenes de Productos desde el formulario

- `AdminCrud.jsx`: input type=file con vista previa; `adminSchemas.js` define el campo Imagen.
- JPG, PNG o WebP de hasta 5 MiB, máximo 20 megapíxeles.
- `adminService.js`: multipart con datos JSON y archivo Imagen; edición usa POST + _method=PUT.
- `api/productos/index.php` conserva la API JSON anterior y recibe multipart.
- `app/services/ImagenProducto.php`: valida archivo, genera `producto-<32 hex>.ext`, lo guarda y actualiza el producto en transacción SQL.
- Carpeta de desarrollo: `frontend/public/productos`; MongoDB no interviene en esta operación. MariaDB guarda `/productos/<archivo>`.
- Editar sin elegir otro archivo conserva la imagen actual. No se borran automáticamente las anteriores porque pueden ser compartidas o del catálogo versionado.
- Si falla el guardado SQL, se revierte y se elimina el archivo recién subido.
- `config/imagenes.php`: clave directorio y variable opcional `PRODUCTOS_IMAGENES_DIR`. En hosting debe apuntar a la carpeta física publicada como /productos, con permiso de escritura. Preservar las cargas durante despliegues.

## Consulta más reciente sobre archivos de database

El usuario preguntó si eran necesarios:

1. `database/actualizar_imagenes_productos.php`: mantenimiento CLI, aplica/revierte las rutas del catálogo inicial, valida ID/SKU/nombre/valor anterior, transacción e idempotencia.
2. `database/imagenes_productos.json`: manifiesto de 108 productos, rutas originales/nuevas y fuentes; es dependencia del script y respaldo de los valores anteriores.
3. `database/preparar_resenas_mongo.php`: mantenimiento CLI que prepara índices y contador MongoDB; no importa ni reemplaza reseñas.

Se respondió: no se necesitan para servir la tienda diariamente; es recomendable conservarlos en Git para mantenimiento/reproducibilidad y no ejecutarlos en cada inicio/despliegue. Los dos primeros ya se aplicaron y pueden detectar conflictos si después se editaron imágenes desde el panel. El alta de reseñas también prepara/verifica sus índices y contador. **No se solicitó borrar estos archivos.**

## Verificaciones realizadas

No es necesario repetir todas las pruebas al iniciar otro chat; ejecutarlas cuando los nuevos cambios lo justifiquen.

- PHP lint sobre servicios, modelos, controladores y endpoints modificados: correcto.
- `npm.cmd run lint` y `npm.cmd run build`: correctos al finalizar la implementación de imágenes de reseñas.
- `git diff --check`: correcto al finalizar.
- `tests/test_imagenes_productos.py`: 15 comprobaciones HTTP, base MariaDB y directorio temporales; alta, reemplazo, conservación, permisos, contenido falso, tamaño y limpieza tras fallos SQL.
- `tests/test_resenas_mongo.py`: última ejecución correcta con 64 respuestas HTTP. Crea MariaDB temporal y un mongod privado; no escribe en Atlas ni en todoaqui_db. Cubre CRUD, BSON, unicidad, permisos, compra entregada, moderación, agregados, referencias, concurrencia de altas y caída de MongoDB, además de imágenes, límite 3, tamaño máximo exacto, rutas ajenas, retirada y borrado.
- Una repetición intermedia de la prueba MongoDB falló en el conteo SQL esperado de reseñas históricas; se añadió diagnóstico y la ejecución siguiente pasó completa. No se estableció la causa de ese fallo aislado; si vuelve a ocurrir, revisar el diagnóstico y el entorno, no asumir que MongoDB debe escribir en SQL.
- Formulario de producto en navegador con API simulada: file input, vista previa, multipart y conservar imagen; sin tocar registros reales.
- Formularios de reseñas en navegador con API simulada: crear/editar, producto comprado, vista previa, quitar/conservar/agregar, rechazo del cuarto archivo y multipart; sin errores JS.
- Apache :8080 y Vite :5173 sirvieron correctamente un JPG temporal de public/uploads/resenas; el archivo temporal fue eliminado después.
- Auditoría de catálogo: las 95 rutas distintas cargaron, 0 marcadores de imagen ausente y 0 errores JS. Página de créditos con 90 entradas.

Tests versionables según .gitignore: `tests/test_resenas_mongo.py` y `tests/test_imagenes_productos.py`. Los demás tests/capturas locales permanecen ignorados; no añadir todo el directorio indiscriminadamente.

Los archivos auxiliares de búsqueda de imágenes, capturas y scripts de navegador están bajo `%TEMP%\todoaqui-imagenes`; son auxiliares, no dependencias de la tienda. Las ejecuciones de integración muestran sus propios directorios temporales y detienen los servidores/bases de prueba al terminar. No depender de IDs de sesiones de herramientas del chat anterior.

## Continuidad

La solicitud de transferencia queda satisfecha con este archivo. Antes de cualquier nueva funcionalidad, releer los archivos que afecte el cambio y confirmar su estado real. Las bases y archivos de usuario pueden cambiar entre chats. Conservar las diferencias presentes; no reimportar datos, preparar otro proyecto Vite ni intentar resolver la divergencia de Git sin que forme parte del próximo encargo.
