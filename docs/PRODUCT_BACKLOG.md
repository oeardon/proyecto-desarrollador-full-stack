# Product Backlog

## Requerimientos funcionales

| ID | Historia de usuario | Criterio de aceptación | Prioridad |
| --- | --- | --- | --- |
| RF01 | Como visitante quiero consultar productos para conocer el catálogo | El sistema muestra productos con nombre, categoría, precio e imagen | Alta |
| RF02 | Como visitante quiero buscar y filtrar productos para encontrar opciones rápidamente | La búsqueda y categorías actualizan el catálogo visible | Alta |
| RF03 | Como cliente quiero crear una cuenta para utilizar funciones de compra | El registro valida datos y almacena la contraseña con hash | Alta |
| RF04 | Como cliente quiero iniciar y cerrar sesión para proteger mi cuenta | La sesión se valida en el servidor y utiliza cookie de sesión | Alta |
| RF05 | Como cliente quiero agregar productos al carrito para preparar una compra | El carrito permite agregar, aumentar, reducir y eliminar productos | Alta |
| RF06 | Como cliente quiero conservar temporalmente mi carrito | El carrito se conserva en localStorage durante la navegación | Media |
| RF07 | Como cliente autenticado quiero finalizar mi compra para registrar una orden | Se solicita dirección, se crea la orden mediante API y se descuenta inventario | Alta |
| RF08 | Como cliente quiero recibir una confirmación clara | Al completar la orden se muestra `Nombre ¡Gracias! por tu compra` | Alta |
| RF09 | Como administrador quiero gestionar recursos del negocio | La API dispone de operaciones CRUD con permisos por rol | Alta |
| RF10 | Como usuario quiero utilizar el sitio desde móvil | La interfaz adapta menú, tarjetas, carrito y formularios a pantallas pequeñas | Alta |

## Requerimientos no funcionales

| ID | Requerimiento | Implementación |
| --- | --- | --- |
| RNF01 | Seguridad | PDO preparado, password_hash, password_verify, sesiones y control por rol |
| RNF02 | Facilidad de uso | Navegación en español, controles claros, mensajes de estado y diseño responsivo |
| RNF03 | Rendimiento | Vite, recursos modulares, peticiones JSON y renderizado React |
| RNF04 | Diseño | Bootstrap 5, SCSS propio, jerarquía visual y menú hamburguesa |
| RNF05 | Integridad | Claves foráneas, restricciones UNIQUE, transacciones y validaciones de negocio |
| RNF06 | Mantenibilidad | Separación entre frontend, API, controladores, modelos, configuración y documentación |

## Validación de requerimientos

Para cumplir el lineamiento académico debe adjuntarse evidencia real de la revisión de requerimientos con el cliente o usuario objetivo

Completar antes de la presentación

- Nombre o rol de la persona que validó
- Fecha de validación
- Requerimientos aceptados
- Cambios solicitados
- Evidencia disponible como captura, correo, minuta o formulario

No se incluye información ficticia en esta sección para evitar presentar una validación que no haya ocurrido
