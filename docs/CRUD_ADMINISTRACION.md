# Administración: tablas y formularios

El portal de Cuenta ofrece las cinco operaciones para las 17 tablas. Se requiere una sesión de Administrador; los servicios PHP vuelven a comprobar el rol.

- Mostrar y buscar presentan tablas con Agregar, Editar y Eliminar.
- Editar desde una fila carga el registro mediante sus identificadores en la URL.
- Editar y Eliminar desde el panel primero solicitan los identificadores.
- Eliminar desde una fila solicita confirmación y permanece en el listado. Desde el panel muestra primero los datos de solo lectura y luego solicita confirmación.
- Las relaciones utilizan ambos componentes de su clave: producto/proveedor, producto/promoción o usuario/producto.
- La contraseña nunca se muestra; dejarla vacía al editar conserva la existente.

## Servicios y reglas

`frontend/src/data/adminSchemas.js` define campos y restricciones de la interfaz. `AdminCrud.jsx` implementa la navegación y los formularios; `adminService.js` conecta con las API existentes.

El nuevo servicio `/tienda_online/api/admin/index.php?recurso=...` admite `productos-proveedores`, `productos-promociones`, `lista-deseos`, `detalle-ordenes`, `detalle-facturas` y `detalle-devoluciones`.

GET sin identificadores devuelve todos los registros. GET, PUT y DELETE de un registro utilizan el nombre de cada clave como parámetro (por ejemplo `DetalleOrdenID=12`, o `ProductoID=2&ProveedorID=3`). POST y PUT reciben JSON. En PUT de relaciones se envían las nuevas claves en el cuerpo y las originales en la URL.

Las líneas admiten operaciones independientes dentro de transacciones:

| Tabla | Campos de entrada | Restricciones |
| --- | --- | --- |
| DetalleOrdenes | OrdenID, ProductoID, Cantidad | Orden pendiente sin pagos, facturas ni devoluciones y sin cargos o descuentos adicionales. Ajusta existencias y recalcula totales. |
| DetalleFacturas | FacturaID, DetalleOrdenID, Descripcion, Cantidad | Factura emitida de orden pendiente sin pagos. La referencia debe pertenecer a esa orden y la cantidad no puede exceder la original. Calcula precios e importes desde la línea original. |
| DetalleDevoluciones | DevolucionID, DetalleOrdenID, Cantidad, Motivo opcional | Devolución solicitada de orden entregada. Valida la cantidad considerando otras devoluciones y recalcula el reembolso. |

Una línea existente conserva su documento y referencia; permite modificar sus restantes campos de entrada. Los documentos deben conservar al menos una línea y admiten hasta 100. Los importes calculados no se aceptan como entradas. Los bloqueos se adquieren primero sobre la orden para coordinarse con las operaciones de documentos existentes.

Las demás tablas conservan las reglas de sus API, incluyendo transiciones de estado y restricciones de eliminación. La edición administrativa de reseñas modera su estado; para crear una reseña, el usuario conectado debe tener una compra entregada.

También se corrigieron dos llamadas preexistentes a `prepare()` sin consulta en los modelos de Orden y Factura, necesarias para cancelar órdenes y crear detalles de factura.

## Verificación

- `npm --prefix frontend run lint`
- `npm --prefix frontend run build`
- `python tests/test_api.py --admin-only`: 80 respuestas HTTP, permisos y comprobaciones SQL de inventario/totales, en una base temporal que se elimina al terminar.
- `node tests/admin_ui.cjs <ruta-al-modulo-playwright>`: Edge sin ventana, build local y API simulada. Recorre las 17 tablas, edición directa y por búsqueda, altas, confirmaciones, contraseña opcional, recuperación de errores, acceso restringido y ancho móvil.

La suite general existente se detiene antes de estos casos por una cabecera `Cache-Control: no-store` ausente en `api/auth/logout.php`. Las pruebas nuevas se ejecutaron independientemente. La carpeta `tests/` continúa excluida por la configuración existente de `.gitignore`.
