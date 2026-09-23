<?php
     function obtenerTodosDevoluciones($conexion, $UsuarioID = null) {
          $sql = "SELECT D.*, O.UsuarioID
                  FROM Devoluciones D
                  INNER JOIN Ordenes O 
                    ON O.OrdenID = D.OrdenID";
          if ($UsuarioID !== null) {
               $sql .= " WHERE O.UsuarioID = :UsuarioID";
          }
          $stmt = $conexion->prepare($sql." ORDER BY D.DevolucionID DESC");
          $stmt->execute($UsuarioID === null ? [] : [":UsuarioID" => $UsuarioID]);
          return $stmt->fetchAll();
     }

     function obtenerDevolucionPorId($conexion, $DevolucionID) {
          $sql = "SELECT D.*, O.UsuarioID 
                  FROM Devoluciones D
                  INNER JOIN Ordenes O
                    ON O.OrdenID = D.OrdenID
                  WHERE D.DevolucionID = :DevolucionID";
          $stmt = $conexion->prepare($sql);
          $stmt->execute([":DevolucionID" => $DevolucionID]);
          return $stmt->fetch();
     }

     function crearDevolucion($conexion, $datos) {
          $sql = "INSERT INTO Devoluciones (OrdenID, Motivo, Estado, MontoReembolso, Notas)
                  VALUES (:OrdenID, :Motivo, :Estado, :MontoReembolso, :Notas)";
          $stmt = $conexion->prepare($sql);
          $stmt->execute([":OrdenID" => $datos["OrdenID"],
                          ":Motivo" => $datos["Motivo"],
                          ":Estado" => $datos["Estado"],
                          ":MontoReembolso" => $datos["MontoReembolso"],
                          ":Notas" => $datos["Notas"]]);
          return $conexion->lastInsertId();
     }

     function actualizarDevolucion($conexion, $DevolucionID, $datos) {
          $stmt = $conexion->prepare("UPDATE Devoluciones SET Motivo = :Motivo, Estado = :Estado, MontoReembolso = :MontoReembolso, Notas = :Notas WHERE DevolucionID = :DevolucionID");
          $stmt->execute([
               ":Motivo" => $datos["Motivo"],
               ":Estado" => $datos["Estado"],
               ":MontoReembolso" => $datos["MontoReembolso"],
               ":Notas" => $datos["Notas"],
               ":DevolucionID" => $DevolucionID
          ]);
          return true;
     }

     function eliminarDevolucion($conexion, $DevolucionID) {
          $sql = "DELETE FROM DetalleDevoluciones
                  WHERE DevolucionID = :DevolucionID";
          $stmt = $conexion->prepare($sql);
          $stmt->execute([":DevolucionID" => $DevolucionID]);
          $sql = "DELETE FROM Devoluciones
                  WHERE DevolucionID = :DevolucionID";
          $stmt = $conexion->prepare($sql);
          $stmt->execute([":DevolucionID" => $DevolucionID]);
          return $stmt->rowCount() > 0;
     }

     function obtenerDetallesDevolucion($conexion, $DevolucionID) {
          $sql = "SELECT * 
                  FROM DetalleDevoluciones
                  WHERE DevolucionID = :DevolucionID
                  ORDER BY DetalleDevolucionID";
          $stmt = $conexion->prepare($sql);
          $stmt->execute([":DevolucionID" => $DevolucionID]);
          return $stmt->fetchAll();
     }

     function cantidadDevueltaDetalle($conexion, $DetalleOrdenID) {
          $sql = "SELECT COALESCE(SUM(DD.Cantidad), 0)
                  FROM DetalleDevoluciones DD
                  INNER JOIN Devoluciones D
                  ON D.DevolucionID = DD.DevolucionID
                  WHERE DD.DetalleOrdenID = :DetalleOrdenID AND D.Estado <> 'Rechazada'";
          $stmt = $conexion->prepare($sql);
          $stmt->execute([":DetalleOrdenID" => $DetalleOrdenID]);
          return (int) $stmt->fetchColumn();
     }

     function crearDetalleDevolucion($conexion, $DevolucionID, $detalle) {
          $sql = "INSERT INTO DetalleDevoluciones (DevolucionID, DetalleOrdenID, Cantidad, Motivo, MontoReembolso)
                  VALUES (:DevolucionID, :DetalleOrdenID, :Cantidad, :Motivo, :MontoReembolso)";
          $stmt = $conexion->prepare($sql);
          $stmt->execute([":DevolucionID" => $DevolucionID,
                          ":DetalleOrdenID" => $detalle["DetalleOrdenID"],
                          ":Cantidad" => $detalle["Cantidad"],
                          ":Motivo" => $detalle["Motivo"],
                          ":MontoReembolso" => $detalle["MontoReembolso"]]);
     }
?>