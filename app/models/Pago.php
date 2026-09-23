<?php
     function obtenerTodosPagos($conexion, $UsuarioID = null) {
          $sql = "SELECT PG.*, O.UsuarioID
                  FROM Pagos PG
                  INNER JOIN Ordenes O
                    ON O.OrdenID = PG.OrdenID";
          if ($UsuarioID !== null) {
               $sql .= " WHERE O.UsuarioID = :UsuarioID";
          }
          $stmt = $conexion->prepare($sql." ORDER BY PG.PagoID ASC");
          $stmt->execute($UsuarioID === null ? [] : [":UsuarioID" => $UsuarioID]);
          return $stmt->fetchAll();
     }

     function obtenerPagoPorId($conexion, $PagoID) {
          $sql = "SELECT PG.*, O.UsuarioID 
                  FROM Pagos PG
                  INNER JOIN Ordenes O
                    ON O.OrdenID = PG.OrdenID 
                  WHERE PG.PagoID = :PagoID";
          $stmt = $conexion->prepare($sql);
          $stmt->execute([":PagoID" => $PagoID]);
          return $stmt->fetch();
     }

     function crearPago($conexion, $datos) {
          $sql = "INSERT INTO Pagos (OrdenID, Monto, MetodoPago, ReferenciaPago, Notas, Estado)
                  VALUES (:OrdenID, :Monto, :MetodoPago, :ReferenciaPago, :Notas, :Estado)";
          $stmt = $conexion->prepare($sql);
          $stmt->execute([":OrdenID" => $datos["OrdenID"],
                          ":Monto" => $datos["Monto"],
                          ":MetodoPago" => $datos["MetodoPago"],
                          ":ReferenciaPago" => $datos["ReferenciaPago"],
                          ":Notas" => $datos["Notas"],
                          ":Estado" => $datos["Estado"]]);
          return $conexion->lastInsertId();
     }

     function actualizarPago($conexion, $PagoID, $datos) {
          $sql = "UPDATE Pagos
                  SET Monto = :Monto,
                      MetodoPago = :MetodoPago,
                      ReferenciaPago = :ReferenciaPago,
                      Notas = :Notas,
                      Estado = :Estado
                  WHERE PagoID = :PagoID";
          $stmt = $conexion->prepare($sql);
          $stmt->execute([":Monto" => $datos["Monto"],
                          ":MetodoPago" => $datos["MetodoPago"],
                          ":ReferenciaPago" => $datos["ReferenciaPago"],
                          ":Notas" => $datos["Notas"],
                          ":Estado" => $datos["Estado"],
                          ":PagoID" => $PagoID]);
          return true;
     }
     function eliminarPago($conexion, $PagoID) {
          $sql = "DELETE FROM Pagos
                  WHERE PagoID = :PagoID";
          $stmt = $conexion->prepare($sql);
          $stmt->execute([":PagoID" => $PagoID]);
          return $stmt->rowCount() > 0;
     }

     function totalPagadoOrden($conexion, $OrdenID, $PagoID = 0) {
          $sql = "SELECT COALESCE(SUM(Monto), 0)
                  FROM Pagos
                  WHERE OrdenID = :OrdenID AND Estado = 'Completado' AND PagoID <> :PagoID";
          $stmt = $conexion->prepare($sql);
          $stmt->execute([":OrdenID" => $OrdenID, ":PagoID" => $PagoID]);
          return $stmt->fetchColumn();
     }
?>