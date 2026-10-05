# Utilidades y mantenimiento

Estos archivos no son todos pruebas automáticas ni forman parte del recorrido normal del usuario.

| Archivo | Finalidad y efectos |
| --- | --- |
| `public/generador_hash.php` | Formulario local con `password_hash` y copia del resultado. No registra usuarios ni modifica la base. |
| `public/prueba_conexion.php` | Diagnóstico heredado: intenta instanciar `Database` y llamar `conectar()`, mientras los endpoints consumen `$conexion`. La configuración actual no declara esa clase; la utilidad requiere corrección y no se recomienda como prueba de conexión del entregable. |
| `api/paises/restcountries.php` | Muestra auxiliar con JavaScript; el selector utiliza `api/paises/index.php`. No trasladar la clave privada del backend a una muestra ejecutada en navegador. |
| `database/preparar_resenas_mongo.php --aplicar` | Escribe índices/contador en MongoDB; véase [reseñas](RESENAS_MONGODB.md). |
| `database/actualizar_imagenes_productos.php` | `--verificar` consulta; `--aplicar` y `--revertir` escriben rutas en MariaDB; véase [imágenes](IMAGENES_PRODUCTOS.md). |
| `tests/check_import.py` | Ensaya esquema/CSV en una base temporal; depende de las rutas del script de carga. |
| `tests/compare_import_categories.py` | Lee categorías reales de `todoaqui_db` y compara con CSV; rutas/conexión fijas. |
| `tests/check_related_names.php` | Consulta categorías/direcciones reales para comprobar campos descriptivos. |
| `tests/update_table_presentation.py` | Script histórico que reescribe código. No es una prueba y no debe ejecutarse para validar la entrega. |
| `tests/*_cases.py` | Módulos invocados por `test_api.py`; no entradas autónomas. |
| `tests/countries.fixture.json` | Países simulados para pruebas. |
| `tests/*.png` | Capturas históricas, no garantía del estado actual. |

Los modos `--aplicar` no son verificaciones de lectura. Revisar el destino y preparar respaldo antes de operaciones de mantenimiento; no hace falta ejecutar todas las utilidades para iniciar la tienda.

Conservar fotografías junto con los datos que las referencian. Recuperar dependencias mediante lockfiles, sin editar `vendor`/`node_modules`. `frontend/dist` es regenerable; no confundirlo con el `build` raíz excluido. No eliminar scripts o evidencias por suponer que dejaron de utilizarse.

[Volver al índice documental](README.md).
