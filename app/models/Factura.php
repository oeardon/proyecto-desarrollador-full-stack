<?php
     function obtenerTodosFacturas($conexion, $UsuarioID = null) {
          $sql = "SELECT F.*, O.UsuarioID
                  FROM Facturas F 
                  INNER JOIN Ordenes O 
                    ON O.OrdenID = F.OrdenID";
          if ($UsuarioID !== null) {
               $sql .= " WHERE O.UsuarioID = :UsuarioID";
          }
          $stmt = $conexion->prepare($sql." ORDER BY F.FacturaID ASC");
          $stmt->execute($UsuarioID === null ? [] : [":UsuarioID" => $UsuarioID]);
          return $stmt->fetchAll();
     }

     function obtenerFacturaPorId($conexion, $FacturaID) {
          $sql = "SELECT F.*, O.UsuarioID
                  FROM Facturas F
                  INNER JOIN Ordenes O
                    ON O.OrdenID = F.OrdenID
                  WHERE F.FacturaID = :FacturaID";
          $stmt = $conexion->prepare($sql);
          $stmt->execute([":FacturaID" => $FacturaID]);
          return $stmt->fetch();
     }

     function crearFactura($conexion, $datos) {
          $sql = "INSERT INTO Facturas (NumeroFactura, OrdenID, Nombre, NIT, Direccion, Subtotal, ImpuestoTotal, DescuentoTotal, Total, Notas, Estado)
                  VALUES (:NumeroFactura, :OrdenID, :Nombre, :NIT, :Direccion, :Subtotal, :ImpuestoTotal, :DescuentoTotal, :Total, :Notas, :Estado)";
          $stmt = $conexion->prepare($sql);
          $stmt->execute([":NumeroFactura" => $datos["NumeroFactura"],
                          ":OrdenID" => $datos["OrdenID"],
                          ":Nombre" => $datos["Nombre"],
                          ":NIT" => $datos["NIT"],
                          ":Direccion" => $datos["Direccion"],
                          ":Subtotal" => $datos["Subtotal"],
                          ":ImpuestoTotal" => $datos["ImpuestoTotal"],
                          ":DescuentoTotal" => $datos["DescuentoTotal"],
                          ":Total" => $datos["Total"],
                          ":Notas" => $datos["Notas"],
                          ":Estado" => $datos["Estado"]]);
          return $conexion->lastInsertId();
     }

     function actualizarFactura($conexion, $FacturaID, $datos) {
          $sql = "UPDATE Facturas
                  SET NumeroFactura = :NumeroFactura,
                      Nombre = :Nombre,
                      NIT = :NIT,
                      Direccion = :Direccion,
                      Subtotal = :Subtotal,
                      ImpuestoTotal = :ImpuestoTotal,
                      DescuentoTotal = :DescuentoTotal,
                      Total = :Total,
                      Notas = :Notas,
                      Estado = :Estado
                  WHERE FacturaID = :FacturaID";
          $stmt = $conexion->prepare($sql);
          $stmt->execute([":NumeroFactura" => $datos["NumeroFactura"],
                          ":Nombre" => $datos["Nombre"],
                          ":NIT" => $datos["NIT"],
                          ":Direccion" => $datos["Direccion"],
                          ":Subtotal" => $datos["Subtotal"],
                          ":ImpuestoTotal" => $datos["ImpuestoTotal"],
                          ":DescuentoTotal" => $datos["DescuentoTotal"],
                          ":Total" => $datos["Total"],
                          ":Notas" => $datos["Notas"],
                          ":Estado" => $datos["Estado"],
                          ":FacturaID" => $FacturaID]);
          return true;
     }

     function eliminarFactura($conexion, $FacturaID) {
          $sql = "DELETE FROM DetalleFacturas
                  WHERE FacturaID = :FacturaID";
          $stmt = $conexion->prepare($sql);
          $stmt->execute([":FacturaID" => $FacturaID]);
          $sql = "DELETE FROM Facturas
                  WHERE FacturaID = :FacturaID";
          $stmt = $conexion->prepare($sql);
          $stmt->execute([":FacturaID" => $FacturaID]);
          return $stmt->rowCount() > 0;
     }

     function obtenerDetallesFactura($conexion, $FacturaID) {
          $sql = "SELECT *
                  FROM DetalleFacturas
                  WHERE FacturaID = :FacturaID
                  ORDER BY DetalleFacturaID";
          $stmt = $conexion->prepare($sql);
          $stmt->execute([":FacturaID" => $FacturaID]);
          return $stmt->fetchAll();
     }

     function contarFacturasEmitidasOrden($conexion, $OrdenID) {
          $sql = "SELECT COUNT(*)
                  FROM Facturas
                  WHERE OrdenID = :OrdenID AND Estado = 'Emitida'";
          $stmt = $conexion->prepare($sql);
          $stmt->execute([":OrdenID" => $OrdenID]);
          return (int) $stmt->fetchColumn();
     }

     function crearDetalleFactura($conexion, $FacturaID, $detalle) {
          $sql = "INSERT INTO DetalleFacturas (FacturaID, DetalleOrdenID, Descripcion, Cantidad, PrecioUnitario, Descuento, Impuesto, Subtotal)
                  VALUES (:FacturaID, :DetalleOrdenID, :Descripcion, :Cantidad, :PrecioUnitario, :Descuento, 0, :Subtotal)";
          $stmt = $conexion->prepare($sql);
          $stmt->execute([":FacturaID" => $FacturaID,
                          ":DetalleOrdenID" => $detalle["DetalleOrdenID"],
                          ":Descripcion" => $detalle["Producto"],
                          ":Cantidad" => $detalle["Cantidad"],
                          ":PrecioUnitario" => $detalle["PrecioUnitario"],
                          ":Descuento" => $detalle["Descuento"],
                          ":Subtotal" => $detalle["Subtotal"]]);
     }
?>