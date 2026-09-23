<?php
     function listarDevoluciones($conexion, $UsuarioID = null) {
          return obtenerTodosDevoluciones($conexion, $UsuarioID);
     }
     function buscarDevolucion($conexion, $DevolucionID) {
          $registro = obtenerDevolucionPorId($conexion, $DevolucionID);
          if ($registro) $registro["Detalles"] = obtenerDetallesDevolucion($conexion, $DevolucionID);
          return $registro;
     }
     function agregarDevolucion($conexion, $datos) {
          if (!validarEntero($datos["OrdenID"] ?? null) || !validarTexto($datos["Motivo"] ?? null, 255) ||
          !isset($datos["Detalles"]) || !is_array($datos["Detalles"]) || !array_is_list($datos["Detalles"]) ||
          count($datos["Detalles"]) < 1 || count($datos["Detalles"]) > 100) {
               throw new InvalidArgumentException("Orden, motivo y detalles de devolución son obligatorios");
          }
          $conexion->beginTransaction();
          try {
               $orden = bloquearOrden($conexion, $datos["OrdenID"]);
               if (!$orden || $orden["Estado"] !== "Entregada") throw new DomainException("Solo se pueden devolver órdenes entregadas");
               $originales = [];
               foreach (obtenerDetallesOrden($conexion, $datos["OrdenID"]) as $fila) $originales[$fila["DetalleOrdenID"]] = $fila;
               $vistos = [];
               $detalles = [];
               $total = "0.00";
               foreach ($datos["Detalles"] as $detalle) {
                    if (!is_array($detalle) || !validarEntero($detalle["DetalleOrdenID"] ?? null) ||
                    !validarEntero($detalle["Cantidad"] ?? null) || !validarTexto($detalle["Motivo"] ?? null, 255, true)) {
                         throw new InvalidArgumentException("Detalle de devolución inválido");
                    }
                    $id = (int) $detalle["DetalleOrdenID"];
                    if (isset($vistos[$id]) || !isset($originales[$id])) throw new InvalidArgumentException("Detalle repetido o ajeno a la orden");
                    $vistos[$id] = true;
                    $original = $originales[$id];
                    if ($detalle["Cantidad"] + cantidadDevueltaDetalle($conexion, $id) > $original["Cantidad"]) throw new DomainException("La cantidad supera lo disponible para devolver");
                    $unitario = bcdiv($original["Subtotal"], (string) $original["Cantidad"], 4);
                    $detalle["MontoReembolso"] = bcmul($unitario, (string) $detalle["Cantidad"], 2);
                    $detalle["Motivo"] = $detalle["Motivo"] ?? null;
                    $total = bcadd($total, $detalle["MontoReembolso"], 2);
                    $detalles[] = $detalle;
               }
               $datos["Estado"] = "Solicitada";
               $datos["MontoReembolso"] = $total;
               $datos["Notas"] = null;
               $id = crearDevolucion($conexion, $datos);
               foreach ($detalles as $detalle) crearDetalleDevolucion($conexion, $id, $detalle);
               $conexion->commit();
               return $id;
          } catch (Throwable $e) {
               $conexion->rollBack();
               throw $e;
          }
     }
     function editarDevolucion($conexion, $DevolucionID, $datos) {
          if (array_diff(array_keys($datos), ["Estado", "Notas"]) ||
          !validarOpcion($datos["Estado"] ?? null, ["Aprobada", "Rechazada", "Procesada"]) ||
          !validarTexto($datos["Notas"] ?? null, 255, true)) throw new InvalidArgumentException("Estado o notas inválidos");
          $actual = obtenerDevolucionPorId($conexion, $DevolucionID);
          if (!$actual) return false;
          $conexion->beginTransaction();
          try {
               bloquearOrden($conexion, $actual["OrdenID"]);
               $actual = obtenerDevolucionPorId($conexion, $DevolucionID);
               if (!$actual) throw new DomainException("La devolución ya no existe");
               $transiciones = ["Solicitada" => ["Aprobada", "Rechazada"], "Aprobada" => ["Procesada", "Rechazada"], "Rechazada" => [], "Procesada" => []];
               if (!in_array($datos["Estado"], $transiciones[$actual["Estado"]], true)) throw new DomainException("Cambio de estado de devolución no permitido");
               $actual["Estado"] = $datos["Estado"];
               $actual["Notas"] = $datos["Notas"] ?? $actual["Notas"];
               actualizarDevolucion($conexion, $DevolucionID, $actual);
               $conexion->commit();
               return true;
          } catch (Throwable $e) {
               $conexion->rollBack();
               throw $e;
          }
     }
     function quitarDevolucion($conexion, $DevolucionID) {
          $actual = obtenerDevolucionPorId($conexion, $DevolucionID);
          if (!$actual) return false;
          $conexion->beginTransaction();
          try {
               bloquearOrden($conexion, $actual["OrdenID"]);
               $actual = obtenerDevolucionPorId($conexion, $DevolucionID);
               if (!$actual || $actual["Estado"] !== "Rechazada") throw new DomainException("Solo se pueden eliminar devoluciones rechazadas");
               $resultado = eliminarDevolucion($conexion, $DevolucionID);
               $conexion->commit();
               return $resultado;
          } catch (Throwable $e) {
               $conexion->rollBack();
               throw $e;
          }
     }
?>