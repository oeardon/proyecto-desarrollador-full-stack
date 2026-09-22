# TodoAquí — ejecución del proyecto

## 1. Ubicación recomendada
Coloca el proyecto en:

`C:\xampp\htdocs\proyecto-desarrollador-full-stack`

## 2. Backend
En XAMPP inicia Apache y MySQL.

Importa `database/crear_bd_tablas.sql` desde phpMyAdmin.

Prueba la conexión en:

`http://localhost/proyecto-desarrollador-full-stack/public/prueba_conexion.php`

## 3. Frontend React + Vite
Abre PowerShell y ejecuta:

```powershell
cd C:\xampp\htdocs\proyecto-desarrollador-full-stack\frontend
npm install
npm run dev
```

Abre la URL que muestra Vite, normalmente:

`http://localhost:5173/`

## 4. Desarrollo en tiempo real
Edita los archivos dentro de `frontend/src/` y guarda con Ctrl + S. Vite actualiza la vista automáticamente.

Archivos principales:
- `src/App.jsx`
- `src/components/`
- `src/styles/main.scss`
- `src/js/interacciones.js`

## 5. Interactividad incluida
- Menú hamburguesa responsive.
- Menús desplegables y mega menú.
- Slider principal automático y manual.
- Filtros y búsqueda de productos.
- Favoritos.
- Carrito lateral con cantidades y eliminación.
- Vista rápida de producto.
- Animaciones de entrada al hacer scroll.
- Header sticky con sombra dinámica.
- Botón volver arriba.
- Newsletter con confirmación visual.

## 6. Bootstrap
Bootstrap se carga desde `main.jsx` usando los archivos compilados de `node_modules`, evitando los avisos deprecados de Sass del código fuente de Bootstrap.

```jsx
import 'bootstrap/dist/css/bootstrap.min.css'
import 'bootstrap/dist/js/bootstrap.bundle.min.js'
```

## 7. Validación antes de entregar
```powershell
npm run lint
npm run build
```
