# Modelo NoSQL

## Implementado: reseñas

MongoDB almacena la colección `Resenas` y el contador de IDs en `Contadores`. Las reseñas conservan ResenaID, UsuarioID, ProductoID, Calificacion, Comentario, FechaResena, Estado y las rutas opcionales de Imagenes. Los documentos editados usan Version para control de concurrencia. FechaResena se almacena como BSON Date; los IDs numéricos mantienen compatibilidad con MariaDB y la API.

Usuarios y productos se consultan en MariaDB, no desde sus exportaciones JSON. Una compra entregada habilita la reseña; el índice único usuario/producto evita duplicados y las ocultas no participan en promedios públicos. No existen FK ni transacciones distribuidas entre motores.

La configuración, índices, imágenes y fallos se describen en [Reseñas MongoDB](RESENAS_MONGODB.md). La tabla SQL Resenas permanece como histórica y no actúa como conmutación automática.

## Exportaciones

Los 17 archivos de `database/json` provienen de CSV y usan Extended JSON. Su existencia no implica que todas esas colecciones estén activas ni sincronizadas. Véase [formato/importación](../database/json/README.md).

## Propuesta no implementada: interacciones

Una futura colección podría guardar eventos de navegación. Ejemplo conceptual, no dato real ni contrato de API:

```json
{
  "usuarioId": null,
  "sesionId": "sesion-de-ejemplo",
  "tipo": "vista_producto",
  "productoId": 1,
  "categoria": "Ejemplo",
  "terminoBusqueda": null,
  "metadata": {},
  "fecha": {"$date": "2026-09-26T12:00:00.000Z"}
}
```

No existe `database/modelo_nosql.json` en esta copia. El ejemplo queda incluido aquí y no se presenta como archivo entregado. La aplicación no guarda estos eventos ni implementa panel de analítica.

[Volver al índice documental](README.md).
