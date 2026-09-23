<?php
     function obtenerUsuarioSesion($conexion, $UsuarioID) {
          $sql = "SELECT UsuarioID, Usuario, TipoUsuario, Estado 
                  FROM Usuarios
                  WHERE UsuarioID = :UsuarioID";
          $stmt = $conexion->prepare($sql);
          $stmt->execute([":UsuarioID" => $UsuarioID]);
          return $stmt->fetch();
     }
?>