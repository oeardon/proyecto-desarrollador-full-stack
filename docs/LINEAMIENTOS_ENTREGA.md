# Lineamientos y evidencias de entrega

La documentación describe la copia local. `INFORME` y `build` están fuera de esta revisión; no se certifica su contenido.

| Lineamiento | Evidencia | Estado |
| --- | --- | --- |
| Problema y solución | [Descripción](DESCRIPCION_PROBLEMA.md) | Documentado. |
| Requerimientos e historias | [Backlog](PRODUCT_BACKLOG.md) | Documentado; falta evidencia formal de validación. |
| Mockups/interfaz | [Guía visual](MOCKUPS_Y_REFERENCIAS.md) y capturas históricas de tests | Actualizar evidencias finales según la ejecución real. |
| Modelo relacional | [SQL](../database/crear_bd_tablas.sql) y [modelo explicado](BASE_DATOS.md) | Incluido; el PDF EER antes citado está ausente. |
| Modelo NoSQL | [Diseño](MODELO_NOSQL.md) y [reseñas](RESENAS_MONGODB.md) | Modelo activo y propuesta diferenciados. |
| Datos SQL | [Dump](../database/todoaqui_db.sql), esquema y carga CSV | Incluidos; procedimientos en guía de datos. |
| Tecnologías | [Tecnologías](TECNOLOGIAS.md) | Actualizado. |
| Instalación y URL base | [Instalación](INSTALACION_LOCAL.md), [URLs](URLS_ENTREGA.md) | Documentado. |
| Arquitectura y directorios | [Arquitectura](ARQUITECTURA.md) | Cubierto, incluidas dependencias/generados. |
| API y operaciones | [API](API_RECURSOS.md), [administración](CRUD_ADMINISTRACION.md) | Documentado con restricciones. |
| Casos y rutinas | [Pruebas](CASOS_PRUEBA.md) | Scripts existentes y limitaciones distinguidos. |
| Convenciones | [Convenciones](CONVENCIONES.md) | Documentado. |
| Proyecto comprimido | Copia final preparada por el responsable | No se generó un ZIP durante esta tarea. |
| Repositorio | [Estado](TRANSFERENCIA_ESTADO.md) | Sin vínculo Git activo; no inventar URL. |
| Sitio publicado | [URLs](URLS_ENTREGA.md) | SSL validado según el propietario; no probado aquí. |

## Pendientes materiales

La galería `frontend/public/creditos-imagenes.html` falta aunque existe un enlace en el pie. El comando `test:structure` apunta a una prueba ausente. Estos son pendientes de recursos/código, no se solucionan declarando documentación completa. El diagrama relacional está explicado aquí sin afirmar que se recuperó el PDF.

Antes de entregar, registrar evidencias reales de requisitos/pruebas y verificar que el paquete conserva fotografías y configuración necesaria por el canal adecuado. No incluir contraseñas en documentos públicos. Las pruebas históricas no certifican automáticamente una copia posterior.

[Volver al índice documental](README.md).
