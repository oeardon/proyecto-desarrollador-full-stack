<?php
     function prepararDatosProveedor($datos, $actual = []) {
          $datos = array_merge(["Nombre" => null,
                              "NIT" => null,
                              "Contacto" => null,
                              "Correo" => null,
                              "Telefono" => null,
                              "Direccion" => null,
                              "Estado" => "Activo"], $actual, $datos);
          if (is_string($datos["Nombre"])) $datos["Nombre"] = trim($datos["Nombre"]);
          if (is_string($datos["Correo"])) $datos["Correo"] = trim($datos["Correo"]);
          if ($datos["NIT"] === "") $datos["NIT"] = null;
          if ($datos["Contacto"] === "") $datos["Contacto"] = null;
          if ($datos["Correo"] === "") $datos["Correo"] = null;
          if ($datos["Telefono"] === "") $datos["Telefono"] = null;
          if ($datos["Direccion"] === "") $datos["Direccion"] = null;
          if (!(validarTexto($datos["Nombre"], 150) &&
               validarTexto($datos["NIT"], 20, true) &&
               validarTexto($datos["Contacto"], 100, true) &&
               validarTexto($datos["Correo"], 100, true) &&
               ($datos["Correo"] === null || filter_var($datos["Correo"], FILTER_VALIDATE_EMAIL)) &&
               validarTexto($datos["Telefono"], 20, true) &&
               validarTexto($datos["Direccion"], 255, true) &&
               validarOpcion($datos["Estado"], ["Activo", "Inactivo"]))) {
               throw new InvalidArgumentException("Datos de proveedor inválidos");
          }
          return $datos;
     }

     function listarProveedores($conexion) {
          return obtenerTodosProveedores($conexion);
     }

     function buscarProveedor($conexion, $ProveedorID) {
          return obtenerProveedorPorId($conexion, $ProveedorID);
     }

     function agregarProveedor($conexion, $datos) {
          $datos = prepararDatosProveedor($datos);
          return crearProveedor($conexion, $datos);
     }

     function editarProveedor($conexion, $ProveedorID, $datos) {
          $actual = obtenerProveedorPorId($conexion, $ProveedorID);
          if (!$actual) return false;
          $datos = prepararDatosProveedor($datos, $actual);
          return actualizarProveedor($conexion, $ProveedorID, $datos);
     }

     function quitarProveedor($conexion, $ProveedorID) {
          return eliminarProveedor($conexion, $ProveedorID);
     }
?>