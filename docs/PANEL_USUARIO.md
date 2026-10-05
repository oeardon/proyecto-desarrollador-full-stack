# Panel de usuario

Revisión documental: 26/09/2026, sobre la copia local. Las validaciones anteriores se conservan como antecedentes; no se repitieron durante esta actualización.

El panel aparece en `/cuenta` al iniciar sesión. Los administradores también pueden consultar su información personal y conservan su panel administrativo.

## Secciones

- `/cuenta/usuario/perfil`: muestra nombres, apellidos, correo, teléfono y nombre de usuario. Permite editarlos y cambiar la contraseña, con confirmación en el formulario. Una contraseña vacía conserva la actual. No muestra contraseña, rol, estado ni campos internos editables.
- `/cuenta/usuario/direcciones`: lista las direcciones propias. `agregar` abre el alta y `/:id` la edición. Eliminar requiere confirmación. Se conserva la regla de una dirección principal.
- `/cuenta/usuario/ordenes`: lista las órdenes propias. `/:id` incluye productos, cantidades, importes, direcciones, facturas con sus líneas y pagos con método, estado y referencia. Se muestran mensajes cuando todavía no existen facturas o pagos.
- `/cuenta/usuario/lista-deseos`: muestra nombre, imagen, precio y estado de los productos guardados. Permite quitar productos con confirmación. Utiliza la lista persistida en MariaDB; los favoritos del catálogo se sincronizan con esta lista mediante la integración documentada en CATALOGO_CHECKOUT.md.
- `/cuenta/usuario/resenas`: muestra reseñas propias, incluidas las ocultas. Permite crear sobre productos comprados y entregados, editar y eliminar mediante api/resenas, con calificación, comentario y hasta tres fotografías; véase [Reseñas](RESENAS_MONGODB.md).
- `/cuenta/usuario/devoluciones`: lista solicitudes y enlaza a su detalle y orden. `nueva` permite elegir una orden entregada; `nueva?orden=:id` abre directamente el formulario. El usuario indica motivo y cantidades disponibles por producto.

La devolución comienza en Solicitada. El servidor calcula el importe y valida cantidades contra devoluciones no rechazadas. La aprobación, rechazo y procesamiento siguen siendo operaciones administrativas. No se realizan reembolsos bancarios.

## API personal

`api/cuenta/index.php?recurso=...` requiere sesión activa y devuelve `Cache-Control: no-store`. La propiedad procede exclusivamente de la sesión, también cuando la cuenta es administradora. Los identificadores ajenos devuelven 404.

| Recurso | Métodos |
| --- | --- |
| perfil | GET, PUT |
| direcciones | GET, POST, PUT, DELETE |
| ordenes | GET |
| lista-deseos | GET, DELETE |
| resenas | GET |
| devoluciones | GET, POST |

`id` identifica la dirección, orden o devolución; para eliminar un deseo identifica el producto. El perfil siempre corresponde al usuario conectado. PUT de perfil acepta únicamente los cinco datos personales y Contrasena; rechaza cambios de UsuarioID, TipoUsuario y Estado. Las actualizaciones SQL de perfil nunca escriben el rol ni el estado.

Las consultas personales están en `app/models/Cuenta.php`. Direcciones y devoluciones reutilizan los controladores actuales y sus transacciones. No requiere migraciones ni carga de datos.

## Validación histórica

- PHP: comprobación de sintaxis de los dos archivos nuevos.
- `npm.cmd --prefix frontend run lint` y `npm.cmd --prefix frontend run build`: correctos.
- `python tests/test_api.py --user-only`: 84 respuestas HTTP y comprobaciones SQL en base temporal, con dos clientes y un administrador. Incluye acceso ajeno, edición del perfil, contraseña opcional, duplicados, direcciones, órdenes, facturas, pagos, deseos, reseñas ocultas y devoluciones.
- `node tests/user_ui.cjs <ruta-al-modulo-playwright>`: Edge sin ventana con API simulada. Comprueba navegación, formularios, confirmaciones, solicitud de devolución, estados vacío/error, reintento, sesión y siete vistas móviles. Capturas locales revisadas de escritorio y móvil.

Estos resultados no se repitieron durante la revisión. La copia no tiene Git activo; las reglas heredadas excluyen gran parte de tests/, con excepciones. Revisar [Pruebas](CASOS_PRUEBA.md) antes de ejecutar suites antiguas con el motor de reseñas actual.

[Volver al índice documental](README.md).
