# Transferencia de estado — TodoAquí

Fecha de preparación: 24 de septiembre de 2026.
Repositorio local: `C:\xampp\htdocs\tienda_online`.

## Cómo retomar

1. Leer este documento y verificar los archivos actuales y `git status` antes de editar: el usuario también modifica y actualiza el repositorio entre turnos.
2. Continuar en español con cambios concretos y respetar los cambios ajenos.
3. La última solicitud funcional ya está completada: en Ventas y posventa únicamente la llave primaria se titula «ID»; las otras referencias recuperaron sus encabezados originales.
4. No hay una siguiente funcionalidad solicitada. Esperar las instrucciones del usuario después de revisar el estado.
5. No ejecutar cargas, restauraciones, borrados o cambios de credenciales sobre la base principal por inferencia. El usuario ha ejecutado personalmente las importaciones; las comprobaciones de escritura se hicieron en bases temporales.

## Estado de Git al preparar este documento

Rama: `main`.
Último commit observado: `b0648bb Corrección de vite.config.js`.
Cambios presentes antes de crear esta transferencia:

```text
 M api/admin/index.php
 M app/models/Categoria.php
 M app/models/Direccion.php
 M frontend/.gitignore
 M frontend/index.html
 M frontend/src/components/AdminCrud.jsx
 M frontend/src/data/adminSchemas.js
 M frontend/src/styles/main.scss
?? frontend/public/favicon.png
```

Los cambios de presentación de las tablas y sus consultas fueron realizados en esta conversación. Los cambios de `frontend/.gitignore`, `frontend/index.html` y el favicon también estaban presentes: conservarlos. No se creó un commit ni se hizo push al generar esta transferencia.

El usuario realizó commits y restauraciones durante la conversación; no asumir que todo lo descrito aquí está pendiente de commit. Consultar el estado actual.

## Entorno y arquitectura

- Tienda en React 19, React Router 7, Vite 8, Bootstrap 5 y Sass.
- Backend PHP procedural: modelos en `app/models`, validaciones/controladores en `app/controllers`, servicios HTTP en `api`.
- MariaDB local de XAMPP, base `todoaqui_db`; PDO mediante `config/database.php`.
- PHP: `C:\xampp\php\php.exe`.
- Cliente MariaDB: `C:\xampp\mysql\bin\mysql.exe`.
- Shell utilizada: PowerShell. En Windows usar `npm.cmd` cuando sea necesario.
- Puerto configurado de Apache confirmado al escribir esta transferencia: **8080** (`C:\xampp\apache\conf\httpd.conf`).
- Vite declara `localhost:5173`.
- Las peticiones del frontend usan `/tienda_online/api/...` y cookies con `credentials: 'include'`.
- Documentos útiles: `docs/API_RECURSOS.md`, `docs/CRUD_ADMINISTRACION.md`, `docs/CONVENCIONES.md`, `database/crear_bd_tablas.sql`.

### Desajuste pendiente del proxy

El archivo actual `frontend/vite.config.js` contiene:

```js
target: 'http://localhost',
```

Sin embargo, Apache está configurado en 8080. En el diagnóstico anterior el puerto 80 respondió 404 y la API de 8080 permitió iniciar y conservar sesión correctamente. Se propuso cambiar el destino a `http://localhost:8080`, pero el usuario rechazó la autorización de la herramienta que incluía esa edición y el arranque temporal de Vite. **La corrección no fue aplicada por el asistente.** No presentarla como resuelta ni volver a ejecutar aquella acción automáticamente; si el usuario retoma el problema, verificar su configuración y autorización actuales.

El usuario administrador comprobado fue UsuarioID 1, usuario `adminoa`, rol Administrador, estado Activo. La contraseña indicada anteriormente por el usuario funcionó contra la API después de restaurar la base. No se reproduce ninguna contraseña ni hash en este archivo.

## Portal de Cuenta y administración

Rutas en `frontend/src/App.jsx`:

- `/`: `Inicio.jsx`.
- `/cuenta`: `Cuenta.jsx` con login, registro, información de sesión y panel de administrador.
- `/cuenta/admin/:recurso`: panel con cinco operaciones.
- `/cuenta/admin/:recurso/:operacion`: listado, búsqueda o formulario.

Operaciones: `mostrar`, `buscar`, `agregar`, `editar`, `eliminar`.

Archivos principales:

- `frontend/src/components/AdminPanel.jsx`: grupos y enlaces a las tablas.
- `frontend/src/data/adminResources.js`: catálogo de las 17 tablas y sus grupos.
- `frontend/src/pages/AdminPage.jsx`: validación de sesión/rol, panel de operaciones y acceso al CRUD.
- `frontend/src/components/AdminCrud.jsx`: componente compartido de las 17 tablas. No existe una tabla React independiente por entidad.
- `frontend/src/data/adminSchemas.js`: campos, tipos, restricciones, transiciones y opciones de presentación.
- `frontend/src/services/adminService.js`: solicitudes HTTP y parámetros de identificadores.
- `frontend/src/context/AuthContext.jsx` y `useAuth.js`: sesión y operaciones de autenticación.

Funciones de `AdminCrud.jsx`:

- `RecordsTable`: encabezados, columnas, valores, miniaturas y acciones.
- `SearchRecord`: búsqueda por ID; dos campos para claves compuestas.
- `RecordForm`: alta, edición y eliminación; también líneas de pedidos/devoluciones.
- `RecordDetails`: datos de consulta de solo lectura.
- `LoadRecords`: carga, errores, reintento y cancelación de solicitudes obsoletas.
- `TableImage`: miniatura con alternativa si falta o falla la imagen.

Comportamiento solicitado e implementado:

- Mostrar y buscar presentan una tabla con Editar/Eliminar y botón Agregar arriba.
- Editar desde una fila pasa los IDs por query string y omite el formulario de búsqueda.
- Editar y Eliminar desde el panel primero buscan el registro y luego muestran sus datos.
- Eliminar desde una fila usa confirmación y permanece en la tabla.
- Eliminar desde el panel muestra datos no editables y solicita confirmación antes de enviar DELETE.
- Las confirmaciones utilizan `window.confirm`.
- Los formularios y acciones siguen usando los IDs originales aunque las celdas muestren nombres.
- La contraseña nunca se presenta en la tabla; vacía al editar conserva la existente.

## Últimos cambios de legibilidad

Configuración en `adminTableOptions` de `adminSchemas.js`, aplicada exclusivamente por `RecordsTable`; `fieldLabel` continúa sirviendo a los formularios.

- Encabezados de identificadores: regla general «ID», con excepciones explícitas para relaciones mostradas mediante nombres.
- **Ventas y posventa:** `primaryIdOnly: true` en `ordenes`, `detalle-ordenes`, `pagos`, `facturas`, `detalle-facturas`, `devoluciones` y `detalle-devoluciones`. Solo `adminSchemas[resource].keys[0]` se titula «ID». Referencias conservan «Usuario ID», «Orden ID», «Producto ID», etc. Esta fue la última corrección solicitada; no volver a convertir todas esas referencias a «ID».
- Categorías: `CategoriaPadreID` se presenta como «Categoría principal» usando `CategoriaPrincipal`; categorías sin padre muestran «—».
- Productos: `CategoriaID` permanece en la consulta pero se oculta de la tabla. `Precio` usa prefijo `Q.`, separadores y dos decimales.
- Productos: `imageFields: ['Imagen']`; miniatura de 80 × 80 con `object-fit: contain`, carga diferida y textos «Sin imagen» / «Imagen no disponible». El formulario conserva la ruta como texto.
- Productos y proveedores: IDs se muestran como nombres bajo «Producto» y «Proveedor».
- Productos y promociones: nombres bajo «Producto» y «Promoción».
- Direcciones: `UsuarioID` se presenta bajo «Usuario» usando Nombres + Apellidos; `EsPrincipal` muestra «Sí» o «No».
- Lista de deseos: nombres completos de usuarios y nombres de productos bajo «Usuario» y «Producto».
- Los campos auxiliares de nombres se ocultan como columnas independientes para evitar duplicaciones.

Consultas enriquecidas tanto para listado como para búsqueda:

- `app/models/Categoria.php`: LEFT JOIN consigo misma, alias `CategoriaPrincipal`. La consulta de bloqueo no se modificó.
- `app/models/Direccion.php`: LEFT JOIN Usuarios, `TRIM(CONCAT(Nombres, ' ', Apellidos)) AS UsuarioNombre`; conserva filtro de propietario.
- `api/admin/index.php`: lecturas con alias `ProductoNombre`, `ProveedorNombre`, `PromocionNombre`, `UsuarioNombre` según recurso. Conserva las claves originales; las mutaciones no reciben estos campos adicionales.

## API administrativa y reglas de documentos

Las API habituales cubren usuarios, direcciones, categorías, productos, proveedores, promociones, órdenes, pagos, facturas, devoluciones y reseñas. `wishlist` es el recurso original de favoritos del usuario conectado.

El nuevo `api/admin/index.php?recurso=...` exige sesión y rol de administrador para todas sus operaciones. Admite:

- `productos-proveedores`, clave ProductoID + ProveedorID.
- `productos-promociones`, clave ProductoID + PromocionID.
- `lista-deseos`, clave UsuarioID + ProductoID; administración de todos los usuarios.
- `detalle-ordenes`, `detalle-facturas`, `detalle-devoluciones`.

GET sin IDs lista; GET/PUT/DELETE individuales usan nombres de claves en parámetros. POST/PUT reciben JSON. Tablas y campos están limitados por listas fijas, con consultas preparadas.

El usuario pidió explícitamente operaciones independientes para las líneas. Están en `app/controllers/DetalleAdminController.php`:

- Detalles de órdenes: orden Pendiente sin pagos, facturas ni devoluciones, ni cargos/descuentos adicionales. Ajusta stock y totales.
- Detalles de facturas: factura Emitida de orden Pendiente sin pagos; referencia perteneciente a esa orden y cantidad no superior a la original. Recalcula importes.
- Detalles de devoluciones: devolución Solicitada de orden Entregada. Respeta cantidades ya devueltas/reservadas y recalcula reembolso.
- Documento y referencia de una línea existente no se pueden trasladar; se editan los otros campos permitidos.
- Se conserva al menos una línea, máximo 100.
- Transacciones con bloqueo de la orden primero y aislamiento READ COMMITTED para leer el estado reciente después de esperar el bloqueo.
- Los importes calculados no son editables desde el formulario.

Órdenes, pagos, facturas y devoluciones mantienen transiciones de estado y restricciones de eliminación de sus API. La administración de reseñas permite moderar Estado; crear reseñas requiere compra entregada del usuario conectado. Consultar `docs/CRUD_ADMINISTRACION.md` para más detalles.

Se corrigieron llamadas anteriores a `$conexion->prepare()` sin `$sql` en modelos de Orden y Factura, necesarias para cancelar pedidos y generar detalles de factura.

## Estilos

- `frontend/src/styles/_variables.scss` contiene los valores CSS `:root`, fuente Manrope e importación de Google Fonts, colores compartidos, sombras, radios y ancho de contenedor.
- Contiene variables Sass `$breakpoint-wide:1100px`, `$breakpoint-tablet:900px`, `$breakpoint-mobile:640px`.
- `main.scss` usa `@use './variables';` y las variables Sass en sus media queries.
- Se reemplazaron colores repetidos por sus variables conservando los valores visuales.
- `.admin-table` controla desplazamiento y encabezado fijo; `.admin-table__image` la miniatura.

## Datos e importador

Tablas: Usuarios, Direcciones, Categorias, Proveedores, Productos, Promociones, ProductosProveedores, ProductosPromociones, Ordenes, DetalleOrdenes, Pagos, Facturas, DetalleFacturas, Devoluciones, DetalleDevoluciones, ListaDeseos, Resenas.

`database/csv` contiene archivos UTF-8. `database/json` contiene sus versiones para MongoDB (generadas anteriormente; no asumir sincronización automática con cambios posteriores de CSV o SQL).

Problema del importador ya diagnosticado y corregido:

- `ESCAPED BY '"'` hacía que MariaDB leyera incorrectamente los CSV: Categorías cargaba 44/48 y desde Proveedores resultaban cero filas.
- Se sustituyó por `ESCAPED BY ''` desde Categorías en adelante, manteniendo `OPTIONALLY ENCLOSED BY '"'` y finales `\r\n`.
- Usuarios usa delimitador de comillas simples en su LOAD DATA por el formato de su archivo; no uniformarlo sin inspección.
- El archivo actual conserva la corrección de escape, aunque ya no contiene los comentarios que se añadieron al diagnosticarla.
- Validación completa en base temporal: 17 tablas, cantidades iguales a los CSV y cero advertencias.
- En el primer diagnóstico faltaban categorías 1, 13, 14 y 15; el usuario posteriormente restauró y cargó la base. Una lectura posterior comprobó 48 categorías y 150 direcciones. No asumir que sigue faltando aquel conjunto.

Conteos de los CSV al validarlos: Usuarios 152, Direcciones 150, Categorías 48, Proveedores 12, Productos 108, Promociones 12, ProductosProveedores 108, ProductosPromociones 108, Órdenes 36, DetalleOrdenes 108, Pagos 34, Facturas 32, DetalleFacturas 96, Devoluciones 4, DetalleDevoluciones 4, ListaDeseos 72, Reseñas 36.

El usuario creó colecciones en MongoDB Atlas/Compass y cargó JSON. Su usuario de Atlas tiene lectura de Usuarios/Productos y lectura/escritura de Resenas. `config/mongodb.php` carga Composer y `api_keys.php`, crea el cliente, selecciona `todoaqui_db` y hace ping. Las API CRUD actuales siguen conectadas a MariaDB; no se realizó una migración de reseñas a MongoDB en esta conversación.

## Pruebas y pendientes conocidos

Desde la raíz:

```powershell
npm.cmd --prefix frontend run lint
npm.cmd --prefix frontend run build
C:\xampp\php\php.exe -l api/admin/index.php
python tests/test_api.py --admin-only
python tests/test_api.py --catalog-only
```

Resultados recientes:

- Último ajuste de encabezados: lint y build correctos.
- Cambios de nombres relacionados: 80 comprobaciones HTTP de administración y 114 de catálogo, más comprobaciones SQL, correctas en bases temporales.
- Consultas reales de solo lectura verificaron que listados y búsquedas de categorías/direcciones incluyen nombres y conservan IDs.
- En una fase anterior `tests/admin_ui.cjs` comprobó las 17 tablas, edición directa y por búsqueda, confirmaciones, altas, contraseña opcional, reintento, acceso y ancho móvil con API simulada. Esa prueba no se volvió a ejecutar para los últimos cambios de encabezados/nombres ni debe citarse como una comprobación visual de ellos.
- Suite general `tests/test_api.py`: durante la implementación se detenía por ausencia de `Cache-Control: no-store` en `api/auth/logout.php`. Se documentó y ejecutaron las suites específicas; no se corrigió aquel asunto en esta conversación. Volver a comprobar antes de declararlo vigente o resuelto.

Archivos de pruebas locales: `tests/test_api.py`, `admin_cases.py`, `admin_ui.cjs`, `check_import.py`, `check_related_names.php`, `compare_import_categories.py`. La carpeta `tests/` está ignorada por `.gitignore`: no estará disponible automáticamente en otro equipo tras clonar.

`tests/update_table_presentation.py` es un script de edición de un solo uso, no una prueba: **no volver a ejecutarlo**, pues puede duplicar cambios.

Las pruebas HTTP crean una base con nombre único y copia temporal del backend; eliminan la base al terminar. No ejecutar pruebas de escritura contra `todoaqui_db`.

Runtimes disponibles si Python/Node no están en PATH:

- `C:\Users\Estuardo\.cache\codex-runtimes\codex-primary-runtime\dependencies\python\python.exe`
- `C:\Users\Estuardo\.cache\codex-runtimes\codex-primary-runtime\dependencies\node\bin\node.exe`
- Módulo Playwright usado por el script UI: `C:\Users\Estuardo\.cache\codex-runtimes\codex-primary-runtime\dependencies\node\node_modules\playwright`.

El navegador integrado y comandos aislados fallaron anteriormente con `helper_unknown_error: setup refresh had errors`. Se siguió la habilidad de navegador y, tras fallar su inicio, se usó Edge sin ventana mediante Playwright para pruebas locales con API simulada. Leer la habilidad vigente antes de repetir pruebas de navegador; no asumir que la versión o disponibilidad siga igual.

## Seguridad y cuidado del repositorio

- No incluir secretos, hashes ni archivos de configuración sensible en el chat o en commits.
- `config/api_keys.php` está ignorado. No necesita leerse para cambios de interfaz.
- `.gitignore` también excluye `vendor/`, `tests/` y `api/paises/restcountries.php`.
- Un archivo previamente rastreado puede seguir en Git aunque se añada a `.gitignore`; verificar con `git ls-files` si el usuario retoma ese asunto.
- Hubo una exposición de clave en commits históricos `4c043bc` y `2f66a52`, y una reaparición tras actualizar el repositorio. No afirmar que esos secretos fueron eliminados del historial ni reescribirlo sin una nueva instrucción.
- La autorización de acciones concretas puede haber sido rechazada: respetar ese rechazo; no sortearlo con otra herramienta.
- No hacer commit, push, pull o restauraciones salvo que formen parte de la nueva solicitud del usuario.
