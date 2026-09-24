<?php
     function prepararDatosUsuario($datos, $actual = []) {
          $datos = array_merge(["Nombres" => null,
                                "Apellidos" => null,
                                "Correo" => null,
                                "Telefono" => null,
                                "Usuario" => null,
                                "Contrasena" => null,
                                "TipoUsuario" => "Cliente",
                                "Estado" => "Activo"], $actual, $datos);
          if (is_string($datos["Nombres"])) $datos["Nombres"] = trim($datos["Nombres"]);
          if (is_string($datos["Apellidos"])) $datos["Apellidos"] = trim($datos["Apellidos"]);
          if (is_string($datos["Correo"])) $datos["Correo"] = trim($datos["Correo"]);
          if (is_string($datos["Usuario"])) $datos["Usuario"] = trim($datos["Usuario"]);
          if (!(validarTexto($datos["Nombres"], 75) &&
               validarTexto($datos["Apellidos"], 75) &&
               validarTexto($datos["Correo"], 100) &&
               filter_var($datos["Correo"], FILTER_VALIDATE_EMAIL) &&
               validarTexto($datos["Telefono"], 20) &&
               validarTexto($datos["Usuario"], 50) &&
               validarOpcion($datos["TipoUsuario"], ["Administrador", "Cliente"]) &&
               validarOpcion($datos["Estado"], ["Activo", "Inactivo"]))) {
               throw new InvalidArgumentException("Datos de usuario inválidos");
          }
          if (!$actual || array_key_exists("Contrasena", $datos) && $datos["Contrasena"] !== null) {
               if (!is_string($datos["Contrasena"]) || strlen($datos["Contrasena"]) < 8 || strlen($datos["Contrasena"]) > 72) {
                    throw new InvalidArgumentException("La contraseña debe tener entre 8 y 72 bytes");
               }
               $datos["Contrasena"] = password_hash($datos["Contrasena"], PASSWORD_DEFAULT);
          }
          return $datos;
     }

     function listarUsuarios($conexion) {
          return obtenerTodosUsuarios($conexion);
     }

     function buscarUsuario($conexion, $UsuarioID) {
          return obtenerUsuarioPorId($conexion, $UsuarioID);
     }

     function agregarUsuario($conexion, $datos) {
          $datos = prepararDatosUsuario($datos);
          return crearUsuario($conexion, $datos);
     }

     function editarUsuario($conexion, $UsuarioID, $datos) {
          $actual = obtenerUsuarioPorId($conexion, $UsuarioID);
          if (!$actual) return false;
          $datos = prepararDatosUsuario($datos, $actual);
          return actualizarUsuario($conexion, $UsuarioID, $datos);
     }

     function quitarUsuario($conexion, $UsuarioID) {
          return eliminarUsuario($conexion, $UsuarioID);
     }
?>