# Convenciones de nombres y estructura

## PHP
- Archivos de controladores en PascalCase como `OrdenController.php`
- Modelos en PascalCase como `Producto.php`
- Funciones en camelCase como `obtenerUsuarioPorId`
- Variables descriptivas en camelCase

## React
- Componentes en PascalCase como `CartDrawer.jsx`
- Funciones y variables en camelCase
- Componentes pequeños y con responsabilidad específica
- Servicios HTTP dentro de `src/services`

## Base de datos
El modelo existente utiliza nombres en PascalCase para tablas y columnas como `Usuarios`, `UsuarioID` y `FechaRegistro`

La convención se mantiene de forma consistente para no romper consultas, relaciones ni la documentación del modelo
