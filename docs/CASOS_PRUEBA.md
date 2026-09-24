# Casos y rutinas de prueba

## Pruebas de interfaz

| ID | Caso | Procedimiento | Resultado esperado |
| --- | --- | --- | --- |
| UI01 | Carga inicial | Ejecutar `npm run dev` y abrir Vite | La página carga sin pantalla en blanco |
| UI02 | Bootstrap | Revisar botones, formularios, grilla y alertas | Los componentes muestran estilos Bootstrap |
| UI03 | Responsive | Cambiar viewport a 375 px | Aparece menú hamburguesa y no existe desbordamiento horizontal |
| UI04 | Búsqueda | Escribir un nombre de producto y buscar | Se filtran los productos visibles |
| UI05 | Carrito | Agregar productos y cambiar cantidades | El contador y subtotal se actualizan |
| UI06 | Persistencia | Agregar producto y recargar | El carrito se conserva en localStorage |
| UI07 | Checkout sin sesión | Intentar finalizar compra sin autenticación | La interfaz lleva al bloque Mi cuenta |
| UI08 | Checkout con sesión | Iniciar sesión, agregar producto y finalizar | Se registra la orden y aparece `Nombre ¡Gracias! por tu compra` |

## Pruebas de backend

1 Probar conexión en `public/prueba_conexion.php`
2 Registrar un cliente por `api/auth/registro.php`
3 Iniciar sesión por `api/auth/login.php`
4 Consultar sesión por `api/auth/sesion.php`
5 Consultar productos por `api/productos/`
6 Crear una orden autenticada por `api/ordenes/`
7 Verificar en MariaDB las tablas `Ordenes` y `DetalleOrdenes`
8 Confirmar que la cantidad del producto disminuyó

## Rutinas automáticas

Frontend

```powershell
cd frontend
npm run lint
npm run build
node ..\tests\test_frontend_structure.mjs
```

PHP

```bat
for /R %f in (*.php) do @php -l "%f"
```
