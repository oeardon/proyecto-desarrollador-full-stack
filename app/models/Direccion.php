<?php
     function obtenerTodosDirecciones($conexion, $UsuarioID = null) {
          $sql = "SELECT D.*, TRIM(CONCAT(U.Nombres, ' ', U.Apellidos)) AS UsuarioNombre
                  FROM Direcciones D
                  LEFT JOIN Usuarios U ON U.UsuarioID = D.UsuarioID";
          if ($UsuarioID !== null) {
               $sql .= " WHERE D.UsuarioID = :UsuarioID";
          }
          $sql .= " ORDER BY D.DireccionID ASC";
          $stmt = $conexion->prepare($sql);
          $stmt->execute($UsuarioID === null ? [] : [":UsuarioID" => $UsuarioID]);
          return $stmt->fetchAll();
     }

     function obtenerDireccionPorId($conexion, $DireccionID) {
          $sql = "SELECT D.*, TRIM(CONCAT(U.Nombres, ' ', U.Apellidos)) AS UsuarioNombre
                  FROM Direcciones D
                  LEFT JOIN Usuarios U ON U.UsuarioID = D.UsuarioID
                  WHERE D.DireccionID = :DireccionID";
          $stmt = $conexion->prepare($sql);
          $stmt->execute([":DireccionID" => $DireccionID]);
          return $stmt->fetch();
     }

     function crearDireccion($conexion, $datos) {
          $sql = "INSERT INTO Direcciones (Direccion, Ciudad, Subnacional, Pais, UsuarioID, CodigoPostal, TipoDireccion, EsPrincipal)
                  VALUES (:Direccion, :Ciudad, :Subnacional, :Pais, :UsuarioID, :CodigoPostal, :TipoDireccion, :EsPrincipal)";
          $stmt = $conexion->prepare($sql);
          $stmt->execute([":Direccion" => $datos["Direccion"],
                          ":Ciudad" => $datos["Ciudad"],
                          ":Subnacional" => $datos["Subnacional"],
                          ":Pais" => $datos["Pais"],
                          ":UsuarioID" => $datos["UsuarioID"],
                          ":CodigoPostal" => $datos["CodigoPostal"],
                          ":TipoDireccion" => $datos["TipoDireccion"],
                          ":EsPrincipal" => $datos["EsPrincipal"]]);
          return $conexion->lastInsertId();
     }

     function actualizarDireccion($conexion, $DireccionID, $datos) {
          $sql = "UPDATE Direcciones
                  SET Direccion = :Direccion,
                      Ciudad = :Ciudad,
                      Subnacional = :Subnacional,
                      Pais = :Pais,
                      UsuarioID = :UsuarioID,
                      CodigoPostal = :CodigoPostal,
                      TipoDireccion = :TipoDireccion,
                      EsPrincipal = :EsPrincipal
                  WHERE DireccionID = :DireccionID";
          $stmt = $conexion->prepare($sql);
          $parametros = [":Direccion" => $datos["Direccion"],
                         ":Ciudad" => $datos["Ciudad"],
                         ":Subnacional" => $datos["Subnacional"],
                         ":Pais" => $datos["Pais"],
                         ":UsuarioID" => $datos["UsuarioID"],
                         ":CodigoPostal" => $datos["CodigoPostal"],
                         ":TipoDireccion" => $datos["TipoDireccion"],
                         ":EsPrincipal" => $datos["EsPrincipal"],
                         ":DireccionID" => $DireccionID];
          return $stmt->execute($parametros);
     }

     function eliminarDireccion($conexion, $DireccionID) {
          $sql = "DELETE FROM Direcciones
                  WHERE DireccionID = :DireccionID";
          $stmt = $conexion->prepare($sql);
          $stmt->execute([":DireccionID" => $DireccionID]);
          return $stmt->rowCount() > 0;
     }

     function bloquearUsuarioDireccion($conexion, $UsuarioID) {
          $sql = "SELECT UsuarioID
                  FROM Usuarios
                  WHERE UsuarioID = :UsuarioID FOR UPDATE";
          $stmt = $conexion->prepare($sql);
          $stmt->execute([":UsuarioID" => $UsuarioID]);
          return $stmt->fetch();
     }
     
     function quitarPrincipalDirecciones($conexion, $UsuarioID) {
          $sql = "UPDATE Direcciones
                  SET EsPrincipal = 0
                  WHERE UsuarioID = :UsuarioID";
          $stmt = $conexion->prepare($sql);
          return $stmt->execute([":UsuarioID" => $UsuarioID]);
     }
?>