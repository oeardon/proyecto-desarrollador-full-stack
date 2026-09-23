<?php
     function obtenerListaDeseos($conexion, $UsuarioID) {
          $sql = "SELECT L.ProductoID, L.FechaAgregado, P.Nombre, P.Precio, P.Imagen, P.Estado
                  FROM ListaDeseos L
                  INNER JOIN Productos P 
                    ON P.ProductoID = L.ProductoID
                  WHERE L.UsuarioID = :UsuarioID
                  ORDER BY L.FechaAgregado DESC";
          $stmt = $conexion->prepare($sql);
          $stmt->execute([":UsuarioID" => $UsuarioID]);
          return $stmt->fetchAll();
     }

     function obtenerDeseoPorProducto($conexion, $UsuarioID, $ProductoID) {
          $sql = "SELECT L.ProductoID, L.FechaAgregado, P.Nombre, P.Precio, P.Imagen, P.Estado
                  FROM ListaDeseos L
                  INNER JOIN Productos P 
                    ON P.ProductoID = L.ProductoID
                  WHERE L.UsuarioID = :UsuarioID AND L.ProductoID = :ProductoID";
          $stmt = $conexion->prepare($sql);
          $stmt->execute([":UsuarioID" => $UsuarioID, ":ProductoID" => $ProductoID]);
          return $stmt->fetch();
     }

     function crearDeseo($conexion, $UsuarioID, $ProductoID) {
          $sql = "INSERT INTO ListaDeseos (UsuarioID, ProductoID)
                  VALUES (:UsuarioID, :ProductoID)";
          $stmt = $conexion->prepare($sql);
          return $stmt->execute([":UsuarioID" => $UsuarioID, ":ProductoID" => $ProductoID]);
     }

     function eliminarDeseo($conexion, $UsuarioID, $ProductoID) {
          $sql = "DELETE FROM ListaDeseos
                  WHERE UsuarioID = :UsuarioID AND ProductoID = :ProductoID";
          $stmt = $conexion->prepare($sql);
          $stmt->execute([":UsuarioID" => $UsuarioID, ":ProductoID" => $ProductoID]);
          return $stmt->rowCount() > 0;
     }
?>