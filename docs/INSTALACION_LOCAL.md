# Instalación y ejecución local

Esta guía corresponde al entregable local, no a los archivos de hosting de `build`. No requiere clonar ni recrear Git.

## Requisitos

| Componente | Requisito comprobable en los archivos |
| --- | --- |
| XAMPP, Apache y MariaDB | Backend PHP y base relacional; ruta habitual `C:\xampp\htdocs\proyecto-desarrollador-full-stack`. |
| PHP | Dependencias Composer para PHP 8.1 o superior dentro de sus rangos; comprobar con `composer check-platform-reqs`. |
| Extensiones | PDO MySQL, BCMath para dinero, cURL para países, OpenSSL para SMTP TLS, fileinfo para imágenes y mongodb. |
| MongoDB PHP | El lockfile fija mongodb/mongodb 2.4.2 y exige ext-mongodb `^2.4`; una extensión 1.x no satisface esta copia. |
| Node y npm | El Vite instalado declara Node `^20.19.0` o `>=22.12.0`. |
| Composer | Instalación reproducible mediante `composer.lock`. |
| Servicios externos | Atlas, Ethereal y REST Countries con configuración privada y acceso de red. |
| Pruebas | Python; `mongod` para reseñas aisladas; Playwright y Edge para interfaz. |

Comprobaciones sin mostrar configuración privada:

```powershell
Set-Location 'C:\xampp\htdocs\proyecto-desarrollador-full-stack'
C:\xampp\php\php.exe -v
C:\xampp\php\php.exe -m
node --version
npm.cmd --version
composer check-platform-reqs
```

PHP CLI y Apache pueden cargar distintos `php.ini`; comprobar ambos ante diferencias de extensiones.

## Dependencias

Conservar `composer.lock` y `frontend/package-lock.json`. Si las dependencias funcionan no hace falta reinstalarlas. Para una copia nueva sin ellas:

```powershell
composer install
npm.cmd --prefix frontend ci
```

El `package.json` raíz delega desarrollo, lint y compilación a frontend. Su `postinstall` ejecuta una instalación adicional en frontend. No ejecutar actualizaciones de dependencias ni generadores de Vite para una puesta en marcha ordinaria.

## Bases y configuración

Iniciar MariaDB. Para una instalación nueva elegir una de las alternativas de [Base de datos](BASE_DATOS.md): dump a base vacía o esquema y CSV. No combinar ambas ni reimportar sobre la base existente. Revisar en privado la conexión de `config/database.php`; los endpoints consumen la variable PDO `$conexion`.

| Configuración | Finalidad y precedencia |
| --- | --- |
| `config/database.php` | Conexión MariaDB. |
| `MONGODB_URI` | Tiene precedencia sobre la URI privada. |
| `$mongoURI` en `config/api_keys.php` | URI alternativa de Atlas. |
| `MONGODB_DATABASE` | Base MongoDB; por defecto `todoaqui_db`. |
| `$restCountriesApiKey` en `config/api_keys.php` | Token utilizado por el backend de países. |
| `config/mail.php` | Lee variables SMTP y luego aplica `config/mail.local.php`. |
| `config/mail.local.example.php` | Plantilla de configuración, sin credenciales reales. |
| `PRODUCTOS_IMAGENES_DIR` | Carpeta física de productos; por defecto `frontend/public/productos`. |
| `RESENAS_IMAGENES_DIR` | Carpeta de reseñas; por defecto `public/uploads/resenas`. |

PHP no carga `.env` automáticamente. No suponer que `database.local.php` se carga por aparecer en `.gitignore`. No copiar secretos a documentación o capturas. `config/.htaccess` deniega los nombres `api_keys.php` y `mail.local.php`, no todos los posibles archivos privados; depende de que Apache aplique esas reglas. `.gitignore` no protege descargas HTTP ni archivos comprimidos.

### Atlas

Configurar usuario de base, acceso de red y permisos sobre `Resenas` y `Contadores`. Ese usuario no es la cuenta de la tienda. Seguir [Reseñas](RESENAS_MONGODB.md) para índices/contador cuando sea necesario: la preparación sí escribe en MongoDB. No requiere importar todas las colecciones JSON.

### Ethereal

Si falta `mail.local.php`, copiar la plantilla y completar privadamente `enabled`, `host`, `port`, `username`, `password`, `encryption`, `from`, `name`. La instalación local usa Ethereal según el usuario; la plantilla puede mostrar otro proveedor.

Variables admitidas: `SMTP_ENABLED`, `SMTP_HOST`, `SMTP_PORT`, `SMTP_USERNAME`, `SMTP_PASSWORD`, `SMTP_ENCRYPTION`, `SMTP_FROM`, `SMTP_FROM_NAME`. El archivo local tiene precedencia. Apache puede requerir reinicio para recibir cambios de entorno.

Ethereal captura el correo de prueba. El envío sucede después de guardar la compra; crear un pedido modifica datos e inventario. Recuperar el mismo intento no vuelve a enviar correo. Véase [Checkout](CATALOGO_CHECKOUT.md).

## Arranque y compilación

1. Iniciar Apache y MariaDB en XAMPP.
2. Ejecutar `npm.cmd run dev` desde la raíz.
3. Abrir la URL informada por Vite; el puerto inicial es 5173.

Vite comprueba `http://localhost` y después `http://localhost:8080` consultando `/proyecto-desarrollador-full-stack/api/categorias/index.php`. Si ninguno devuelve la respuesta esperada, detiene el inicio. El proxy dirige la API y las imágenes de reseñas al Apache detectado. Conservar el nombre de carpeta `proyecto-desarrollador-full-stack`, usado por las rutas. No abrir el HTML directamente como archivo.

```powershell
npm.cmd run lint
npm.cmd run build
```

La compilación genera `frontend/dist`, distinta del `build` raíz del hosting. No necesita consultar la API. `npm.cmd --prefix frontend run preview` sirve la salida, pero la configuración actual no declara proxy de API para preview; no equivale a una instalación integrada.

## Diagnóstico

| Síntoma | Revisar |
| --- | --- |
| Vite no encuentra API | Apache/MariaDB, puerto, ruta y respuesta de categorías. |
| Error Composer | PHP/extensiones frente al lockfile. |
| Reseñas no disponibles | URI, permisos, red de Atlas y dependencias. |
| Países no cargan | Clave, cURL, conexión y directorio temporal escribible. |
| Pedido sin correo | Configuración SMTP; no repetir la compra para reenviar. |
| Imagen rechazada | Contenido, tamaño, límites PHP y permisos. |

Productos admiten hasta 5 MB por imagen; reseñas hasta tres de 2 MiB, con máximo de 20 megapíxeles por imagen. Configurar PHP para esos tamaños, por ejemplo `upload_max_filesize=5M`, `post_max_size=8M`, `max_file_uploads>=3`; el límite agregado debe cubrir también los campos de la petición.

[Volver al índice documental](README.md).
