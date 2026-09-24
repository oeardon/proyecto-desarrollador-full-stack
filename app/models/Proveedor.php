<?php
     function obtenerTodosProveedores($conexion) {
          $sql = "SELECT *
                  FROM Proveedores
                  ORDER BY ProveedorID ASC";
          $stmt = $conexion->prepare($sql);
          $stmt->execute([]);
          return $stmt->fetchAll();
     }

     function obtenerProveedorPorId($conexion, $ProveedorID) {
          $sql = "SELECT *
                  FROM Proveedores
                  WHERE ProveedorID = :ProveedorID";
          $stmt = $conexion->prepare($sql);
          $stmt->execute([":ProveedorID" => $ProveedorID]);
          return $stmt->fetch();
     }

     function crearProveedor($conexion, $datos) {
          $stmt = $conexion->prepare("INSERT INTO Proveedores (Nombre, NIT, Contacto, Correo, Telefono, Direccion, Estado) VALUES (:Nombre, :NIT, :Contacto, :Correo, :Telefono, :Direccion, :Estado)");
          $stmt->execute([":Nombre" => $datos["Nombre"],
                         ":NIT" => $datos["NIT"],
                         ":Contacto" => $datos["Contacto"],
                         ":Correo" => $datos["Correo"],
                         ":Telefono" => $datos["Telefono"],
                         ":Direccion" => $datos["Direccion"],
                         ":Estado" => $datos["Estado"]]);
          return $conexion->lastInsertId();
     }

     function actualizarProveedor($conexion, $ProveedorID, $datos) {
          $sql = "UPDATE Proveedores
                  SET Nombre = :Nombre,
                      NIT = :NIT,
                      Contacto = :Contacto,
                      Correo = :Correo,
                      Telefono = :Telefono,
                      Direccion = :Direccion,
                      Estado = :Estado
                  WHERE ProveedorID = :ProveedorID";
          $stmt = $conexion->prepare($sql);
          $parametros = [":Nombre" => $datos["Nombre"],
                         ":NIT" => $datos["NIT"],
                         ":Contacto" => $datos["Contacto"],
                         ":Correo" => $datos["Correo"],
                         ":Telefono" => $datos["Telefono"],
                         ":Direccion" => $datos["Direccion"],
                         ":Estado" => $datos["Estado"],
                         ":ProveedorID" => $ProveedorID];
          return $stmt->execute($parametros);
     }

     function eliminarProveedor($conexion, $ProveedorID) {
          $sql = "DELETE FROM Proveedores 
                  WHERE ProveedorID = :ProveedorID";
          $stmt = $conexion->prepare($sql);
          $stmt->execute([":ProveedorID" => $ProveedorID]);
          return $stmt->rowCount() > 0;
     }
?>