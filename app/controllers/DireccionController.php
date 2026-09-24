<?php
     function prepararDatosDireccion($datos, $actual = []) {
          $datos = array_merge(["Direccion" => null,
                                "Ciudad" => null,
                                "Subnacional" => null,
                                "Pais" => "Guatemala",
                                "UsuarioID" => null,
                                "CodigoPostal" => null,
                                "TipoDireccion" => "Casa",
                                "EsPrincipal" => 0], $actual, $datos);
          if ($datos["CodigoPostal"] === "") $datos["CodigoPostal"] = null;
          if (!(validarTexto($datos["Direccion"], 255) &&
               validarTexto($datos["Ciudad"], 75) &&
               validarTexto($datos["Subnacional"], 100) &&
               validarTexto($datos["Pais"], 50) &&
               validarEntero($datos["UsuarioID"]) &&
               validarTexto($datos["CodigoPostal"], 15, true) &&
               validarOpcion($datos["TipoDireccion"], ["Casa", "Trabajo", "Otro"]) &&
               in_array($datos["EsPrincipal"], [0, 1, false, true], true))) {
               throw new InvalidArgumentException("Datos de dirección inválidos");
          }
          $datos["EsPrincipal"] = (int) $datos["EsPrincipal"];
          return $datos;
     }

     function listarDirecciones($conexion, $UsuarioID = null) {
          return obtenerTodosDirecciones($conexion, $UsuarioID);
     }

     function buscarDireccion($conexion, $DireccionID) {
          return obtenerDireccionPorId($conexion, $DireccionID);
     }

     function agregarDireccion($conexion, $datos) {
          $datos = prepararDatosDireccion($datos);
          $conexion->beginTransaction();
          try {
               if (!bloquearUsuarioDireccion($conexion, $datos["UsuarioID"])) throw new InvalidArgumentException("Usuario inexistente");
               if ($datos["EsPrincipal"]) quitarPrincipalDirecciones($conexion, $datos["UsuarioID"]);
               $id = crearDireccion($conexion, $datos);
               $conexion->commit();
               return $id;
          } catch (Throwable $e) {
               $conexion->rollBack();
               throw $e;
          }
     }

     function editarDireccion($conexion, $DireccionID, $datos) {
          $actual = obtenerDireccionPorId($conexion, $DireccionID);
          if (!$actual) return false;
          $datos["UsuarioID"] = $actual["UsuarioID"];
          $datos = prepararDatosDireccion($datos, $actual);
          $conexion->beginTransaction();
          try {
               bloquearUsuarioDireccion($conexion, $actual["UsuarioID"]);
               if ($datos["EsPrincipal"]) quitarPrincipalDirecciones($conexion, $actual["UsuarioID"]);
               $resultado = actualizarDireccion($conexion, $DireccionID, $datos);
               $conexion->commit();
               return $resultado;
          } catch (Throwable $e) {
               $conexion->rollBack();
               throw $e;
          }
     }

     function quitarDireccion($conexion, $DireccionID) {
          return eliminarDireccion($conexion, $DireccionID);
     }
?>