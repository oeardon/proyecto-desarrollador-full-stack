<?php
     function validarDatosProducto($datos) {
          if (!is_array($datos)) return false;
          return validarEntero($datos["CategoriaID"] ?? null) &&
                 validarTexto($datos["Nombre"] ?? null, 150) &&
                 validarTexto($datos["SKU"] ?? null, 50, true) &&
                 validarTexto($datos["Descripcion"] ?? null, 255, true) &&
                 validarTexto($datos["Imagen"] ?? null, 255, true) &&
                 validarMonto($datos["Precio"] ?? null) &&
                 validarEntero($datos["Cantidad"] ?? null, 0) &&
                 validarOpcion($datos["Estado"] ?? null, ["Activo", "Inactivo"]);
     }

     function prepararDatosProducto($datos) {
          if (is_string($datos["Nombre"] ?? null)) $datos["Nombre"] = trim($datos["Nombre"]);
          if (is_string($datos["SKU"] ?? null)) {
               $datos["SKU"] = trim($datos["SKU"]);
               if ($datos["SKU"] === "") $datos["SKU"] = null;
          }
          if (!validarDatosProducto($datos)) {
               throw new InvalidArgumentException("Datos de producto inválidos: revise campos, longitudes, precio y cantidad");
          }
          return $datos;
     }

     function listarProductos($conexion) {
          return obtenerTodosProductos($conexion);
     }

     function buscarProducto($conexion, $ProductoID) {
          if (!validarEntero($ProductoID)) return false;
          return obtenerProductoPorId($conexion, $ProductoID);
     }

     function agregarProducto($conexion, $datos) {
          if (!is_array($datos)) throw new InvalidArgumentException("Datos de producto inválidos");
          $datos = array_merge(["SKU" => null,"Descripcion" => null,"Cantidad" => 0,"Imagen" => null], $datos);
          $datos["Estado"] = "Activo";
          $datos = prepararDatosProducto($datos);
          return crearProducto($conexion, $datos);
     }

     function editarProducto($conexion, $ProductoID, $datos) {
          if (!validarEntero($ProductoID) || !is_array($datos)) {
               throw new InvalidArgumentException("ID o datos de producto inválidos");
          }
          $campos = ["CategoriaID", "SKU", "Nombre", "Descripcion", "Precio", "Cantidad", "Imagen", "Estado"];
          foreach ($campos as $campo) {
               if (!array_key_exists($campo, $datos)) {
                    throw new InvalidArgumentException("Debe enviar todos los campos editables del producto; falta " . $campo);
               }
          }
          $datos = prepararDatosProducto($datos);
          if (!obtenerProductoPorId($conexion, $ProductoID)) return false;
          return actualizarProducto($conexion, $ProductoID, $datos);
     }

     function quitarProducto($conexion, $ProductoID) {
          if (!validarEntero($ProductoID)) return false;
          return eliminarProducto($conexion, $ProductoID);
     }
?>