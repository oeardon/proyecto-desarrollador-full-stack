# Pruebas y evidencia

## Estado de la revisión

El 26/09/2026 se contrastaron archivos y documentación. Esta actualización no ejecutó suites HTTP, compras, envíos ni escrituras en bases. El usuario confirmó conexión local a Atlas y una orden con correo Ethereal. Los resultados numéricos de guías anteriores son históricos.

## Frontend

Desde la raíz:

```powershell
npm.cmd run lint
npm.cmd run build
```

`tests/test_frontend_structure.mjs` no existe. El script raíz `test:structure` aún lo referencia: no usarlo como comprobación disponible. Esta actualización no modifica `package.json`.

## Backend

| Entrada | Cobertura/requisitos |
| --- | --- |
| `python tests/test_api.py` | Suite histórica HTTP/SQL; PHP, Python y MariaDB con permisos para crear/eliminar bases temporales. |
| `--catalog-only`, `--auth-only` | Opciones del mismo ejecutor para catálogo básico/autenticación. |
| `--admin-only`, `--user-only`, `--checkout-only` | Opciones para administración, usuario y compra. Usar una modalidad por ejecución. |
| `python tests/test_resenas_mongo.py` | MariaDB temporal y `mongod` local privado; requiere extensión/biblioteca MongoDB y `mongod` en PATH. No escribe en Atlas. |
| `python tests/test_imagenes_productos.py` | PHP, MariaDB y carpeta de cargas temporales; utiliza una foto de `frontend/public/productos` como fixture. |

`test_api.py` acepta `--root`, `--php`, `--mysql`. Las suites especializadas admiten `TEST_PHP` y `TEST_MYSQL`; por defecto usan XAMPP. Los ejecutores SQL utilizan root local sin contraseña; otras instalaciones pueden necesitar adaptar el ejecutor.

Las bases tienen nombres generados y los logs quedan en carpetas temporales. El aislamiento SQL no garantiza aislamiento de servicios externos: `test_api.py` copia `config`, no prepara MongoDB privado y contiene casos anteriores a esa integración. Antes de ejecutarlo en modalidades que alcancen reseñas, revisar/aislar esa configuración; para reseñas usar la suite dedicada con URI local.

El modo checkout reemplaza el correo por configuración de prueba y utiliza SMTP local. Sus expectativas históricas sobre reseñas del catálogo pueden necesitar adaptación al modelo actual.

Limitación confirmada por lectura: la suite general exige `Cache-Control: no-store` en auth y `api/auth/logout.php` no establece esa cabecera. Puede fallar ahí; no se corrigió código ni se declaró aprobada.

## Interfaz con API simulada

Después de compilar `frontend/dist`, con Playwright y Edge:

```powershell
node tests/admin_ui.cjs 'RUTA_AL_MODULO_PLAYWRIGHT'
node tests/user_ui.cjs 'RUTA_AL_MODULO_PLAYWRIGHT'
node tests/checkout_ui.cjs 'RUTA_AL_MODULO_PLAYWRIGHT'
```

Sustituir el argumento por la ruta real del módulo. Sirven el frontend y simulan API; no prueban Atlas/Ethereal reales. Cubren paneles, tablas, checkout, errores y móvil. Las capturas pueden reemplazarse al ejecutarlos.

## Casos manuales

| ID | Procedimiento | Resultado esperado |
| --- | --- | --- |
| UI01 | Iniciar XAMPP/Vite | Inicio sin pantalla en blanco. |
| UI02 | Buscar, filtrar y abrir vista rápida | Productos/datos coherentes; vacío o aviso de reseñas no disponibles cuando corresponda. |
| UI03 | Agregar al carrito, ajustar y recargar | Cantidades conservadas y precios del catálogo. |
| AUTH01 | Registrar, entrar, consultar sesión y salir | Sesión/permisos correctos. |
| CHECK01 | Checkout sin sesión | Login dentro del flujo. |
| CHECK02 | Preparar compra de prueba | Direcciones, nombre/NIT, método y resumen visibles. |
| CHECK03 | Confirmar compra autorizada | Orden/factura/pago, stock descontado y confirmación propia. |
| CHECK04 | Recuperar mismo intento | Misma orden, sin repetir descuento ni correo. |
| MAIL01 | Revisar Ethereal | Confirmación capturada con datos de pedido. |
| USER01 | Editar perfil/direcciones, ver órdenes | Datos propios y dirección principal consistente. |
| USER02 | Agregar/retirar favorito | Deseos persistidos y sincronizados. |
| REVIEW01 | Reseñar compra entregada | Calificación válida, hasta tres fotos y unicidad usuario/producto. |
| REVIEW02 | Moderar | Oculta fuera de promedios/listados públicos, accesible a su dueño. |
| RETURN01 | Solicitar devolución | Cantidades válidas y estado Solicitada. |
| ADMIN01 | Gestionar recursos | Roles, relaciones y transiciones respetados. |
| IMG01 | Cargar imagen | Validación y conservación al editar sin nueva foto. |
| COUNTRY01 | Abrir selector | Carga, orden, valor conservado y reintento. |
| MOBILE01 | Revisar a 375 px | Navegación, tablas y formularios utilizables. |

Los casos que escriben deben ejecutarse en datos previstos para pruebas. Registrar fecha, entorno, resultado y evidencia; no marcar aprobados por existir el guion. [Utilidades](UTILIDADES.md) distingue consultas y scripts que modifican código.

[Volver al índice documental](README.md).
