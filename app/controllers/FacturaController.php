<?php
     function listarFacturas($conexion, $UsuarioID = null) {
          return obtenerTodosFacturas($conexion, $UsuarioID);
     }
     function buscarFactura($conexion, $FacturaID) {
          $factura = obtenerFacturaPorId($conexion, $FacturaID);
          if ($factura) $factura["Detalles"] = obtenerDetallesFactura($conexion, $FacturaID);
          return $factura;
     }
     function agregarFactura($conexion, $datos) {
          $datos = array_merge(["NIT" => "CF", "Notas" => null], $datos);
          if (!validarEntero($datos["OrdenID"] ?? null) || !validarTexto($datos["NumeroFactura"] ?? null, 50) ||
          !validarTexto($datos["Nombre"] ?? null, 150) || !validarTexto($datos["NIT"], 20) ||
          !validarTexto($datos["Direccion"] ?? null, 255) || !validarTexto($datos["Notas"], 255, true)) {
               throw new InvalidArgumentException("Datos de factura inválidos");
          }
          $conexion->beginTransaction();
          try {
               $orden = bloquearOrden($conexion, $datos["OrdenID"]);
               if (!$orden || $orden["Estado"] === "Cancelada") throw new DomainException("Orden no disponible para facturar");
               if (contarFacturasEmitidasOrden($conexion, $datos["OrdenID"]) > 0) throw new DomainException("La orden ya tiene una factura emitida");
               $detalles = obtenerDetallesOrden($conexion, $datos["OrdenID"]);
               if (!$detalles) throw new DomainException("La orden no tiene detalles");
               // Esta versión factura órdenes sin cargos adicionales.
               if (bccomp($orden["ImpuestoTotal"], "0", 2) !== 0 || bccomp($orden["CostoEnvio"], "0", 2) !== 0 ||
               bccomp($orden["DescuentoTotal"], "0", 2) !== 0) {
                    throw new DomainException("La orden requiere un desglose de cargos que todavía no está configurado");
               }
               foreach ($detalles as $detalle) {
                    if (bccomp($detalle["Descuento"], "0", 2) !== 0) throw new DomainException("La orden requiere un desglose de descuentos");
               }
               $datos["Subtotal"] = $orden["Subtotal"];
               $datos["ImpuestoTotal"] = $orden["ImpuestoTotal"];
               $datos["DescuentoTotal"] = $orden["DescuentoTotal"];
               $datos["Total"] = $orden["Total"];
               $datos["Estado"] = "Emitida";
               $id = crearFactura($conexion, $datos);
               foreach ($detalles as $detalle) crearDetalleFactura($conexion, $id, $detalle);
               $conexion->commit();
               return $id;
          } catch (Throwable $e) {
               $conexion->rollBack();
               throw $e;
          }
     }
     function editarFactura($conexion, $FacturaID, $datos) {
          if ($datos !== ["Estado" => "Anulada"]) throw new InvalidArgumentException("Solo se permite anular la factura");
          $actual = obtenerFacturaPorId($conexion, $FacturaID);
          if (!$actual) return false;
          $conexion->beginTransaction();
          try {
               bloquearOrden($conexion, $actual["OrdenID"]);
               $actual = obtenerFacturaPorId($conexion, $FacturaID);
               if (!$actual || $actual["Estado"] !== "Emitida") throw new DomainException("La factura no está emitida");
               $actual["Estado"] = "Anulada";
               actualizarFactura($conexion, $FacturaID, $actual);
               $conexion->commit();
               return true;
          } catch (Throwable $e) {
               $conexion->rollBack();
               throw $e;
          }
     }
     function quitarFactura($conexion, $FacturaID) {
          $actual = obtenerFacturaPorId($conexion, $FacturaID);
          if (!$actual) return false;
          $conexion->beginTransaction();
          try {
               bloquearOrden($conexion, $actual["OrdenID"]);
               $actual = obtenerFacturaPorId($conexion, $FacturaID);
               if (!$actual || $actual["Estado"] !== "Anulada") throw new DomainException("Solo se pueden eliminar facturas anuladas");
               $resultado = eliminarFactura($conexion, $FacturaID);
               $conexion->commit();
               return $resultado;
          } catch (Throwable $e) {
               $conexion->rollBack();
               throw $e;
          }
     }
?>