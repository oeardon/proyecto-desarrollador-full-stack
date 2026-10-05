# Frontend de TodoAquí

React, Vite, React Router, Bootstrap y SCSS. Forma parte del entregable PHP/MariaDB/MongoDB y consume datos de su API.

## Uso

Preparar Apache, MariaDB y configuración siguiendo [Instalación](../docs/INSTALACION_LOCAL.md). Dentro de esta carpeta:

```powershell
npm.cmd run dev
npm.cmd run lint
npm.cmd run build
```

Si faltan dependencias, `npm.cmd ci` utiliza el lockfile. Los mismos scripts se delegan desde la raíz. Vite detecta Apache en localhost:80 o localhost:8080; iniciar puede fallar si categorías no responde correctamente. Preview no tiene proxy API declarado.

## Organización

- `src/main.jsx`: arranque y proveedores.
- `src/App.jsx`: rutas, navegación, catálogo, carrito y favoritos.
- `src/pages`: pantallas principales.
- `src/components`: formularios, controles, paneles y tablas.
- `src/context`: estado de sesión y hooks de catálogo/carrito/deseos.
- `src/services`: clientes PHP, formato y persistencia del intento de compra.
- `src/data`: navegación/esquemas y datos auxiliares; el catálogo principal viene de PHP.
- `src/styles`, `src/*.css`, `src/js`: estilos e interacciones.
- `public`: favicon y fotografías de productos.
- `dist`: compilación; distinta del `build` raíz.
- `node_modules`: dependencias instaladas.

Las [rutas y responsabilidades](../docs/ARQUITECTURA.md) y el [índice funcional](../docs/README.md) completan esta guía. El servidor recalcula importes y comprueba permisos, independientemente del estado del navegador.

El pie enlaza `/creditos-imagenes.html`, pero el archivo falta en esta copia; queda pendiente recuperar ese recurso. No se afirma que el enlace funcione.
