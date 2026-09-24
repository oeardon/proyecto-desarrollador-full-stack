USE todoaqui_db;

START TRANSACTION;

INSERT INTO Categorias (CategoriaID, Nombre, Descripcion, Estado, CategoriaPadreID) VALUES
(1, 'Celulares', 'Celulares y dispositivos móviles', 'Activo', NULL),
(2, 'Computación', 'Laptops, monitores y equipos de cómputo', 'Activo', NULL),
(3, 'Audio', 'Audífonos, bocinas y accesorios de audio', 'Activo', NULL),
(4, 'Gaming', 'Equipos y accesorios para videojuegos', 'Activo', NULL),
(5, 'Hogar inteligente', 'Tecnología conectada para el hogar', 'Activo', NULL),
(6, 'Accesorios', 'Accesorios tecnológicos para uso diario', 'Activo', NULL)
ON DUPLICATE KEY UPDATE
Nombre = VALUES(Nombre),
Descripcion = VALUES(Descripcion),
Estado = VALUES(Estado);

INSERT INTO Productos (ProductoID, CategoriaID, SKU, Nombre, Descripcion, Precio, Cantidad, Imagen, Estado) VALUES
(1, 1, 'TA-CEL-001', 'Smartphone Nova X 256 GB', 'Smartphone de alto rendimiento con 256 GB de almacenamiento', 3299.00, 25, 'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?auto=format&fit=crop&w=900&q=85', 'Activo'),
(2, 2, 'TA-COM-001', 'Laptop Air 14 16 GB RAM', 'Laptop ligera de 14 pulgadas con 16 GB de memoria RAM', 5799.00, 18, 'https://images.unsplash.com/photo-1496181133206-80ce9b88a853?auto=format&fit=crop&w=900&q=85', 'Activo'),
(3, 3, 'TA-AUD-001', 'Audífonos Wave Pro ANC', 'Audífonos inalámbricos con cancelación activa de ruido', 649.00, 40, 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?auto=format&fit=crop&w=900&q=85', 'Activo'),
(4, 4, 'TA-GAM-001', 'Teclado Mecánico RGB', 'Teclado mecánico con iluminación RGB', 499.00, 35, 'https://images.unsplash.com/photo-1587829741301-dc798b83add3?auto=format&fit=crop&w=900&q=85', 'Activo'),
(5, 6, 'TA-ACC-001', 'Smartwatch Active S', 'Reloj inteligente para actividad diaria', 899.00, 30, 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=900&q=85', 'Activo'),
(6, 2, 'TA-COM-002', 'Monitor UltraView 27', 'Monitor de 27 pulgadas para trabajo y entretenimiento', 1699.00, 22, 'https://images.unsplash.com/photo-1527443224154-c4a3942d3acf?auto=format&fit=crop&w=900&q=85', 'Activo'),
(7, 3, 'TA-AUD-002', 'Bocina Pulse Bluetooth', 'Bocina portátil con conexión Bluetooth', 429.00, 28, 'https://images.unsplash.com/photo-1608043152269-423dbba4e7e1?auto=format&fit=crop&w=900&q=85', 'Activo'),
(8, 5, 'TA-HOG-001', 'Cámara Home Secure 2K', 'Cámara inteligente de seguridad para el hogar', 599.00, 32, 'https://images.unsplash.com/photo-1557324232-b8917d3c3dcb?auto=format&fit=crop&w=900&q=85', 'Activo')
ON DUPLICATE KEY UPDATE
CategoriaID = VALUES(CategoriaID),
SKU = VALUES(SKU),
Nombre = VALUES(Nombre),
Descripcion = VALUES(Descripcion),
Precio = VALUES(Precio),
Cantidad = VALUES(Cantidad),
Imagen = VALUES(Imagen),
Estado = VALUES(Estado);

COMMIT;

SELECT ProductoID, Nombre, Precio, Cantidad, Estado FROM Productos ORDER BY ProductoID;
