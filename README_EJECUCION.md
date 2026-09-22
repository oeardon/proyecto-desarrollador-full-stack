# Proyecto desarrollador full stack - estructura corregida

## Ubicación recomendada en XAMPP

Copiar la carpeta completa en:

`C:\xampp\htdocs\proyecto-desarrollador-full-stack\`

## Estructura

- `api/`: endpoints PHP de la API.
- `app/`: controladores, modelos, helpers y servicios PHP.
- `config/database.php`: conexión PDO a MySQL/MariaDB.
- `database/crear_bd_tablas.sql`: creación de la base de datos y tablas.
- `docs/`: documentación y modelo de base de datos.
- `frontend/`: aplicación React + Vite + Bootstrap/Sass.
- `public/`: archivos PHP públicos, prueba de conexión y assets del backend.

## 1. Backend PHP / MySQL

1. Abrir XAMPP.
2. Iniciar Apache y MySQL.
3. Importar `database/crear_bd_tablas.sql` desde phpMyAdmin.
4. Probar:
   `http://localhost/proyecto-desarrollador-full-stack/public/prueba_conexion.php`

## 2. Frontend React en tiempo real

Abrir PowerShell y ejecutar:

```powershell
cd C:\xampp\htdocs\proyecto-desarrollador-full-stack\frontend
npm install
npm run dev
```

Abrir la URL que muestre Vite, normalmente:

`http://localhost:5173/`

Los cambios guardados en `frontend/src/` se actualizan automáticamente en el navegador.

## Importante

- `package.json` está dentro de `frontend/`.
- No ejecutar `npm install` desde la raíz del proyecto.
- `node_modules/` no se incluye en este paquete; se genera con `npm install`.
- El `package-lock.json` válido está en `frontend/`.
- Se eliminó el `package-lock.json` vacío de la raíz porque causaba confusión.
- Se eliminó el segundo import duplicado de Bootstrap en `frontend/src/styles/main.scss`.
