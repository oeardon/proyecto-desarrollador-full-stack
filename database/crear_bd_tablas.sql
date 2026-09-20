CREATE DATABASE IF NOT EXISTS todoaqui_db
CHARACTER SET utf8mb4
COLLATE utf8mb4_general_ci;

USE todoaqui_db;

CREATE TABLE Usuarios(
     UsuarioID INT AUTO_INCREMENT,
     Nombres VARCHAR(75) NOT NULL,
     Apellidos VARCHAR(75) NOT NULL,
     Correo VARCHAR(100) NOT NULL UNIQUE,
     Telefono VARCHAR(20) NOT NULL UNIQUE,
     Usuario VARCHAR(50) NOT NULL UNIQUE,
     Contrasena VARCHAR(255) NOT NULL,
     TipoUsuario ENUM('Administrador', 'Cliente') NOT NULL DEFAULT 'Cliente',
     Estado ENUM('Activo', 'Inactivo') NOT NULL DEFAULT 'Activo',
     FechaRegistro DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
     CONSTRAINT PK_Usuarios PRIMARY KEY (UsuarioID)
);
CREATE TABLE Direcciones(
     DireccionID INT AUTO_INCREMENT,
     Direccion VARCHAR(255) NOT NULL,
     Ciudad VARCHAR(75) NOT NULL,
     Subnacional VARCHAR(100) NOT NULL,
     Pais VARCHAR(50) NOT NULL DEFAULT 'Guatemala',
     UsuarioID INT NOT NULL,
     CodigoPostal VARCHAR(15),
     TipoDireccion ENUM('Casa', 'Trabajo', 'Otro') NOT NULL DEFAULT 'Casa',
     EsPrincipal BOOLEAN NOT NULL DEFAULT FALSE,
     CONSTRAINT PK_Direcciones PRIMARY KEY (DireccionID),
     CONSTRAINT FK_Direcciones_Usuarios FOREIGN KEY (UsuarioID) REFERENCES Usuarios(UsuarioID)
);
CREATE TABLE Categorias(
     CategoriaID INT AUTO_INCREMENT,
     Nombre VARCHAR(100) NOT NULL UNIQUE,
     Descripcion VARCHAR(255),
     Estado ENUM('Activo', 'Inactivo') NOT NULL DEFAULT 'Activo',
     CategoriaPadreID INT,
     CONSTRAINT PK_Categorias PRIMARY KEY (CategoriaID),
     CONSTRAINT FK_Categorias_Padre FOREIGN KEY (CategoriaPadreID) REFERENCES Categorias(CategoriaID)
          ON DELETE SET NULL
);
CREATE TABLE Proveedores(
     ProveedorID INT AUTO_INCREMENT,
     Nombre VARCHAR(150) NOT NULL,
     NIT VARCHAR(20),
     Contacto VARCHAR(100),
     Correo VARCHAR(100),
     Telefono VARCHAR(20),
     Direccion VARCHAR(255),
     Estado ENUM('Activo', 'Inactivo') NOT NULL DEFAULT 'Activo',
     FechaRegistro DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
     CONSTRAINT PK_Proveedores PRIMARY KEY (ProveedorID)
);
CREATE TABLE Productos(
     ProductoID INT AUTO_INCREMENT,
     CategoriaID INT NOT NULL,
     SKU VARCHAR(50) UNIQUE,
     Nombre VARCHAR(150) NOT NULL,
     Descripcion VARCHAR(255),
     Precio DECIMAL(10,2) NOT NULL CHECK (Precio >= 0),
     Cantidad INT NOT NULL DEFAULT 0 CHECK (Cantidad >= 0),
     Imagen VARCHAR(255),
     Estado ENUM('Activo', 'Inactivo') NOT NULL DEFAULT 'Activo',
     FechaRegistro DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
     CONSTRAINT PK_Productos PRIMARY KEY (ProductoID),
     CONSTRAINT FK_Productos_Categorias FOREIGN KEY (CategoriaID) REFERENCES Categorias(CategoriaID)
);
CREATE TABLE Promociones(
     PromocionID INT AUTO_INCREMENT,
     Nombre VARCHAR(255) NOT NULL,
     Descripcion VARCHAR(255),
     TipoDescuento ENUM('Porcentaje', 'Monto') NOT NULL,
     ValorDescuento DECIMAL(10,2) NOT NULL CHECK (ValorDescuento >= 0),
     FechaInicio DATETIME NOT NULL,
     FechaFin DATETIME,
     RequiereCupon BOOLEAN NOT NULL DEFAULT FALSE,
     CodigoCupon VARCHAR(40) UNIQUE,
     AplicaTodosProductos BOOLEAN NOT NULL DEFAULT FALSE,
     Estado ENUM('Activo', 'Inactivo') NOT NULL DEFAULT 'Activo',
     CONSTRAINT PK_Promociones PRIMARY KEY (PromocionID),
     CONSTRAINT CK_Promociones_Fechas CHECK (FechaFin IS NULL OR FechaFin >= FechaInicio),
     CONSTRAINT CK_Promociones_Valor CHECK (TipoDescuento = 'Monto' OR ValorDescuento <= 100)
);
CREATE TABLE ProductosProveedores(
     ProductoID INT NOT NULL,
     ProveedorID INT NOT NULL,
     CostoCompra DECIMAL(10,2) CHECK (CostoCompra >= 0),
     EsPrincipal BOOLEAN NOT NULL DEFAULT FALSE,
     CONSTRAINT PK_ProductosProveedores PRIMARY KEY (ProductoID, ProveedorID),
     CONSTRAINT FK_ProductosProveedores_Productos FOREIGN KEY (ProductoID) REFERENCES Productos(ProductoID)
          ON DELETE CASCADE,
     CONSTRAINT FK_ProductosProveedores_Proveedores FOREIGN KEY (ProveedorID) REFERENCES Proveedores(ProveedorID)
          ON DELETE CASCADE
);
CREATE TABLE ProductosPromociones(
     ProductoID INT NOT NULL,
     PromocionID INT NOT NULL,
     CONSTRAINT PK_ProductosPromociones PRIMARY KEY (ProductoID, PromocionID),
     CONSTRAINT FK_ProductosPromociones_Productos FOREIGN KEY (ProductoID) REFERENCES Productos(ProductoID)
          ON DELETE CASCADE,
     CONSTRAINT FK_ProductosPromociones_Promociones FOREIGN KEY (PromocionID) REFERENCES Promociones(PromocionID)
          ON DELETE CASCADE
);
CREATE TABLE Ordenes(
     OrdenID INT AUTO_INCREMENT,
     UsuarioID INT NOT NULL,
     FechaOrden DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
     DireccionPago VARCHAR(255) NOT NULL,
     DireccionEnvio VARCHAR(255) NOT NULL,
     Subtotal DECIMAL(10,2) NOT NULL,
     DescuentoTotal DECIMAL(10,2) NOT NULL DEFAULT 0.00,
     ImpuestoTotal DECIMAL(10,2) NOT NULL DEFAULT 0.00,
     CostoEnvio DECIMAL(10,2) NOT NULL DEFAULT 0.00,
     Total DECIMAL(10,2) NOT NULL,
     Estado ENUM('Pendiente','Confirmada','Procesando','Enviada','Entregada','Cancelada') NOT NULL DEFAULT 'Pendiente',
     CONSTRAINT PK_Ordenes PRIMARY KEY (OrdenID),
     CONSTRAINT FK_Ordenes_Usuarios FOREIGN KEY (UsuarioID) REFERENCES Usuarios(UsuarioID)
);
CREATE TABLE DetalleOrdenes(
     DetalleOrdenID INT AUTO_INCREMENT,
     OrdenID INT NOT NULL,
     ProductoID INT NOT NULL,
     Cantidad INT NOT NULL CHECK (Cantidad > 0),
     PrecioUnitario DECIMAL(10,2) NOT NULL,
     Descuento DECIMAL(10,2) NOT NULL DEFAULT 0.00,
     Subtotal DECIMAL(10,2) NOT NULL,
     CONSTRAINT PK_DetalleOrdenes PRIMARY KEY (DetalleOrdenID),
     CONSTRAINT FK_DetalleOrdenes_Ordenes FOREIGN KEY (OrdenID) REFERENCES Ordenes(OrdenID),
     CONSTRAINT FK_DetalleOrdenes_Productos FOREIGN KEY (ProductoID) REFERENCES Productos(ProductoID)
);
CREATE TABLE Pagos(
     PagoID INT AUTO_INCREMENT,
     OrdenID INT NOT NULL,
     FechaPago DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
     Monto DECIMAL(10,2) NOT NULL CHECK (Monto >= 0),
     MetodoPago VARCHAR(30) NOT NULL,
     ReferenciaPago VARCHAR(100),
     Notas VARCHAR(255),
     Estado ENUM('Pendiente','Completado','Rechazado','Reembolsado') NOT NULL DEFAULT 'Pendiente',
     CONSTRAINT PK_Pagos PRIMARY KEY (PagoID),
     CONSTRAINT FK_Pagos_Ordenes FOREIGN KEY (OrdenID) REFERENCES Ordenes(OrdenID)
);
CREATE TABLE Facturas(
     FacturaID INT AUTO_INCREMENT,
     NumeroFactura VARCHAR(50) NOT NULL UNIQUE,
     FechaEmision DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
     OrdenID INT NOT NULL,
     Nombre VARCHAR(150) NOT NULL,
     NIT VARCHAR(20) NOT NULL DEFAULT 'CF',
     Direccion VARCHAR(255) NOT NULL,
     Subtotal DECIMAL(10,2) NOT NULL,
     ImpuestoTotal DECIMAL(10,2) NOT NULL DEFAULT 0.00,
     DescuentoTotal DECIMAL(10,2) NOT NULL DEFAULT 0.00,
     Total DECIMAL(10,2) NOT NULL,
     Notas VARCHAR(255),
     Estado ENUM('Emitida', 'Anulada') NOT NULL DEFAULT 'Emitida',
     CONSTRAINT PK_Facturas PRIMARY KEY (FacturaID),
     CONSTRAINT FK_Facturas_Ordenes FOREIGN KEY (OrdenID) REFERENCES Ordenes(OrdenID)
);
CREATE TABLE DetalleFacturas(
     DetalleFacturaID INT AUTO_INCREMENT,
     FacturaID INT NOT NULL,
     DetalleOrdenID INT NOT NULL,
     Descripcion VARCHAR(255) NOT NULL,
     Cantidad INT NOT NULL CHECK (Cantidad > 0),
     PrecioUnitario DECIMAL(10,2) NOT NULL,
     Descuento DECIMAL(10,2) NOT NULL DEFAULT 0.00,
     Impuesto DECIMAL(10,2) NOT NULL DEFAULT 0.00,
     Subtotal DECIMAL(10,2) NOT NULL,
     CONSTRAINT PK_DetalleFacturas PRIMARY KEY (DetalleFacturaID),
     CONSTRAINT UQ_DetalleFacturas UNIQUE (FacturaID, DetalleOrdenID),
     CONSTRAINT FK_DetalleFacturas_Facturas FOREIGN KEY (FacturaID) REFERENCES Facturas(FacturaID),
     CONSTRAINT FK_DetalleFacturas_DetalleOrdenes FOREIGN KEY (DetalleOrdenID) REFERENCES DetalleOrdenes(DetalleOrdenID)
);
CREATE TABLE Devoluciones(
     DevolucionID INT AUTO_INCREMENT,
     OrdenID INT NOT NULL,
     FechaSolicitud DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
     Motivo VARCHAR(255) NOT NULL,
     Estado ENUM('Solicitada','Aprobada','Rechazada','Procesada') NOT NULL DEFAULT 'Solicitada',
     MontoReembolso DECIMAL(10,2) NOT NULL DEFAULT 0.00,
     Notas VARCHAR(255),
     CONSTRAINT PK_Devoluciones PRIMARY KEY (DevolucionID),
     CONSTRAINT FK_Devoluciones_Ordenes FOREIGN KEY (OrdenID) REFERENCES Ordenes(OrdenID)
);
CREATE TABLE DetalleDevoluciones(
     DetalleDevolucionID INT AUTO_INCREMENT,
     DevolucionID INT NOT NULL,
     DetalleOrdenID INT NOT NULL,
     Cantidad INT NOT NULL CHECK (Cantidad > 0),
     Motivo VARCHAR(255),
     MontoReembolso DECIMAL(10,2) NOT NULL DEFAULT 0.00,
     CONSTRAINT PK_DetalleDevoluciones PRIMARY KEY (DetalleDevolucionID),
     CONSTRAINT UQ_DetalleDevoluciones UNIQUE (DevolucionID, DetalleOrdenID),
     CONSTRAINT FK_DetalleDevoluciones_Devoluciones FOREIGN KEY (DevolucionID) REFERENCES Devoluciones(DevolucionID),
     CONSTRAINT FK_DetalleDevoluciones_DetalleOrdenes FOREIGN KEY (DetalleOrdenID) REFERENCES DetalleOrdenes(DetalleOrdenID)
);
CREATE TABLE ListaDeseos(
     UsuarioID INT NOT NULL,
     ProductoID INT NOT NULL,
     FechaAgregado DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
     CONSTRAINT PK_ListaDeseos PRIMARY KEY (UsuarioID, ProductoID),
     CONSTRAINT FK_ListaDeseos_Usuarios FOREIGN KEY (UsuarioID) REFERENCES Usuarios(UsuarioID)
          ON DELETE CASCADE,
     CONSTRAINT FK_ListaDeseos_Productos FOREIGN KEY (ProductoID) REFERENCES Productos(ProductoID)
          ON DELETE CASCADE
);
CREATE TABLE Resenas(
     ResenaID INT AUTO_INCREMENT,
     UsuarioID INT NOT NULL,
     ProductoID INT NOT NULL,
     Calificacion TINYINT NOT NULL CHECK (Calificacion BETWEEN 1 AND 5),
     Comentario LONGTEXT,
     FechaResena DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
     Estado ENUM('Publicada', 'Oculta') NOT NULL DEFAULT 'Publicada',
     CONSTRAINT PK_Resenas PRIMARY KEY (ResenaID),
     CONSTRAINT UQ_Resenas_UsuarioProducto UNIQUE (UsuarioID, ProductoID),
     CONSTRAINT FK_Resenas_Usuarios FOREIGN KEY (UsuarioID) REFERENCES Usuarios(UsuarioID),
     CONSTRAINT FK_Resenas_Productos FOREIGN KEY (ProductoID) REFERENCES Productos(ProductoID)
);

/* SQL SERVER                 →  MARIADB
   INT IDENTITY(1,1)          →  INT AUTO_INCREMENT
   NVARCHAR(n)                →  VARCHAR(n)
   NVARCHAR(MAX)              →  LONGTEXT
   BIT                        →  TINYINT(1)
   DATETIME                   →  DATETIME
   DATE                       →  DATE
   GETDATE()                  →  CURRENT_TIMESTAMP
   CLUSTERED / NONCLUSTERED   →  eliminar/adaptar */

/* MODELO ER
Usuarios
│
├── Direcciones
│
├── Ordenes
│   │
│   ├── DetalleOrdenes ───── Productos
│   │                         │
│   │                         ├── Categorias
│   │                         │
│   │                         ├── ProductosProveedores
│   │                         │          │
│   │                         │     Proveedores
│   │                         │
│   │                         └── ProductosPromociones
│   │                                    │
│   │                               Promociones
│   │
│   ├── Pagos
│   ├── Facturas
│   │      └── DetalleFacturas
│   │
│   └── Devoluciones
│          └── DetalleDevoluciones
│
├── ListaDeseos ───── Productos
│
└── Resenas ───────── Productos
*/