USE todoaqui_db;

LOAD DATA LOCAL INFILE 'C:/xampp/htdocs/tienda_online/database/csv/usuarios.csv'
INTO TABLE Usuarios
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '\''
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(UsuarioID,Nombres,Apellidos,Correo,Telefono,Usuario,Contrasena,TipoUsuario,Estado,FechaRegistro);

LOAD DATA LOCAL INFILE 'C:/xampp/htdocs/tienda_online/database/csv/direcciones.csv'
INTO TABLE Direcciones
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(DireccionID,Direccion,Ciudad,Subnacional,Pais,UsuarioID,CodigoPostal,TipoDireccion,EsPrincipal);