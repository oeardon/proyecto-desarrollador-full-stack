# Product Backlog

Inventario funcional de la copia local. Los criterios sirven para validación; no equivalen a que todas las pruebas hayan sido ejecutadas. La evidencia real se registra según [Casos de prueba](CASOS_PRUEBA.md).

## Requerimientos funcionales

| ID | Historia de usuario | Criterio de aceptación | Prioridad |
| --- | --- | --- | --- |
| RF01 | Como visitante quiero consultar productos | Catálogo con categoría, precio, imagen, descripción y existencias. | Alta |
| RF02 | Quiero buscar y filtrar | Búsqueda, categorías/descendientes y vistas de novedades, vendidos y ofertas. | Alta |
| RF03 | Quiero revisar un producto antes de agregarlo | Vista rápida con datos y reseñas disponibles. | Media |
| RF04 | Como cliente quiero registrarme e iniciar/cerrar sesión | Validación, hash, cookie de sesión y permisos en PHP. | Alta |
| RF05 | Quiero gestionar mi carrito | Agregar, ajustar, retirar y conservar cantidades en localStorage. | Alta |
| RF06 | Quiero guardar favoritos | Lista personal persistida y sincronizada con el catálogo. | Media |
| RF07 | Quiero registrar una compra simulada | Direcciones, nombre/NIT y método; importes del servidor, documentos y stock transaccionales. | Alta |
| RF08 | Quiero recuperar una confirmación | Consulta propia y reintento con mismo identificador sin duplicar la compra. | Alta |
| RF09 | Quiero recibir confirmación de prueba | PHPMailer/Ethereal después del commit; fallo SMTP no cancela el pedido. | Alta |
| RF10 | Quiero administrar mis datos | Editar perfil/contraseña y gestionar direcciones propias. | Alta |
| RF11 | Quiero consultar mis compras | Órdenes, detalles, facturas y pagos propios. | Alta |
| RF12 | Quiero reseñar productos comprados | Compra entregada, calificación 1–5, unicidad, comentario y hasta tres imágenes. | Media |
| RF13 | Quiero solicitar una devolución | Orden entregada, cantidades disponibles y seguimiento de estado. | Media |
| RF14 | Como administrador quiero gestionar el catálogo | Productos, categorías, proveedores, promociones y relaciones. | Alta |
| RF15 | Quiero gestionar documentos y usuarios | Recursos administrativos con permisos, transiciones y restricciones. | Alta |
| RF16 | Quiero moderar reseñas | Ocultar/publicar sin reescribir contenido ajeno. | Media |
| RF17 | Quiero cargar fotografías de productos | Validación real de imagen, tamaño y vista previa. | Media |
| RF18 | Quiero seleccionar país y dirección | Países desde API, Guatemala inicial, valor conservado y reintento. | Media |
| RF19 | Quiero usar la tienda en móvil | Navegación y formularios adaptados. | Alta |

## Requerimientos no funcionales

| ID | Requerimiento | Mecanismo verificable |
| --- | --- | --- |
| RNF01 | Acceso controlado | Sesiones, roles, propiedad y consultas preparadas. |
| RNF02 | Integridad | FK/UNIQUE, transacciones y bloqueos SQL; índices MongoDB y control de versiones de reseñas. |
| RNF03 | Consistencia monetaria | Cálculo backend con BCMath; importes del navegador no son autoridad. |
| RNF04 | Recuperación | Idempotencia de checkout y mensajes de fallos externos. |
| RNF05 | Usabilidad | Español, validación, estados vacío/error y diseño responsivo. |
| RNF06 | Rendimiento | Compilación Vite, caché de países y peticiones compartidas. |
| RNF07 | Mantenibilidad | Separación de capas, manifiestos/lockfiles y documentación. |
| RNF08 | Privacidad | Configuración privada y respuestas que omiten contraseñas/credenciales. |

## Fuera del alcance implementado

Pagos bancarios reales, emisión fiscal, recuperación de contraseña por correo, analítica de navegación y sincronización automática de exportaciones JSON. No declarar estas funciones terminadas por aparecer como propuestas.

## Validación con usuario o cliente

Completar con evidencia real: nombre/rol, fecha, requisitos revisados, aceptados, cambios solicitados y enlace/archivo de evidencia. La confirmación del propietario de Atlas y correo local se registra en [Estado](TRANSFERENCIA_ESTADO.md), pero no sustituye una validación formal de todos los requisitos.

[Volver al índice documental](README.md).
