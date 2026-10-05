# JSON para MongoDB Atlas

Exportación histórica de los 17 CSV originales de `database/csv`: 1,120 documentos según el registro de conversión. La conversión no modificó MariaDB ni importó por sí sola estos archivos a Atlas. Actualmente Atlas sí forma parte de la aplicación para reseñas; el usuario confirmó conectividad local. No interpretar esta exportación como un respaldo vivo o sincronizado.

## Formato y tipos

- UTF-8 sin BOM. Cada archivo contiene un arreglo JSON de documentos, con un documento por fila del CSV.
- Se usa Extended JSON v2 de MongoDB para preservar fechas y decimales.
- Identificadores, cantidades y calificaciones: enteros. Se conservan los nombres originales, como `UsuarioID`, `CategoriaID` y `ProductoID`.
- Booleanos SQL: `true` y `false`.
- Campos vacíos de columnas que admiten nulos: `null`.
- Importes: Decimal128, por ejemplo `"Precio": {"$numberDecimal": "3299.00"}`. Evita convertir dinero a números de punto flotante.
- Fechas: BSON Date, por ejemplo `"FechaRegistro": {"$date": "2026-07-01T15:00:00.000Z"}`. Los CSV no incluyen zona horaria; se asumió horario de Guatemala (UTC-06:00). Esa fecha equivale a las 09:00:00 locales del CSV. Si los datos originales usan otra zona, debe ajustarse la conversión antes de importar.
- Teléfonos, códigos postales, NIT, SKU, textos y contraseñas se conservan como cadenas. No se generaron ni cambiaron contraseñas.
- Se respetaron las comillas simples de `usuarios.csv` y se omitió únicamente la columna sin nombre causada por la coma final del encabezado de `direcciones.csv`.

## Colecciones

Cada archivo propone una colección con el nombre de la tabla original. Se preserva el modelo exportado con referencias por ID: no se incrustaron órdenes, direcciones ni detalles dentro de otros documentos.

No se añadió `_id`; MongoDB lo genera durante la importación. Las relaciones continúan usando los campos originales, no los nuevos ObjectId. Antes de repetir una importación, considerar que esos campos no tienen automáticamente índices únicos ni validación de claves foráneas como en SQL.

| Archivo | Colección sugerida | Documentos |
| --- | --- | ---: |
| categorias.json | Categorias | 48 |
| detalledevoluciones.json | DetalleDevoluciones | 4 |
| detallefacturas.json | DetalleFacturas | 96 |
| detalleordenes.json | DetalleOrdenes | 108 |
| devoluciones.json | Devoluciones | 4 |
| direcciones.json | Direcciones | 150 |
| facturas.json | Facturas | 32 |
| listadeseos.json | ListaDeseos | 72 |
| ordenes.json | Ordenes | 36 |
| pagos.json | Pagos | 34 |
| productos.json | Productos | 108 |
| productospromociones.json | ProductosPromociones | 108 |
| productosproveedores.json | ProductosProveedores | 108 |
| promociones.json | Promociones | 12 |
| proveedores.json | Proveedores | 12 |
| resenas.json | Resenas | 36 |
| usuarios.json | Usuarios | 152 |

## Importación

En MongoDB Compass, conectado al clúster de Atlas, abrir la colección correspondiente y usar **Add Data → Import JSON or CSV file**, seleccionando su archivo JSON.

Con `mongoimport`, estos archivos requieren `--jsonArray`. Ejemplo de plantilla (no ejecutada):

```powershell
mongoimport --uri "mongodb+srv://<cluster>/" --username "<usuario-atlas>" --db todoaqui_db --collection Productos --file "C:/xampp/htdocs/tienda_online/database/json/productos.json" --jsonArray
```

Este usuario es el usuario de conexión a Atlas, no un registro de la colección Usuarios. Dejar que la herramienta solicite la contraseña; no incluirla en el archivo.

La conversión original no cambió el backend. Actualmente, las reseñas se consultan y modifican en MongoDB; usuarios, productos y compras siguen usando MariaDB/PDO. Las copias JSON de Usuarios y Productos son exportaciones, no colecciones sincronizadas por la aplicación. Véase [la integración de reseñas](../../docs/RESENAS_MONGODB.md).

Fuentes oficiales:
- [MongoDB Extended JSON v2](https://www.mongodb.com/docs/manual/reference/mongodb-extended-json/)
- [Importación con Compass](https://www.mongodb.com/docs/compass/import-export/)
- [mongoimport](https://www.mongodb.com/docs/database-tools/mongoimport/)

## Alcance de instalación

No es necesario importar todas estas colecciones para ejecutar la tienda. Usuarios, productos y operaciones transaccionales se consultan en MariaDB. La preparación del entregable se explica en [Base de datos](../../docs/BASE_DATOS.md) e [Instalación](../../docs/INSTALACION_LOCAL.md). La revisión documental no ejecutó importaciones.
