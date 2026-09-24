<?php
     function obtenerTodosPromociones($conexion) {
          $sql = "SELECT *
                  FROM Promociones
                  ORDER BY PromocionID ASC";
          $stmt = $conexion->prepare($sql);
          $stmt->execute([]);
          return $stmt->fetchAll();
     }

     function obtenerPromocionPorId($conexion, $PromocionID) {
          $sql = "SELECT *
                  FROM Promociones
                  WHERE PromocionID = :PromocionID";
          $stmt = $conexion->prepare($sql);
          $stmt->execute([":PromocionID" => $PromocionID]);
          return $stmt->fetch();
     }

     function crearPromocion($conexion, $datos) {
          $sql = "INSERT INTO Promociones (Nombre, Descripcion, TipoDescuento, ValorDescuento, FechaInicio, FechaFin, RequiereCupon, CodigoCupon, AplicaTodosProductos, Estado)
                  VALUES (:Nombre, :Descripcion, :TipoDescuento, :ValorDescuento, :FechaInicio, :FechaFin, :RequiereCupon, :CodigoCupon, :AplicaTodosProductos, :Estado)";
          $stmt = $conexion->prepare($sql);
          $stmt->execute([":Nombre" => $datos["Nombre"],
                          ":Descripcion" => $datos["Descripcion"],
                          ":TipoDescuento" => $datos["TipoDescuento"],
                          ":ValorDescuento" => $datos["ValorDescuento"],
                          ":FechaInicio" => $datos["FechaInicio"],
                          ":FechaFin" => $datos["FechaFin"],
                          ":RequiereCupon" => $datos["RequiereCupon"],
                          ":CodigoCupon" => $datos["CodigoCupon"],
                          ":AplicaTodosProductos" => $datos["AplicaTodosProductos"],
                          ":Estado" => $datos["Estado"]]);
          return $conexion->lastInsertId();
     }

     function actualizarPromocion($conexion, $PromocionID, $datos) {
          $sql = "UPDATE Promociones
                  SET Nombre = :Nombre,
                      Descripcion = :Descripcion,
                      TipoDescuento = :TipoDescuento,
                      ValorDescuento = :ValorDescuento,
                      FechaInicio = :FechaInicio,
                      FechaFin = :FechaFin,
                      RequiereCupon = :RequiereCupon,
                      CodigoCupon = :CodigoCupon,
                      AplicaTodosProductos = :AplicaTodosProductos,
                      Estado = :Estado
                  WHERE PromocionID = :PromocionID";
          $stmt = $conexion->prepare($sql);
          $parametros = [":Nombre" => $datos["Nombre"],
                         ":Descripcion" => $datos["Descripcion"],
                         ":TipoDescuento" => $datos["TipoDescuento"],
                         ":ValorDescuento" => $datos["ValorDescuento"],
                         ":FechaInicio" => $datos["FechaInicio"],
                         ":FechaFin" => $datos["FechaFin"],
                         ":RequiereCupon" => $datos["RequiereCupon"],
                         ":CodigoCupon" => $datos["CodigoCupon"],
                         ":AplicaTodosProductos" => $datos["AplicaTodosProductos"],
                         ":Estado" => $datos["Estado"],
                         ":PromocionID" => $PromocionID];
          return $stmt->execute($parametros);
     }

     function eliminarPromocion($conexion, $PromocionID) {
          $sql = "DELETE FROM Promociones
                  WHERE PromocionID = :PromocionID";
          $stmt = $conexion->prepare($sql);
          $stmt->execute([":PromocionID" => $PromocionID]);
          return $stmt->rowCount() > 0;
     }
?>