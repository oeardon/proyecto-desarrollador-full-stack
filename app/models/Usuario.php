<?php
     require_once __DIR__ . '/../services/ResenasMongo.php';
     function obtenerTodosUsuarios($conexion) {
          $sql = "SELECT UsuarioID, Nombres, Apellidos, Correo, Telefono, Usuario, TipoUsuario, Estado, FechaRegistro
                  FROM Usuarios
                  ORDER BY UsuarioID ASC";
          $stmt = $conexion->prepare($sql);
          $stmt->execute([]);
          return $stmt->fetchAll();
     }

     function obtenerUsuarioPorId($conexion, $UsuarioID) {
          $sql = "SELECT UsuarioID, Nombres, Apellidos, Correo, Telefono, Usuario, TipoUsuario, Estado, FechaRegistro
                  FROM Usuarios
                  WHERE UsuarioID = :UsuarioID";
          $stmt = $conexion->prepare($sql);
          $stmt->execute([":UsuarioID" => $UsuarioID]);
          return $stmt->fetch();
     }

     function crearUsuario($conexion, $datos) {
          $sql = "INSERT INTO Usuarios (Nombres, Apellidos, Correo, Telefono, Usuario, Contrasena, TipoUsuario, Estado)
                  VALUES (:Nombres, :Apellidos, :Correo, :Telefono, :Usuario, :Contrasena, :TipoUsuario, :Estado)";
          $stmt = $conexion->prepare($sql);
          $stmt->execute([":Nombres" => $datos["Nombres"],
                          ":Apellidos" => $datos["Apellidos"],
                          ":Correo" => $datos["Correo"],
                          ":Telefono" => $datos["Telefono"],
                          ":Usuario" => $datos["Usuario"],
                          ":Contrasena" => $datos["Contrasena"],
                          ":TipoUsuario" => $datos["TipoUsuario"],
                          ":Estado" => $datos["Estado"]]);
          return $conexion->lastInsertId();
     }

     function actualizarUsuario($conexion, $UsuarioID, $datos) {
          $sql = "UPDATE Usuarios 
                  SET Nombres = :Nombres,
                      Apellidos = :Apellidos,
                      Correo = :Correo,
                      Telefono = :Telefono,
                      Usuario = :Usuario,
                      TipoUsuario = :TipoUsuario,
                      Estado = :Estado";
          if (array_key_exists("Contrasena", $datos) && $datos["Contrasena"] !== null) {
               $sql .= ", Contrasena = :Contrasena";
          }
          $sql .= " WHERE UsuarioID = :UsuarioID";
          $stmt = $conexion->prepare($sql);
          $parametros = [":Nombres" => $datos["Nombres"],
                         ":Apellidos" => $datos["Apellidos"],
                         ":Correo" => $datos["Correo"],
                         ":Telefono" => $datos["Telefono"],
                         ":Usuario" => $datos["Usuario"],
                         ":TipoUsuario" => $datos["TipoUsuario"],
                         ":Estado" => $datos["Estado"],
                         ":UsuarioID" => $UsuarioID];
          if (array_key_exists("Contrasena", $datos) && $datos["Contrasena"] !== null) {
               $parametros[":Contrasena"] = $datos["Contrasena"];
          }
          return $stmt->execute($parametros);
     }

     function eliminarUsuario($conexion, $UsuarioID) {
          exigirSinResenasMongo('UsuarioID', $UsuarioID);
          $sql = "DELETE FROM Usuarios
                  WHERE UsuarioID = :UsuarioID";
          $stmt = $conexion->prepare($sql);
          $stmt->execute([":UsuarioID" => $UsuarioID]);
          return $stmt->rowCount() > 0;
     }
     function obtenerUsuarioParaLogin($conexion, $identificador, $porCorreo = false) {
          $sql = "SELECT UsuarioID, Usuario, Contrasena, TipoUsuario FROM Usuarios WHERE ";
          $sql .= $porCorreo ? "Correo = :Identificador" : "Usuario = :Identificador";
          $sql .= " AND Estado = 'Activo'";
          $stmt = $conexion->prepare($sql);
          $stmt->execute([":Identificador" => $identificador]);
          return $stmt->fetch();
     }

     function existeUsuarioDuplicado($conexion, $datos) {
          $sql = "SELECT UsuarioID FROM Usuarios
                  WHERE Correo = :Correo OR Telefono = :Telefono OR Usuario = :Usuario
                  LIMIT 1";
          $stmt = $conexion->prepare($sql);
          $stmt->execute([":Correo" => $datos["Correo"],
                          ":Telefono" => $datos["Telefono"],
                          ":Usuario" => $datos["Usuario"]]);
          return $stmt->fetch() !== false;
     }
?>