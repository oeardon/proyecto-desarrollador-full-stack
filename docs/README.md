# Documentación de TodoAquí

Revisión: 26/09/2026. Alcance: aplicación local, excepto `INFORME` y `build`. Los comandos son instrucciones; no significan que se hayan ejecutado durante esta revisión.

## Comenzar

1. [Estado vigente](TRANSFERENCIA_ESTADO.md).
2. [Instalación y configuración](INSTALACION_LOCAL.md).
3. [Arquitectura y directorios](ARQUITECTURA.md).
4. [Bases de datos](BASE_DATOS.md).

## Cobertura funcional

| Área | Guía |
| --- | --- |
| Registro, login, logout, sesión, roles y recursos HTTP | [API](API_RECURSOS.md) |
| Catálogo, filtros, promociones, carrito, compra, recuperación y Ethereal | [Checkout](CATALOGO_CHECKOUT.md) |
| Perfil, direcciones, órdenes, favoritos, reseñas y devoluciones | [Panel personal](PANEL_USUARIO.md) |
| Los 17 recursos administrativos, relaciones y detalles | [Administración](CRUD_ADMINISTRACION.md) |
| MongoDB, permisos, moderación y fotos de reseñas | [Reseñas](RESENAS_MONGODB.md) |
| Fotografías de productos, cargas y actualización de rutas | [Imágenes](IMAGENES_PRODUCTOS.md) |
| Países, caché y direcciones | [Países](PAISES.md) |
| Servicios externos, dependencias, secretos y arranque | [Instalación](INSTALACION_LOCAL.md) |
| Scripts auxiliares y mantenimiento | [Utilidades](UTILIDADES.md) |
| Suites, casos manuales y limitaciones | [Pruebas](CASOS_PRUEBA.md) |

## Diseño y entrega

- [Problema](DESCRIPCION_PROBLEMA.md).
- [Backlog](PRODUCT_BACKLOG.md).
- [Tecnologías](TECNOLOGIAS.md).
- [Convenciones](CONVENCIONES.md).
- [Modelo NoSQL](MODELO_NOSQL.md).
- [Mockups y evidencias](MOCKUPS_Y_REFERENCIAS.md).
- [Lineamientos](LINEAMIENTOS_ENTREGA.md).
- [Presentación](GUIA_PRESENTACION.md).
- [URLs](URLS_ENTREGA.md).
- [Frontend](../frontend/README.md).
- [Formato JSON](../database/json/README.md).

## Evidencias

La revisión contrasta documentación con archivos, no certifica cada flujo. Las validaciones históricas se conservan identificadas y deben repetirse ante cambios. El usuario confirmó Atlas, compra local con correo Ethereal y SSL del hosting. No se inventan resultados, credenciales, repositorios o validaciones con clientes.
