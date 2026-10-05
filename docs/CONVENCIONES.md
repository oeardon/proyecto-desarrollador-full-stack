# Convenciones de nombres y estructura

## PHP y API

Controladores/modelos usan PascalCase, por ejemplo `OrdenController.php` y `Producto.php`. Las funciones usan camelCase. Los endpoints se agrupan en `api/<recurso>/index.php`; autenticación usa archivos independientes. El código es procedural, con PDO y servicios específicos, sin clases propias de dominio ni framework PHP.

Las respuestas JSON incluyen success y datos/mensaje según el contrato. Las validaciones/permisos se aplican en backend. No confundir ocultar un botón con autorizar la operación. Véase [API](API_RECURSOS.md).

## React

Componentes/páginas en PascalCase; hooks y servicios con nombres descriptivos. Peticiones en `src/services`, estado compartido/hooks en `src/context`, esquemas en `src/data` y estilos en SCSS/CSS. Los nombres de campos JSON conservan el contrato PHP; no renombrarlos solo por estilo JavaScript.

## Datos y rutas

Tablas y columnas locales mantienen PascalCase, como Usuarios y UsuarioID. No aplicar conversiones de hosting/Linux por inferencia. MongoDB conserva las colecciones Resenas/Contadores y IDs numéricos; imágenes guardan rutas, no binarios JSON.

Las rutas `/tienda_online/api` y `/productos` tienen significado en la configuración local. Los importes se calculan en servidor; las operaciones bancarias no están integradas.

## Documentación y mantenimiento

Usar UTF-8, español y enlaces relativos entre documentos. Distinguir implementación, propuesta, resultado histórico y verificación actual. No incluir secretos ni afirmar pruebas no ejecutadas. Conservar lockfiles; no editar dependencias generadas. Las reglas `.gitignore` son heredadas y no implican repositorio activo.

El mapa completo está en [Arquitectura](ARQUITECTURA.md). `INFORME` y `build` no forman parte de esta revisión documental.

[Volver al índice documental](README.md).
