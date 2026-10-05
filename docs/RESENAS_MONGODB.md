# Reseñas en MongoDB

Revisión documental: 26/09/2026, sobre la copia local. Las validaciones anteriores se conservan como antecedentes; no se repitieron durante esta actualización.

## Distribución de datos

MongoDB es el almacenamiento activo de `Resenas`: creación, lectura, edición, moderación y eliminación. `UsuarioID` y `ProductoID` son enteros que referencian MariaDB. `ResenaID` sigue siendo entero para conservar las URLs, formularios y documentos importados. Las fechas se guardan como BSON Date UTC y se presentan en horario de Guatemala.

MariaDB continúa siendo la fuente de usuarios, productos, sesiones, permisos y compras. Solo un usuario con una orden entregada del producto puede crear una reseña. Puede editar su calificación, comentario e imágenes; el administrador puede moderar reseñas ajenas pero no cambiar su contenido. Las ocultas no aparecen públicamente ni participan en el promedio.

No se duplican cambios de Usuarios y Productos en MongoDB: no es necesario para estas pantallas. La sesión se verifica contra Usuarios en SQL y los nombres de productos del panel personal se consultan en una sola consulta SQL al mostrar las reseñas. Los cambios se reflejan sin sincronización eventual ni copias de contraseñas, correos o datos personales. Las colecciones Usuarios/Productos importadas anteriormente no se consultan ni actualizan por esta integración. Si otro consumidor necesitara esas copias, requeriría una sincronización independiente con reintentos y control de versiones, no dos escrituras directas por petición.

La aplicación impide eliminar un usuario/producto mientras tenga reseñas en MongoDB. Las restricciones SQL existentes siguen vigentes. No hay claves foráneas ni transacciones distribuidas entre ambas bases: no se deben borrar o reasignar IDs manualmente desde Compass/SQL sin revisar sus referencias.

## Configuración y permisos

Se usa la URI privada `$mongoURI` de `config/api_keys.php`. Opcionalmente el servidor puede definir `MONGODB_URI` y `MONGODB_DATABASE` (por defecto `todoaqui_db`). Nunca se entrega la URI al navegador. Se necesitan la extensión PHP `mongodb` y las dependencias de `composer install`.

El usuario de conexión necesita permisos de lectura/escritura y creación de índices en `Resenas`, y lectura/escritura en `Contadores`. En Atlas se puede conceder `readWrite` sobre la base `todoaqui_db`, o un rol personalizado limitado a esas colecciones. La configuración de roles se hace en Database Access, no en la tabla Usuarios de la tienda.

Desde la raíz del proyecto, preparar índices y contador:

```powershell
C:\xampp\php\php.exe database/preparar_resenas_mongo.php --aplicar
```

Este comando no importa ni reemplaza reseñas. Crea índices únicos de `ResenaID` y `(UsuarioID, ProductoID)`, índices de búsqueda, y avanza el contador al máximo ID existente sin reducirlo. El alta también verifica esta preparación. El contador se incrementa atómicamente; puede tener saltos por intentos duplicados y nunca se debe reiniciar al borrar reseñas.

Como antecedente histórico, en la verificación inicial había 36 reseñas en SQL y MongoDB, con los mismos IDs, referencias, calificaciones, comentarios y estados. No fue necesaria una importación. La tabla SQL Resenas se conserva intacta como copia histórica: deja de actualizarse y no se usa como respaldo automático en fallos. Sus claves foráneas siguen pudiendo impedir borrar usuarios/productos históricos. Cualquier archivo o tabla de copia requiere una política de conservación aparte.

Durante la integración original, los permisos de Atlas fueron ajustados y se ejecutó correctamente la preparación de índices y contador sobre la base configurada. Se conservaron las 36 reseñas existentes. Las altas, modificaciones y eliminaciones se comprobaron en bases temporales para no introducir reseñas ficticias en la tienda.

## Fallos y API

Los contratos de `api/resenas` y `api/cuenta?recurso=resenas` conservan sus campos. No se exponen `_id`, documentos internos ni UsuarioID en respuestas públicas. Datos duplicados devuelven 409; indisponibilidad de MongoDB devuelve 503 sin detalles privados de conexión. No se guardan reseñas nuevas en SQL como alternativa.

El catálogo agrega calificaciones publicadas desde MongoDB. Si este falla, entrega productos/precios normalmente, con `ResenasDisponibles: false` y calificación/conteo nulos. Las tarjetas y la vista rápida indican que las reseñas no están disponibles; no presentan una calificación de cero inventada.

## Verificación reproducible

```powershell
python tests/test_resenas_mongo.py
```

Requiere PHP, MariaDB local de XAMPP y `mongod` en PATH. Acepta `TEST_PHP` y `TEST_MYSQL` para sus ejecutables. Usa una base SQL de nombre aleatorio y un proceso MongoDB local privado en un puerto libre; no escribe en Atlas ni en la base SQL de la tienda. Elimina la base SQL temporal y detiene sus procesos al terminar; conserva logs en el directorio temporal mostrado.

La suite cubre respuestas HTTP y comprobaciones de almacenamiento; no se fija un recuento como resultado de esta revisión: BSON y IDs importados, CRUD, compra entregada, privacidad, propiedad, moderación, agregaciones, nombres actuales desde SQL, ausencia de duplicación de usuarios/productos, referencias al eliminar, altas concurrentes, y funcionamiento del catálogo durante una caída de MongoDB.

Referencia: [findOneAndUpdate de la biblioteca oficial PHP](https://www.mongodb.com/docs/php-library/current/reference/method/mongodbcollection-findoneandupdate/).

## Imágenes opcionales

El panel de usuario permite agregar reseñas de productos de órdenes entregadas y editar las propias, con vista previa de las fotografías y botones para quitarlas. El formulario administrativo de alta también admite imágenes; la edición administrativa mantiene únicamente la moderación del estado de reseñas ajenas.

- Máximo **3 imágenes en total por reseña**, contando las conservadas y las nuevas.
- Máximo **2 MiB (2.097.152 bytes) por imagen**, inclusive. La interfaz lo muestra como 2 MB.
- Formatos JPG, PNG y WebP, comprobados por contenido en PHP, no por el nombre enviado. Límite adicional de 20 megapíxeles.
- Los archivos se guardan en **`public/uploads/resenas`**, con nombres aleatorios `resena-<32 caracteres hexadecimales>.jpg/png/webp`.
- MongoDB guarda las rutas en `Resenas.Imagenes`, un arreglo de 0 a 3 cadenas. No almacena binarios ni base64. Los documentos antiguos sin ese campo se presentan con `Imagenes: []`; no requieren migración.
- Ejemplo: `"Imagenes": ["/proyecto-desarrollador-full-stack/public/uploads/resenas/resena-0123456789abcdef0123456789abcdef.jpg"]`.

Al editar se envían las rutas que se desea conservar; solo se aceptan rutas que ya pertenecen a esa reseña. Omitir `Imagenes` conserva todas; enviar `[]` quita todas las anteriores. Los archivos nuevos se agregan después, siempre respetando el límite. Quitar una miniatura y cancelar el formulario no modifica MongoDB ni elimina archivos.

Cada modificación de contenido incrementa un contador interno `Version` mediante una actualización atómica condicionada a la versión leída. Un conflicto devuelve 409 y se descartan los archivos nuevos de ese intento. Los archivos retirados se eliminan después de guardar correctamente; al eliminar la reseña también se eliminan sus imágenes. Si MongoDB deja un resultado incierto por una caída de conexión, se conservan los archivos recién cargados para evitar borrar imágenes que podrían haber quedado referenciadas; se registra el incidente para revisar huérfanos. No existe una transacción distribuida entre MongoDB y el sistema de archivos.

### Transporte y despliegue

`api/resenas/index.php` recibe `multipart/form-data` con `datos` (JSON) e `Imagenes[]` (archivos). Crear usa POST; editar usa POST con `?id=ID&_method=PUT`. El JSON de alta contiene ProductoID, Calificacion, Comentario e Imagenes vacío; el de edición contiene Calificacion, Comentario y las rutas conservadas. Las peticiones JSON anteriores siguen funcionando.

La carpeta de cargas pertenece al backend y persiste independientemente de `frontend/dist`. Vite redirige `/proyecto-desarrollador-full-stack/public/uploads/resenas` al mismo Apache que la API. En hosting, publicar esa ruta y conceder permiso de escritura a PHP. `RESENAS_IMAGENES_DIR` permite cambiar el directorio físico desde `config/imagenes.php`, manteniendo su correspondencia con la URL publicada. Si se usa control de versiones, excluir las cargas y conservar marcadores/reglas `.htaccess`; la copia actual no tiene Git activo. No confundir esa exclusión con el respaldo o la entrega de las fotografías existentes. Incluir la carpeta de cargas en las copias de seguridad junto con MongoDB.

PHP debe permitir `upload_max_filesize` de al menos `2M`, `post_max_size` de al menos `8M` y `max_file_uploads` de al menos 3. Las reglas de aplicación siguen limitando cada imagen a 2 MiB aunque PHP admita más.

### Pruebas de imágenes

La prueba aislada también verifica: alta con tres archivos, rechazo del cuarto y de imágenes demasiado grandes, aceptación de exactamente 2 MiB, rechazo de contenido falso, conservación al editar texto, sustitución, eliminación, rechazo de rutas ajenas, permisos del autor y limpieza de archivos tras un conflicto de unicidad. Las reseñas y fotografías usadas en las pruebas no se escriben en Atlas ni en las carpetas de cargas reales.

[Volver al índice documental](README.md).
