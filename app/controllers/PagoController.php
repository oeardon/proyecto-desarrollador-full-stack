<?php
     function listarPagos($conexion, $UsuarioID = null) {
          return obtenerTodosPagos($conexion, $UsuarioID);
     }
     function buscarPago($conexion, $PagoID) {
          return obtenerPagoPorId($conexion, $PagoID);
     }
     function prepararDatosPago($datos, $actual = []) {
          $datos = array_merge(["OrdenID" => null, "Monto" => null, "MetodoPago" => null, "ReferenciaPago" => null, "Notas" => null, "Estado" => "Pendiente"], $actual, $datos);
          if (!validarEntero($datos["OrdenID"]) || !validarMonto($datos["Monto"]) || $datos["Monto"] <= 0 ||
          !validarTexto($datos["MetodoPago"], 30) || !validarTexto($datos["ReferenciaPago"], 100, true) ||
          !validarTexto($datos["Notas"], 255, true) ||
          !validarOpcion($datos["Estado"], ["Pendiente", "Completado", "Rechazado", "Reembolsado"])) {
               throw new InvalidArgumentException("Datos de pago inválidos");
          }
          return $datos;
     }
     function agregarPago($conexion, $datos) {
          $datos = prepararDatosPago($datos);
          if (!in_array($datos["Estado"], ["Pendiente", "Completado"], true)) throw new InvalidArgumentException("El pago debe iniciar pendiente o completado");
          $conexion->beginTransaction();
          try {
               $orden = bloquearOrden($conexion, $datos["OrdenID"]);
               if (!$orden || $orden["Estado"] === "Cancelada") throw new DomainException("Orden no disponible para pagos");
               if (bccomp(bcadd((string) totalPagadoOrden($conexion, $datos["OrdenID"]), (string) $datos["Monto"], 2), $orden["Total"], 2) > 0) {
                    throw new DomainException("El monto supera el saldo de la orden");
               }
               $id = crearPago($conexion, $datos);
               $conexion->commit();
               return $id;
          } catch (Throwable $e) {
               $conexion->rollBack();
               throw $e;
          }
     }
     function editarPago($conexion, $PagoID, $datos) {
          if (array_keys($datos) !== ["Estado"]) throw new InvalidArgumentException("Solo se permite actualizar el Estado del pago");
          $actual = obtenerPagoPorId($conexion, $PagoID);
          if (!$actual) return false;
          $conexion->beginTransaction();
          try {
               $orden = bloquearOrden($conexion, $actual["OrdenID"]);
               $actual = obtenerPagoPorId($conexion, $PagoID);
               if (!$actual) throw new DomainException("El pago ya no existe");
               $datos = prepararDatosPago($datos, $actual);
               $transiciones = ["Pendiente" => ["Completado", "Rechazado"], "Completado" => ["Reembolsado"], "Rechazado" => [], "Reembolsado" => []];
               if (!in_array($datos["Estado"], $transiciones[$actual["Estado"]], true)) throw new DomainException("Cambio de estado de pago no permitido");
               if ($datos["Estado"] === "Completado") {
                    if ($orden["Estado"] === "Cancelada" ||
                    bccomp(bcadd((string) totalPagadoOrden($conexion, $actual["OrdenID"], $PagoID), (string) $actual["Monto"], 2), $orden["Total"], 2) > 0) {
                         throw new DomainException("La orden está cancelada o el pago supera su saldo");
                    }
               }
               actualizarPago($conexion, $PagoID, $datos);
               $conexion->commit();
               return true;
          } catch (Throwable $e) {
               $conexion->rollBack();
               throw $e;
          }
     }
     function quitarPago($conexion, $PagoID) {
          $actual = obtenerPagoPorId($conexion, $PagoID);
          if (!$actual) return false;
          $conexion->beginTransaction();
          try {
               bloquearOrden($conexion, $actual["OrdenID"]);
               $actual = obtenerPagoPorId($conexion, $PagoID);
               if (!$actual || !in_array($actual["Estado"], ["Pendiente", "Rechazado"], true)) throw new DomainException("No se pueden eliminar pagos completados o reembolsados");
               $resultado = eliminarPago($conexion, $PagoID);
               $conexion->commit();
               return $resultado;
          } catch (Throwable $e) {
               $conexion->rollBack();
               throw $e;
          }
     }
?>