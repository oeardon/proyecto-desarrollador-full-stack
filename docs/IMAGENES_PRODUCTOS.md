# Imágenes del catálogo

Revisión documental: 26/09/2026, sobre la copia local. Las validaciones anteriores se conservan como antecedentes; no se repitieron durante esta actualización.

Auditoría histórica: 25 de septiembre de 2026. Base local `todoaqui_db`, tabla `Productos`. Los recuentos y resultados descritos corresponden a esa fecha, no a una nueva consulta de la base.

Se revisaron los 108 productos: 8 tenían imagen y 100 estaban vacíos. Se conservaron las imágenes de los ID 1, 2, 3, 5 y 7. Se corrigieron el teclado RGB (ID 4: antes mostraba un teclado sin iluminación), el monitor (ID 6: mostraba una computadora todo en uno) y la cámara de seguridad (ID 8: mostraba código). Los 100 productos restantes reciben una imagen ilustrativa del tipo de producto.

Los nombres y especificaciones son ficticios: todos estos registros se describen como productos de demostración. Las fotos no certifican marca, capacidad, dimensiones, conectividad, cantidad de piezas ni accesorios incluidos. Se reutilizan algunas imágenes entre variantes. Para vender productos reales deben sustituirse por fotografías del inventario real.

## Archivos y licencias

- `frontend/public/productos/`: fotografías incorporadas al proyecto, incluidas como archivos del entregable y utilizadas por `npm.cmd run build`.
- `frontend/public/creditos-imagenes.html`: recurso ausente en esta copia, aunque el pie conserva el enlace. La galería descrita en la auditoría histórica no se puede dar por incluida; debe recuperarse o reconstruirse a partir de fuentes verificadas.
- `database/imagenes_productos.json`: los 108 registros auditados, rutas anteriores y nuevas, y metadatos de las fuentes. También sirve como respaldo de los valores anteriores de `Imagen`.
- Fuentes: Wikimedia Commons, Pexels y Pixabay; se conservan imágenes de Unsplash. Cada fotografía conserva su propia licencia, independiente de la del código. Las versiones de tamaño reducido provienen de los proveedores; no se editó el contenido.

Las rutas nuevas locales tienen la forma `/productos/archivo.jpg`. Vite sirve esa carpeta durante el desarrollo y la copia a `dist/productos` al compilar. Al desplegar, publicar el contenido completo de `frontend/dist` en la raíz del sitio, igual que el resto de los recursos actuales del frontend. Un despliegue en un subdirectorio requiere ajustar conjuntamente las rutas base del frontend y de estas imágenes. Las fotografías antiguas de Unsplash y sus reutilizaciones conservan sus URLs externas.

## Aplicar en otra instalación

Desde la raíz del proyecto, con las imágenes ya presentes y después de revisar la base de destino:

```powershell
C:\xampp\php\php.exe database/actualizar_imagenes_productos.php --verificar
C:\xampp\php\php.exe database/actualizar_imagenes_productos.php --aplicar
```

El script usa `config/database.php`, funciona solo por consola y modifica exclusivamente `Productos.Imagen`. Comprueba ID, SKU, nombre y valor previo antes de cambiar cualquier fila. Se ejecuta dentro de una transacción y puede repetirse: omite imágenes ya aplicadas. Si otra persona cambió una imagen, aborta toda la operación para que se revise el conflicto. No cambia existencias, precios ni datos de pedidos. No recrea ni vuelve a importar la base de datos.

Para restaurar las rutas anteriores:

```powershell
C:\xampp\php\php.exe database/actualizar_imagenes_productos.php --revertir
```

La reversión también comprueba que nadie haya sustituido posteriormente las imágenes. Las fotografías locales se mantienen para no borrar archivos de otras instalaciones. Los datos de demostración originales no se reimportan: esta actualización se aplica después de su carga. No hace falta duplicar imágenes en MongoDB: los datos actuales del producto se consultan desde MariaDB.

## Validación histórica

Actualización aplicada: 103 filas; 108 productos con imagen y cero campos ajenos a `Imagen` modificados. Una segunda verificación reporta cero cambios pendientes. La API devuelve los 108 productos; el navegador cargó correctamente las 95 rutas distintas (90 locales y 5 externas), sin errores JavaScript ni marcadores de imagen ausente. En aquella versión el enlace de créditos abría una galería de 90 entradas; el archivo no está en la copia actual. `php -l`, `npm.cmd run build` y `npm.cmd run lint` finalizaron correctamente.

La revisión documental no descargó imágenes ni reconstruyó créditos. El mapa JSON conserva fuentes para revisar el recurso ausente.

## Cargar imágenes desde Administración

Agregar y editar Productos ahora usa un selector de archivo con vista previa. Admite JPG, PNG y WebP, hasta 5 MB y 20 megapíxeles. La imagen es opcional al crear; al editar sin seleccionar un archivo se conserva la ruta actual.

La petición usa `multipart/form-data`, un campo `datos` con JSON y un archivo `Imagen`. Para editar se envía POST con `?id=ID&_method=PUT`, ya que PHP procesa `$_FILES` en POST. La API mantiene los métodos JSON anteriores para sus otros clientes. Toda escritura exige sesión de administrador.

El servidor valida el contenido real, genera un nombre `producto-<identificador aleatorio>.jpg/png/webp`, copia el archivo a `frontend/public/productos` y guarda `/productos/<nombre>` en `Productos.Imagen`. Si falla el guardado en MariaDB, revierte la operación y elimina únicamente el archivo recién subido. Las imágenes anteriores no se borran porque pueden ser compartidas por otros productos o formar parte del catálogo incluido en el entregable.

### Hosting

`config/imagenes.php` define el directorio físico. En desarrollo utiliza `frontend/public/productos`. En el hosting, establecer `PRODUCTOS_IMAGENES_DIR` con la ruta absoluta de la carpeta publicada como `/productos` (o adaptar el valor predeterminado en ese archivo). PHP necesita permiso de escritura en ella. Mantener esa carpeta y sus archivos al desplegar nuevas versiones; no sustituir las cargas existentes por el contenido de una compilación anterior. Configurar `upload_max_filesize` en al menos `5M` y `post_max_size` por encima de ese tamaño, por ejemplo `8M`.

### Pruebas de la carga

`tests/test_imagenes_productos.py` usa una base MariaDB temporal, servidor PHP local y carpeta de cargas aislada. Comprueba carga, sustitución, conservación, permisos, contenido falso, tamaño máximo y limpieza tras conflictos SQL. No modifica el catálogo principal. Puede ejecutarse con Python y los binarios de XAMPP; `TEST_PHP` y `TEST_MYSQL` permiten cambiar sus ubicaciones. También se verificó el formulario en navegador con API simulada, y pasaron PHP lint, ESLint y la compilación de Vite.

[Volver al índice documental](README.md).
