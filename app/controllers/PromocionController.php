<?php
     function prepararDatosPromocion($datos, $actual = []) {
          $datos = array_merge(["Nombre" => null,
                              "Descripcion" => null,
                              "TipoDescuento" => null,
                              "ValorDescuento" => null,
                              "FechaInicio" => null,
                              "FechaFin" => null,
                              "RequiereCupon" => 0,
                              "CodigoCupon" => null,
                              "AplicaTodosProductos" => 0,
                              "Estado" => "Activo"], $actual, $datos);
          if (is_string($datos["Nombre"])) $datos["Nombre"] = trim($datos["Nombre"]);
          if (is_string($datos["CodigoCupon"])) $datos["CodigoCupon"] = trim($datos["CodigoCupon"]);
          if ($datos["Descripcion"] === "") $datos["Descripcion"] = null;
          if ($datos["FechaFin"] === "") $datos["FechaFin"] = null;
          if ($datos["CodigoCupon"] === "") $datos["CodigoCupon"] = null;
          if (!(validarTexto($datos["Nombre"], 255) &&
               validarTexto($datos["Descripcion"], 255, true) &&
               validarOpcion($datos["TipoDescuento"], ["Porcentaje", "Monto"]) &&
               validarMonto($datos["ValorDescuento"]) &&
               ($datos["TipoDescuento"] !== "Porcentaje" || $datos["ValorDescuento"] <= 100) &&
               validarFecha($datos["FechaInicio"]) &&
               ($datos["FechaFin"] === null || (validarFecha($datos["FechaFin"]) && $datos["FechaFin"] >= $datos["FechaInicio"])) &&
               in_array($datos["RequiereCupon"], [0, 1, false, true], true) &&
               in_array($datos["AplicaTodosProductos"], [0, 1, false, true], true) &&
               validarTexto($datos["CodigoCupon"], 40, true) &&
               (!$datos["RequiereCupon"] || validarTexto($datos["CodigoCupon"], 40)) &&
               validarOpcion($datos["Estado"], ["Activo", "Inactivo"]))) {
               throw new InvalidArgumentException("Datos de promocion inválidos");
          }
          $datos["RequiereCupon"] = (int) $datos["RequiereCupon"];
          $datos["AplicaTodosProductos"] = (int) $datos["AplicaTodosProductos"];
          return $datos;
     }

     function listarPromociones($conexion) {
          return obtenerTodosPromociones($conexion);
     }

     function buscarPromocion($conexion, $PromocionID) {
          return obtenerPromocionPorId($conexion, $PromocionID);
     }

     function agregarPromocion($conexion, $datos) {
          $datos = prepararDatosPromocion($datos);
          return crearPromocion($conexion, $datos);
     }

     function editarPromocion($conexion, $PromocionID, $datos) {
          $actual = obtenerPromocionPorId($conexion, $PromocionID);
          if (!$actual) return false;
          $datos = prepararDatosPromocion($datos, $actual);
          return actualizarPromocion($conexion, $PromocionID, $datos);
     }

     function quitarPromocion($conexion, $PromocionID) {
          return eliminarPromocion($conexion, $PromocionID);
     }
?>