# Tecnologías utilizadas

Esta descripción se basa en manifiestos y código de la copia local; los rangos declarados no son necesariamente la versión exacta instalada. Los lockfiles fijan las dependencias reproducibles.

| Capa | Tecnologías y responsabilidad |
| --- | --- |
| Interfaz | HTML/JSX, React `^19.2.8`, React Router `^7.18.4`, JavaScript y Fetch. |
| Presentación | Bootstrap `^5.3.8`, Popper, Sass `1.105.0`, SCSS/CSS y diseño responsivo. |
| Herramientas frontend | Vite `^8.3.0`, plugin React, ESLint y npm. |
| Backend | PHP procedural, endpoints independientes, controladores, modelos y servicios. |
| Relacional | MariaDB, PDO, consultas preparadas, transacciones, bloqueos, restricciones e índices. |
| NoSQL activo | MongoDB Atlas para reseñas/contador, extensión PHP mongodb y biblioteca Composer mongodb/mongodb `^2.4`. |
| Correo | PHPMailer `^7.1` mediante SMTP; Ethereal para capturar confirmaciones de prueba. |
| Países | Backend PHP/cURL que consulta REST Countries y guarda caché temporal. |
| Imágenes | Disco local, validación de MIME/tamaño/dimensiones y rutas guardadas en SQL/MongoDB. |
| Autenticación | Sesiones PHP, password_hash/password_verify y comprobación de estado/rol en servidor. |
| Importes | BCMath para cálculos decimales del backend. |
| Pruebas | Python para HTTP/SQL, Node y Playwright para interfaz simulada, mongod local para reseñas aisladas. |

MongoDB no es solo una propuesta: almacena las reseñas activas. Los eventos de navegación del [modelo NoSQL](MODELO_NOSQL.md) sí son una propuesta no implementada. No hay pasarela bancaria ni emisión fiscal integrada.

Ver [requisitos de instalación](INSTALACION_LOCAL.md), [arquitectura](ARQUITECTURA.md) y [pruebas](CASOS_PRUEBA.md). El certificado HTTPS del hosting fue confirmado por el usuario; no determina la configuración SMTP local.

[Volver al índice documental](README.md).
