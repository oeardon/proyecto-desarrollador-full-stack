# APIs de Todo Aquí

Implementación procedural de los recursos pendientes, basada en el SQL de
database/crear_bd_tablas.sql. Producto y Categoría también utilizan las funciones
compartidas. Auth incluye login, logout y registro público de clientes.
El frontend conserva sus archivos existentes.

## Organización

- app/models: consultas SQL y operaciones PDO.
- app/controllers: validación y reglas de cada recurso.
- api/<recurso>/index.php: métodos HTTP, sesión, permisos y JSON.
- app/controllers/Validaciones.php: validaciones de texto, enteros, importes y fechas.
- app/models/Sesion.php: consulta del usuario actual, sin devolver contraseña.
- api/respuestas.php: respuestas, lectura de JSON y control de acceso.
- config/database.php: ahora también responde JSON con HTTP 500 si falla la conexión.

No se agregaron clases propias, frameworks ni un router. Los endpoints mantienen
sus rutas independientes. Las nuevas APIs vuelven a consultar Estado y TipoUsuario
en MariaDB: desactivar una cuenta o cambiar su rol tiene efecto sobre las siguientes
solicitudes aunque exista una cookie de sesión anterior.

## Convenciones HTTP

Base local: http://localhost/tienda_online/api/

GET /recurso/ lista registros.
GET /recurso/?id=5 consulta uno.
POST /recurso/ crea.
PUT /recurso/?id=5 actualiza.
DELETE /recurso/?id=5 elimina cuando lo permiten sus relaciones y reglas.

POST y PUT requieren Content-Type: application/json y un objeto JSON.
Un ID debe ser un entero positivo. Se usan respuestas:

- 200: consulta, actualización o eliminación correcta.
- 201: registro creado; incluye la clave primaria.
- 400: datos inválidos o referencia inexistente.
- 401: sesión inexistente o usuario inactivo.
- 403: operación no autorizada para el rol.
- 404: registro inexistente o ajeno al cliente.
- 405: método no admitido; incluye Allow.
- 409: duplicado, relación que impide borrar o conflicto de negocio.
- 415: tipo de contenido incorrecto.
- 500: error interno o de conexión; no expone la excepción al cliente.

Ejemplo: {"success":true,"data":[]}
Ejemplo de error: {"success":false,"message":"Debe iniciar sesión"}

No se añadió CORS. Para React hay que acordar el proxy de Vite o los orígenes
permitidos al integrar. La cookie de sesión debe acompañar las solicitudes.
El frontend no debe inferir permisos únicamente a partir de controles visibles.

## Permisos

| Recurso | Visitante | Cliente | Administrador |
| --- | --- | --- | --- |
| productos | Consultar | Consultar | CRUD |
| categorias | Consultar | Consultar | CRUD |
| usuarios | Sin acceso | Sin acceso | CRUD |
| proveedores | Sin acceso | Sin acceso | CRUD |
| promociones | Sin acceso | Sin acceso | CRUD |
| direcciones | Sin acceso | CRUD propio | CRUD de todos |
| ordenes | Sin acceso | Crear y consultar propias | Consultar, crear, cambiar estado y eliminar con restricciones |
| pagos | Sin acceso | Consultar propios | Registrar, cambiar estado y eliminar con restricciones |
| facturas | Sin acceso | Consultar propias | Crear, anular y eliminar anuladas |
| devoluciones | Sin acceso | Solicitar y consultar propias | Consultar, solicitar, cambiar estado y eliminar rechazadas |
| resenas | Consultar publicadas | Crear por compra entregada, editar y eliminar propias | Además moderar Estado y eliminar ajenas |
| wishlist | Sin acceso | Consultar, agregar y eliminar propias | Las mismas operaciones sobre su propia lista |

Pagos, facturas y devoluciones obtienen el propietario desde Ordenes.
Los listados privados filtran por usuario en SQL.
Usuarios nunca devuelve Contrasena. Su endpoint administrativo no reemplaza
registro.php: el registro público fija Cliente y Activo y no permite administrar cuentas.

## Autenticación

Los tres endpoints admiten solo POST; devuelven 405 y Allow: POST antes de conectar
a MariaDB para otros métodos. Login y registro requieren Content-Type: application/json.
Logout no necesita cuerpo ni conexión a la base de datos.

### Registro

POST /auth/registro.php:
{
  "Nombres": "Ana",
  "Apellidos": "Pérez",
  "Correo": "ana@example.com",
  "Telefono": "55550001",
  "Usuario": "ana",
  "Contrasena": "Ejemplo123!"
}

Los seis campos son obligatorios. Se validan tipos, correo y longitudes del SQL.
La contraseña debe tener entre 8 y 72 bytes y no contener caracteres nulos.
Se almacena con password_hash(). Sus espacios se conservan; los demás campos
de texto del registro se recortan en los extremos.

El servidor fija Cliente y Activo, independientemente de los valores enviados.
Comprueba duplicados de Correo, Telefono y Usuario; las restricciones UNIQUE cubren
también solicitudes simultáneas. Los duplicados devuelven 409.
Responde 201 con success, message y UsuarioID, sin devolver la contraseña.
Registrar no inicia sesión automáticamente. Las direcciones se agregan posteriormente
mediante api/direcciones después del login.

### Login

POST /auth/login.php acepta uno de estos cuerpos:

{"Usuario":"ana","Contrasena":"Ejemplo123!"}

{"Correo":"ana@example.com","Contrasena":"Ejemplo123!"}

Envíe Usuario o Correo, nunca ambos. Cada campo busca exclusivamente su columna,
evitando ambigüedad entre un nombre de usuario con forma de correo y otra cuenta.
Se conserva el acceso anterior por Usuario.

Solo admite cuentas Activo. Credenciales incorrectas y cuentas inactivas devuelven
el mismo mensaje con 401. Tipos o formatos incorrectos devuelven 400.
Login acepta una contraseña no vacía de hasta 72 bytes, sin carácter nulo.

Después de password_verify(), se renueva el ID de sesión y se guardan UsuarioID,
Usuario y TipoUsuario. La respuesta conserva la propiedad usuario con esos tres
campos y no incluye Contrasena.
Un intento con credenciales incorrectas vacía la sesión anterior.
Las respuestas indican que no deben almacenarse en caché.

### Logout

POST /auth/logout.php sin cuerpo. Vacía las variables, elimina la cookie con
sus mismos parámetros y destruye la sesión. Responde 200 también si ya se había
cerrado la sesión. Funciona aunque la conexión a MariaDB no esté disponible.

No se agregaron redirecciones, CORS ni sesion.php.

## Productos y categorías

GET de listado y detalle permanece público, incluso si la cookie corresponde
a un usuario inactivo. POST, PUT y DELETE exigen una sesión de administrador
activo y comprueban el rol actual en MariaDB.

Las consultas públicas conservan el comportamiento existente: incluyen registros
Activos e Inactivos. El filtro de visibilidad del catálogo sigue pendiente de definición.
El listado y detalle de Productos conservan el JOIN y el campo Categoria.

### Productos

POST mínimo:
{"CategoriaID":1,"Nombre":"Producto de ejemplo","Precio":"25.50"}

Cantidad toma cero; SKU, Descripcion e Imagen toman null si se omiten.
Estado inicial permanece Activo. Un SKU vacío se normaliza a null.
Se validan longitudes del SQL, enteros positivos para IDs, cantidad entera no negativa
y precio entre 0 y 99999999.99 con máximo dos decimales.

PUT conserva el contrato de todos los campos editables:
{
  "CategoriaID":1,
  "SKU":null,
  "Nombre":"Producto de ejemplo",
  "Descripcion":null,
  "Precio":"25.50",
  "Cantidad":10,
  "Imagen":null,
  "Estado":"Activo"
}

SKU duplicado devuelve 409 y categoría inexistente devuelve 400.
DELETE sigue siendo físico. DetalleOrdenes o Resenas pueden impedirlo con 409;
las relaciones declaradas ON DELETE CASCADE conservan el comportamiento del SQL.

### Categorías

POST mínimo: {"Nombre":"Electrónica"}

Descripcion y CategoriaPadreID toman null; Estado toma Activo.
Nombre es obligatorio y único, con máximo 100 caracteres.
Descripcion admite hasta 255 caracteres.
PUT conserva los campos omitidos; {"CategoriaPadreID":null} quita la categoría padre.
La categoría padre debe existir y no puede formar ciclos directos o indirectos.
Durante una edición se bloquea la jerarquía dentro de una transacción para validar
y guardar la relación de forma conjunta. Esta estrategia sencilla serializa las
ediciones de categorías y es adecuada para el tamaño del proyecto del curso.

DELETE es físico. Si hay productos asociados devuelve 409; si solo hay subcategorías,
su CategoriaPadreID pasa a null conforme al ON DELETE SET NULL.

## Usuarios, proveedores, promociones y direcciones

PUT admite los campos que se desean cambiar; conserva los restantes.
Esto está documentado explícitamente: Producto mantiene su contrato existente.

### Usuarios

POST:
{
  "Nombres": "Ana",
  "Apellidos": "Pérez",
  "Correo": "ana@example.com",
  "Telefono": "55550001",
  "Usuario": "ana",
  "Contrasena": "Ejemplo123!"
}

TipoUsuario por defecto Cliente; Estado por defecto Activo. Solo un administrador
puede usar este endpoint o elegir otro rol. Las contraseñas nuevas se almacenan
con password_hash(); en edición, omitir Contrasena o enviarla null la conserva.
Se exige entre 8 y 72 bytes para las contraseñas nuevas.
Correo, Telefono y Usuario duplicados devuelven 409.
No se permite eliminar, desactivar ni quitar permisos a la propia cuenta administrativa.

### Proveedores

POST mínimo: {"Nombre":"Proveedor de ejemplo"}

Opcionales: NIT, Contacto, Correo, Telefono, Direccion y Estado.
Los campos opcionales vacíos se convierten en null; un correo informado se valida.

### Promociones

POST:
{
  "Nombre": "Oferta de septiembre",
  "TipoDescuento": "Porcentaje",
  "ValorDescuento": "10.00",
  "FechaInicio": "2026-09-22 00:00:00"
}

Opcionales: Descripcion, FechaFin, RequiereCupon, CodigoCupon,
AplicaTodosProductos, Estado.
Fechas con formato YYYY-MM-DD HH:MM:SS. FechaFin no puede preceder a FechaInicio.
Porcentaje no puede superar 100. RequiereCupon exige CodigoCupon.
Los indicadores admiten true/false o 1/0.
Esta API administra las promociones; todavía no aplica descuentos a órdenes
ni administra la tabla puente ProductosPromociones.

### Direcciones

POST:
{
  "Direccion": "Calle 1, casa 2",
  "Ciudad": "Guatemala",
  "Subnacional": "Guatemala",
  "TipoDireccion": "Casa",
  "EsPrincipal": true
}

Pais toma Guatemala por defecto. CodigoPostal es opcional.
El cliente se obtiene de la sesión; un UsuarioID enviado por él se ignora.
El administrador debe indicar UsuarioID al crear.
No se permite transferir una dirección a otro usuario al editar.
Marcar una dirección principal desmarca las otras del mismo usuario en una transacción.

## Órdenes y detalles

POST de cliente:
{
  "DireccionPago": "Calle 1, casa 2",
  "DireccionEnvio": "Calle 1, casa 2",
  "Detalles": [
    {"ProductoID": 1, "Cantidad": 2},
    {"ProductoID": 3, "Cantidad": 1}
  ]
}

El administrador también debe indicar UsuarioID.
Se aceptan de 1 a 100 detalles y no se repiten productos.
Se comprueban productos activos y existencias; se toman los precios de MariaDB.
UsuarioID del cliente, PrecioUnitario, Total, Estado u otros importes recibidos
no sustituyen los datos calculados por el servidor.

La transacción guarda Ordenes, DetalleOrdenes y descuenta existencias de forma
conjunta. Si falla, rollBack revierte el conjunto. Los bloqueos FOR UPDATE evitan
que dos compras reserven simultáneamente las mismas existencias.
BCMath opera importes decimales exactos; está disponible en el PHP de XAMPP probado.
GET por ID incluye Detalles.

PUT admite únicamente {"Estado":"Confirmada"} y estas transiciones:

- Pendiente -> Confirmada o Cancelada.
- Confirmada -> Procesando o Cancelada.
- Procesando -> Enviada.
- Enviada -> Entregada.
- Entregada y Cancelada son finales.

Cancelar devuelve existencias una sola vez. No se permite cancelar con pagos
Completado o Reembolsado. DELETE solo admite órdenes Cancelada y respeta las FK.
Encabezado y detalles se eliminan en una sola transacción; una FK impide todo el borrado.

## Pagos

POST administrativo:
{
  "OrdenID": 1,
  "Monto": "24.70",
  "MetodoPago": "Efectivo",
  "ReferenciaPago": null,
  "Estado": "Pendiente"
}

Notas es opcional. Puede iniciar Pendiente o Completado.
El monto debe ser positivo y no superar el saldo de la orden.
PUT admite únicamente Estado:

- Pendiente -> Completado o Rechazado.
- Completado -> Reembolsado.

Al completar se vuelve a comprobar el saldo dentro de la transacción.
DELETE solo permite Pendiente o Rechazado.
Es un registro administrativo de pagos: no realiza cobros ni reembolsos bancarios.

## Facturas y detalles

POST administrativo:
{
  "OrdenID": 1,
  "NumeroFactura": "TA-0001",
  "Nombre": "Ana Pérez",
  "NIT": "CF",
  "Direccion": "Calle 1, casa 2"
}

NIT toma CF si se omite y Notas es opcional.
Importes y DetalleFacturas se copian de la orden; no se aceptan importes del navegador
como fuente de cálculo. Solo una factura Emitida por orden.
GET por ID incluye Detalles.
PUT solo admite {"Estado":"Anulada"}. DELETE solo admite facturas Anulada.
Es un documento interno del proyecto, sin integración de emisión fiscal.

## Devoluciones y detalles

POST:
{
  "OrdenID": 1,
  "Motivo": "Producto defectuoso",
  "Detalles": [
    {"DetalleOrdenID": 1, "Cantidad": 1, "Motivo": "No enciende"}
  ]
}

Solo se admiten órdenes Entregada y detalles pertenecientes a esa orden.
Se descuentan las cantidades de otras devoluciones no rechazadas para evitar
solicitar más de lo comprado. El importe se calcula a partir del detalle original.
Estado inicial Solicitada; el cliente no puede elegirlo ni fijar MontoReembolso.
GET por ID incluye Detalles.

PUT administrativo recibe Estado y, opcionalmente, Notas:

- Solicitada -> Aprobada o Rechazada.
- Aprobada -> Procesada o Rechazada.

DELETE solo permite Rechazada.
Procesada registra la gestión: no implica un reembolso bancario ni repone automáticamente
inventario, porque falta definir si un artículo devuelto puede revenderse.

## Reseñas en MongoDB

POST: {"ProductoID":1,"Calificacion":5,"Comentario":"Buen producto"}

Calificacion es un entero de 1 a 5. Comentario es opcional, con límite de aplicación
de 10000 caracteres. Se exige haber comprado el producto en una orden Entregada.
El índice único (UsuarioID, ProductoID) en MongoDB impide dos reseñas del mismo usuario para un producto.

GET /resenas/?ProductoID=1 filtra por producto.
GET público solo muestra Publicada y no devuelve UsuarioID, correo, teléfono ni nombre.
El propietario puede consultar su reseña Oculta por ID.
PUT del propietario admite Calificacion, Comentario e Imagenes; el administrador puede moderar
con {"Estado":"Oculta"} o {"Estado":"Publicada"}, sin reescribir el texto de otro usuario.

Las reseñas se almacenan en MongoDB y las compras se verifican en MariaDB. Se conservan los ID numéricos y las respuestas actuales. Las imágenes opcionales se envían mediante multipart/form-data (datos JSON e Imagenes[]), con un máximo de 3 archivos de 2 MiB cada uno. MongoDB guarda sus rutas en Imagenes. Para editar archivos se usa POST con _method=PUT e id; las rutas de imágenes conservadas deben pertenecer a la reseña. Título y preferencias de presentación del autor todavía no forman parte del contrato.

Si MongoDB no está disponible, la API de reseñas responde 503. El catálogo sigue mostrando productos e indica ResenasDisponibles=false. Véase [configuración y diseño](RESENAS_MONGODB.md).

## Wishlist

POST: {"ProductoID":1}
GET /wishlist/ lista los deseos del usuario autenticado.
GET /wishlist/?id=1 consulta el producto 1 en su lista.
DELETE /wishlist/?id=1 elimina el producto 1 de su lista.

Aquí id es ProductoID. No existe un ID autoincremental: la clave es UsuarioID + ProductoID.
No admite PUT porque solo se agrega o quita la relación. Un duplicado devuelve 409.

## Límites de esta entrega

- Las órdenes nuevas usan los valores por defecto de descuento, impuesto y envío (cero).
  Debe acordarse su cálculo antes de integrar un checkout definitivo.
- Facturas rechaza órdenes con cargos o descuentos adicionales aún no desglosados.
- No se implementaron rutas nuevas para ProductosProveedores o ProductosPromociones.
- No se cambiaron las tablas ni se ejecutó una migración de reseñas.
- Las operaciones de pago y devolución son registros internos, no conexiones externas.
- La recuperación de contraseña y un endpoint de consulta de sesión siguen pendientes.

## Pruebas

tests/test_api.py levanta un servidor PHP en loopback y copia app, api y config
a una carpeta temporal. Crea una BD con nombre todoaqui_test_<identificador>,
carga el SQL y utiliza el login existente para obtener cookies reales.

Comprueba métodos, JSON, permisos, propiedad, hash, duplicados, claves foráneas,
órdenes/detalles, inventario, estados, facturas, devoluciones, reseñas y wishlist.
Elimina exclusivamente la BD temporal al terminar y conserva un server.log en la copia
temporal para diagnóstico. No modifica todoaqui_db.

Ejecutar desde la raíz con MariaDB activo y Python disponible:

python tests/test_api.py

Por defecto usa C:\xampp\php\php.exe y C:\xampp\mysql\bin\mysql.exe,
con usuario root local sin contraseña, igual que esta instalación.
Opciones disponibles: --root, --php y --mysql.

Para ejecutar exclusivamente las pruebas de Producto y Categoría:

python tests/test_api.py --catalog-only

Estas pruebas también verifican las relaciones con wishlist y DetalleOrdenes,
y la pérdida de permisos de una sesión tras un cambio de rol en la base de datos.

Para ejecutar solo las pruebas de autenticación:

python tests/test_api.py --auth-only

Verifica registro, duplicados, hash, permisos, ambos métodos de login, regeneración
de sesión, cookies y cierre de sesión sin conexión a la base de datos.
