<?php
     function obtenerTodosOrdenes($conexion, $UsuarioID = null) {
          $sql = "SELECT *
                  FROM Ordenes";
          if ($UsuarioID !== null) {
               $sql .= " WHERE UsuarioID = :UsuarioID";
          }
          $stmt = $conexion->prepare($sql." ORDER BY OrdenID ASC");
          $stmt->execute($UsuarioID === null ? [] : [":UsuarioID" => $UsuarioID]);
          return $stmt->fetchAll();
     }

     function obtenerOrdenPorId($conexion, $OrdenID) {
          $sql = "SELECT *
                  FROM Ordenes
                  WHERE OrdenID = :OrdenID";
          $stmt = $conexion->prepare($sql);
          $stmt->execute([":OrdenID" => $OrdenID]);
          return $stmt->fetch();
     }

     function bloquearOrden($conexion, $OrdenID) {
          $sql = "SELECT *
                  FROM Ordenes
                  WHERE OrdenID = :OrdenID FOR UPDATE";
          $stmt = $conexion->prepare($sql);
          $stmt->execute([":OrdenID" => $OrdenID]);
          return $stmt->fetch();
     }

     function obtenerDetallesOrden($conexion, $OrdenID) {
          $sql = "SELECT DO.*, P.Nombre AS Producto
                  FROM DetalleOrdenes DO
                  INNER JOIN Productos P
                    ON P.ProductoID = DO.ProductoID
                  WHERE DO.OrdenID = :OrdenID
                  ORDER BY DO.DetalleOrdenID";
          $stmt = $conexion->prepare($sql);
          $stmt->execute([":OrdenID" => $OrdenID]);
          return $stmt->fetchAll();
     }

     function bloquearProductoOrden($conexion, $ProductoID) {
          $sql = "SELECT ProductoID, Precio, Cantidad, Estado
                  FROM Productos
                  WHERE ProductoID = :ProductoID FOR UPDATE";
          $stmt = $conexion->prepare($sql);
          $stmt->execute([":ProductoID" => $ProductoID]);
          return $stmt->fetch();
     }

     function crearOrden($conexion, $datos) {
          $sql = "INSERT INTO Ordenes (UsuarioID, DireccionPago, DireccionEnvio, Subtotal, Total)
                  VALUES (:UsuarioID, :DireccionPago, :DireccionEnvio, :Subtotal, :Total)";
          $stmt = $conexion->prepare($sql);
          $stmt->execute([":UsuarioID" => $datos["UsuarioID"],
                          ":DireccionPago" => $datos["DireccionPago"],
                          ":DireccionEnvio" => $datos["DireccionEnvio"],
                          ":Subtotal" => $datos["Subtotal"],
                          ":Total" => $datos["Total"]]);
          return $conexion->lastInsertId();
     }

     function crearDetalleOrden($conexion, $OrdenID, $detalle) {
          $sql = "INSERT INTO DetalleOrdenes (OrdenID, ProductoID, Cantidad, PrecioUnitario, Subtotal)
                  VALUES (:OrdenID, :ProductoID, :Cantidad, :PrecioUnitario, :Subtotal)";
          $stmt = $conexion->prepare($sql);
          $stmt->execute([":OrdenID" => $OrdenID,
                          ":ProductoID" => $detalle["ProductoID"],
                          ":Cantidad" => $detalle["Cantidad"],
                          ":PrecioUnitario" => $detalle["PrecioUnitario"],
                          ":Subtotal" => $detalle["Subtotal"]]);
     }

     function cambiarExistenciasOrden($conexion, $ProductoID, $cambio) {
          $sql = "UPDATE Productos
                  SET Cantidad = Cantidad + :Cambio
                  WHERE ProductoID = :ProductoID";
          $stmt = $conexion->prepare($sql);
          return $stmt->execute([":Cambio" => $cambio, ":ProductoID" => $ProductoID]);
     }

     function actualizarEstadoOrden($conexion, $OrdenID, $Estado) {
          $sql = "UPDATE Ordenes
                  SET Estado = :Estado
                  WHERE OrdenID = :OrdenID";
          $stmt = $conexion->prepare($sql);
          return $stmt->execute([":Estado" => $Estado, ":OrdenID" => $OrdenID]);
     }

     function contarPagosOrden($conexion, $OrdenID) {
          $sql = "SELECT COUNT(*)
                  FROM Pagos
                  WHERE OrdenID = :OrdenID AND Estado IN ('Completado', 'Reembolsado')";
          $stmt = $conexion->prepare($sql);
          $stmt->execute([":OrdenID" => $OrdenID]);
          return (int) $stmt->fetchColumn();
     }

     function eliminarOrden($conexion, $OrdenID) {
          $sql = "DELETE FROM DetalleOrdenes
                  WHERE OrdenID = :OrdenID";
          $stmt = $conexion->prepare($sql);
          $stmt->execute([":OrdenID" => $OrdenID]);
          $sql = "DELETE FROM Ordenes
                  WHERE OrdenID = :OrdenID";
          $stmt = $conexion->prepare($sql);
          $stmt->execute([":OrdenID" => $OrdenID]);
          return $stmt->rowCount() > 0;
     }
?>