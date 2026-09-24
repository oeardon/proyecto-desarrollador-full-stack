<?php
     function prepararDatosCategoria($datos, $actual = []) {
          if (!is_array($datos)) throw new InvalidArgumentException("Datos de categoría inválidos");
          $datos = array_merge([
               "Nombre" => null,
               "Descripcion" => null,
               "Estado" => "Activo",
               "CategoriaPadreID" => null
          ], $actual, $datos);
          if (is_string($datos["Nombre"])) $datos["Nombre"] = trim($datos["Nombre"]);
          if (!validarTexto($datos["Nombre"], 100) ||
              !validarTexto($datos["Descripcion"], 255, true) ||
              !validarOpcion($datos["Estado"], ["Activo", "Inactivo"]) ||
              ($datos["CategoriaPadreID"] !== null && !validarEntero($datos["CategoriaPadreID"]))) {
               throw new InvalidArgumentException("Nombre, descripción, estado o categoría padre inválidos");
          }
          return $datos;
     }

     function validarPadreCategoria($categorias, $CategoriaPadreID, $CategoriaID = null) {
          $porId = [];
          foreach ($categorias as $categoria) $porId[$categoria["CategoriaID"]] = $categoria;
          $visitadas = [];
          // Recorrer los padres evita tanto A -> A como A -> B -> A.
          while ($CategoriaPadreID !== null) {
               if ($CategoriaPadreID == $CategoriaID || isset($visitadas[$CategoriaPadreID])) {
                    throw new DomainException("La relación entre categorías no puede formar un ciclo");
               }
               if (!isset($porId[$CategoriaPadreID])) {
                    throw new InvalidArgumentException("La categoría padre indicada no existe");
               }
               $visitadas[$CategoriaPadreID] = true;
               $CategoriaPadreID = $porId[$CategoriaPadreID]["CategoriaPadreID"];
          }
     }

     function listarCategorias($conexion) {
          return obtenerCategorias($conexion);
     }

     function buscarCategoria($conexion, $CategoriaID) {
          if (!validarEntero($CategoriaID)) return false;
          return obtenerCategoriaPorId($conexion, $CategoriaID);
     }

     function agregarCategoria($conexion, $datos) {
          $datos = prepararDatosCategoria($datos);
          validarPadreCategoria(obtenerCategorias($conexion), $datos["CategoriaPadreID"]);
          return crearCategoria($conexion, $datos);
     }

     function editarCategoria($conexion, $CategoriaID, $datos) {
          if (!validarEntero($CategoriaID)) throw new InvalidArgumentException("ID de categoría inválido");
          $conexion->beginTransaction();
          try {
               // Bloquear la jerarquía evita que dos ediciones simultáneas formen un ciclo.
               $categorias = bloquearCategorias($conexion);
               $actual = null;
               foreach ($categorias as $categoria) {
                    if ($categoria["CategoriaID"] == $CategoriaID) $actual = $categoria;
               }
               if (!$actual) {
                    $conexion->rollBack();
                    return false;
               }
               $datos = prepararDatosCategoria($datos, $actual);
               validarPadreCategoria($categorias, $datos["CategoriaPadreID"], $CategoriaID);
               $resultado = actualizarCategoria($conexion, $CategoriaID, $datos);
               $conexion->commit();
               return $resultado;
          } catch (Throwable $e) {
               $conexion->rollBack();
               throw $e;
          }
     }

     function quitarCategoria($conexion, $CategoriaID) {
          if (!validarEntero($CategoriaID)) return false;
          return eliminarCategoria($conexion, $CategoriaID);
     }
?>