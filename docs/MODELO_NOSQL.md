# Diseño NoSQL complementario

## Propósito
Los datos transaccionales como usuarios, productos, órdenes, pagos y facturas permanecen en MariaDB

MongoDB se propone para almacenar eventos de navegación y preferencias de presentación que pueden cambiar con frecuencia y no requieren relaciones transaccionales estrictas

## Colección `interacciones`

Campos propuestos

- `usuarioId` entero o nulo para visitantes
- `sesionId` cadena
- `tipo` búsqueda, vista_producto, favorito, categoria o carrito
- `productoId` entero opcional
- `categoria` cadena opcional
- `terminoBusqueda` cadena opcional
- `metadata` documento flexible
- `fecha` fecha y hora

## Ejemplo
Consulta `database/modelo_nosql.json`

## Relación con el modelo SQL
El identificador `usuarioId` y `productoId` se utilizan como referencias lógicas hacia MariaDB, pero no como claves foráneas dentro de MongoDB

Este diseño evita mover la información crítica de compras fuera de la base relacional
