<?php
     function listarOrdenes($conexion, $UsuarioID = null) {
          return obtenerTodosOrdenes($conexion, $UsuarioID);
     }
     function buscarOrden($conexion, $OrdenID) {
          $orden = obtenerOrdenPorId($conexion, $OrdenID);
          if ($orden) $orden["Detalles"] = obtenerDetallesOrden($conexion, $OrdenID);
          return $orden;
     }
     function agregarOrden($conexion, $datos) {
          if (!validarEntero($datos["UsuarioID"] ?? null) ||
          !validarTexto($datos["DireccionPago"] ?? null, 255) ||
          !validarTexto($datos["DireccionEnvio"] ?? null, 255) ||
          !isset($datos["Detalles"]) || !is_array($datos["Detalles"]) ||
          !array_is_list($datos["Detalles"]) || count($datos["Detalles"]) < 1 || count($datos["Detalles"]) > 100) {
               throw new InvalidArgumentException("Usuario, direcciones y entre 1 y 100 detalles son obligatorios");
          }
          $detalles = [];
          foreach ($datos["Detalles"] as $detalle) {
               if (!is_array($detalle) || !validarEntero($detalle["ProductoID"] ?? null) ||
               !validarEntero($detalle["Cantidad"] ?? null)) {
                    throw new InvalidArgumentException("Cada detalle requiere ProductoID y Cantidad positivos");
               }
               $id = (int) $detalle["ProductoID"];
               if (isset($detalles[$id])) throw new InvalidArgumentException("No repita productos en los detalles");
               $detalles[$id] = $detalle;
          }
          ksort($detalles);
          $conexion->beginTransaction();
          try {
               $total = "0.00";
               foreach ($detalles as $id => &$detalle) {
                    $producto = bloquearProductoOrden($conexion, $id);
                    if (!$producto || $producto["Estado"] !== "Activo") throw new DomainException("Producto no disponible");
                    if ($producto["Cantidad"] < $detalle["Cantidad"]) throw new DomainException("Existencias insuficientes");
                    $detalle["PrecioUnitario"] = $producto["Precio"];
                    $detalle["Subtotal"] = bcmul($producto["Precio"], (string) $detalle["Cantidad"], 2);
                    $total = bcadd($total, $detalle["Subtotal"], 2);
                    if (bccomp($total, "99999999.99", 2) > 0) throw new InvalidArgumentException("El total supera el máximo permitido");
               }
               unset($detalle);
               $datos["Subtotal"] = $total;
               $datos["Total"] = $total;
               $id = crearOrden($conexion, $datos);
               foreach ($detalles as $detalle) {
                    crearDetalleOrden($conexion, $id, $detalle);
                    cambiarExistenciasOrden($conexion, $detalle["ProductoID"], -(int) $detalle["Cantidad"]);
               }
               $conexion->commit();
               return $id;
          } catch (Throwable $e) {
               $conexion->rollBack();
               throw $e;
          }
     }
     function editarOrden($conexion, $OrdenID, $datos) {
          if (array_keys($datos) !== ["Estado"] || !validarOpcion($datos["Estado"], ["Confirmada", "Procesando", "Enviada", "Entregada", "Cancelada"])) {
               throw new InvalidArgumentException("Solo se permite actualizar el Estado de la orden");
          }
          $conexion->beginTransaction();
          try {
               $actual = bloquearOrden($conexion, $OrdenID);
               if (!$actual) throw new DomainException("La orden ya no existe");
               $transiciones = [
                    "Pendiente" => ["Confirmada", "Cancelada"],
                    "Confirmada" => ["Procesando", "Cancelada"],
                    "Procesando" => ["Enviada"],
                    "Enviada" => ["Entregada"],
                    "Entregada" => [], "Cancelada" => []
               ];
               if (!in_array($datos["Estado"], $transiciones[$actual["Estado"]], true)) throw new DomainException("Cambio de estado no permitido");
               if ($datos["Estado"] === "Cancelada") {
                    if (contarPagosOrden($conexion, $OrdenID) > 0) throw new DomainException("La orden tiene pagos; debe gestionar su devolución");
                    $detalles = obtenerDetallesOrden($conexion, $OrdenID);
                    usort($detalles, function ($a, $b) { return $a["ProductoID"] <=> $b["ProductoID"]; });
                    foreach ($detalles as $detalle) cambiarExistenciasOrden($conexion, $detalle["ProductoID"], (int) $detalle["Cantidad"]);
               }
               actualizarEstadoOrden($conexion, $OrdenID, $datos["Estado"]);
               $conexion->commit();
               return true;
          } catch (Throwable $e) {
               $conexion->rollBack();
               throw $e;
          }
     }
     function quitarOrden($conexion, $OrdenID) {
          $conexion->beginTransaction();
          try {
               $actual = bloquearOrden($conexion, $OrdenID);
               if (!$actual || $actual["Estado"] !== "Cancelada") throw new DomainException("Solo se pueden eliminar órdenes canceladas");
               $resultado = eliminarOrden($conexion, $OrdenID);
               $conexion->commit();
               return $resultado;
          } catch (Throwable $e) {
               $conexion->rollBack();
               throw $e;
          }
     }
?>