-- Ajustar directorios de la forma
-- 'C:/xampp/htdocs/*nombre_de_carpeta*/database/csv/*nombre_de_archivo.csv*'

USE todoaqui_db;

LOAD DATA LOCAL INFILE 'C:/xampp/htdocs/proyecto-desarrollador-full-stack/database/csv/usuarios.csv'
INTO TABLE Usuarios
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '\''
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(UsuarioID,Nombres,Apellidos,Correo,Telefono,Usuario,Contrasena,TipoUsuario,Estado,FechaRegistro);

LOAD DATA LOCAL INFILE 'C:/xampp/htdocs/proyecto-desarrollador-full-stack/database/csv/direcciones.csv'
INTO TABLE Direcciones
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(DireccionID,Direccion,Ciudad,Subnacional,Pais,UsuarioID,CodigoPostal,TipoDireccion,EsPrincipal);

LOAD DATA LOCAL INFILE 'C:/xampp/htdocs/proyecto-desarrollador-full-stack/database/csv/categorias.csv'
INTO TABLE Categorias
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
ESCAPED BY ''
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(CategoriaID,Nombre,@Descripcion,Estado,@CategoriaPadreID)
SET Descripcion = NULLIF(@Descripcion, ''),
    CategoriaPadreID = NULLIF(@CategoriaPadreID, '');

LOAD DATA LOCAL INFILE 'C:/xampp/htdocs/proyecto-desarrollador-full-stack/database/csv/proveedores.csv'
INTO TABLE Proveedores
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
ESCAPED BY ''
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(ProveedorID,Nombre,@NIT,@Contacto,@Correo,@Telefono,@Direccion,Estado,FechaRegistro)
SET NIT = NULLIF(@NIT, ''),
    Contacto = NULLIF(@Contacto, ''),
    Correo = NULLIF(@Correo, ''),
    Telefono = NULLIF(@Telefono, ''),
    Direccion = NULLIF(@Direccion, '');

LOAD DATA LOCAL INFILE 'C:/xampp/htdocs/proyecto-desarrollador-full-stack/database/csv/productos.csv'
INTO TABLE Productos
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
ESCAPED BY ''
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(ProductoID,CategoriaID,@SKU,Nombre,@Descripcion,Precio,Cantidad,@Imagen,Estado,FechaRegistro)
SET SKU = NULLIF(@SKU, ''),
    Descripcion = NULLIF(@Descripcion, ''),
    Imagen = NULLIF(@Imagen, '');

LOAD DATA LOCAL INFILE 'C:/xampp/htdocs/proyecto-desarrollador-full-stack/database/csv/promociones.csv'
INTO TABLE Promociones
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
ESCAPED BY ''
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(PromocionID,Nombre,@Descripcion,TipoDescuento,ValorDescuento,FechaInicio,@FechaFin,RequiereCupon,@CodigoCupon,AplicaTodosProductos,Estado)
SET Descripcion = NULLIF(@Descripcion, ''),
    FechaFin = NULLIF(@FechaFin, ''),
    CodigoCupon = NULLIF(@CodigoCupon, '');

LOAD DATA LOCAL INFILE 'C:/xampp/htdocs/proyecto-desarrollador-full-stack/database/csv/productosproveedores.csv'
INTO TABLE ProductosProveedores
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
ESCAPED BY ''
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(ProductoID,ProveedorID,@CostoCompra,EsPrincipal)
SET CostoCompra = NULLIF(@CostoCompra, '');

LOAD DATA LOCAL INFILE 'C:/xampp/htdocs/proyecto-desarrollador-full-stack/database/csv/productospromociones.csv'
INTO TABLE ProductosPromociones
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
ESCAPED BY ''
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(ProductoID,PromocionID);

LOAD DATA LOCAL INFILE 'C:/xampp/htdocs/proyecto-desarrollador-full-stack/database/csv/ordenes.csv'
INTO TABLE Ordenes
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
ESCAPED BY ''
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(OrdenID,UsuarioID,FechaOrden,DireccionPago,DireccionEnvio,Subtotal,DescuentoTotal,ImpuestoTotal,CostoEnvio,Total,Estado);

LOAD DATA LOCAL INFILE 'C:/xampp/htdocs/proyecto-desarrollador-full-stack/database/csv/detalleordenes.csv'
INTO TABLE DetalleOrdenes
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
ESCAPED BY ''
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(DetalleOrdenID,OrdenID,ProductoID,Cantidad,PrecioUnitario,Descuento,Subtotal);

LOAD DATA LOCAL INFILE 'C:/xampp/htdocs/proyecto-desarrollador-full-stack/database/csv/pagos.csv'
INTO TABLE Pagos
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
ESCAPED BY ''
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(PagoID,OrdenID,FechaPago,Monto,MetodoPago,@ReferenciaPago,@Notas,Estado)
SET ReferenciaPago = NULLIF(@ReferenciaPago, ''),
    Notas = NULLIF(@Notas, '');

LOAD DATA LOCAL INFILE 'C:/xampp/htdocs/proyecto-desarrollador-full-stack/database/csv/facturas.csv'
INTO TABLE Facturas
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
ESCAPED BY ''
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(FacturaID,NumeroFactura,FechaEmision,OrdenID,Nombre,NIT,Direccion,Subtotal,ImpuestoTotal,DescuentoTotal,Total,@Notas,Estado)
SET Notas = NULLIF(@Notas, '');

LOAD DATA LOCAL INFILE 'C:/xampp/htdocs/proyecto-desarrollador-full-stack/database/csv/detallefacturas.csv'
INTO TABLE DetalleFacturas
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
ESCAPED BY ''
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(DetalleFacturaID,FacturaID,DetalleOrdenID,Descripcion,Cantidad,PrecioUnitario,Descuento,Impuesto,Subtotal);

LOAD DATA LOCAL INFILE 'C:/xampp/htdocs/proyecto-desarrollador-full-stack/database/csv/devoluciones.csv'
INTO TABLE Devoluciones
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
ESCAPED BY ''
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(DevolucionID,OrdenID,FechaSolicitud,Motivo,Estado,MontoReembolso,@Notas)
SET Notas = NULLIF(@Notas, '');

LOAD DATA LOCAL INFILE 'C:/xampp/htdocs/proyecto-desarrollador-full-stack/database/csv/detalledevoluciones.csv'
INTO TABLE DetalleDevoluciones
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
ESCAPED BY ''
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(DetalleDevolucionID,DevolucionID,DetalleOrdenID,Cantidad,@Motivo,MontoReembolso)
SET Motivo = NULLIF(@Motivo, '');

LOAD DATA LOCAL INFILE 'C:/xampp/htdocs/proyecto-desarrollador-full-stack/database/csv/listadeseos.csv'
INTO TABLE ListaDeseos
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
ESCAPED BY ''
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(UsuarioID,ProductoID,FechaAgregado);

LOAD DATA LOCAL INFILE 'C:/xampp/htdocs/proyecto-desarrollador-full-stack/database/csv/resenas.csv'
INTO TABLE Resenas
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
ESCAPED BY ''
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(ResenaID,UsuarioID,ProductoID,Calificacion,@Comentario,FechaResena,Estado)
SET Comentario = NULLIF(@Comentario, '');