<?php
     function autenticarUsuario($conexion, $datos) {
          $porCorreo = array_key_exists("Correo", $datos);
          if ($porCorreo && array_key_exists("Usuario", $datos)) {
               throw new InvalidArgumentException("Envíe Correo o Usuario, no ambos");
          }
          $identificador = $porCorreo ? $datos["Correo"] : ($datos["Usuario"] ?? null);
          $contrasena = $datos["Contrasena"] ?? null;
          if (is_string($identificador)) $identificador = trim($identificador);
          if (!validarTexto($identificador, $porCorreo ? 100 : 50) ||
              ($porCorreo && !filter_var($identificador, FILTER_VALIDATE_EMAIL)) ||
              !is_string($contrasena) || $contrasena === "" || strlen($contrasena) > 72 ||
              strpos($contrasena, "\0") !== false) {
               throw new InvalidArgumentException("Indique un usuario o correo válido y una contraseña de hasta 72 bytes");
          }
          $usuario = obtenerUsuarioParaLogin($conexion, $identificador, $porCorreo);
          if (!$usuario || !password_verify($contrasena, $usuario["Contrasena"])) return false;
          unset($usuario["Contrasena"]);
          return $usuario;
     }

     function registrarCliente($conexion, $datos) {
          // El registro público nunca toma permisos ni estado del navegador.
          $datos["TipoUsuario"] = "Cliente";
          $datos["Estado"] = "Activo";
          if (is_string($datos["Telefono"] ?? null)) $datos["Telefono"] = trim($datos["Telefono"]);
          if (is_string($datos["Contrasena"] ?? null) && strpos($datos["Contrasena"], "\0") !== false) {
               throw new InvalidArgumentException("La contraseña contiene un carácter no permitido");
          }
          // Reutiliza la validación de Usuarios y password_hash(), sin duplicarlas.
          $datos = prepararDatosUsuario($datos);
          if (existeUsuarioDuplicado($conexion, $datos)) {
               throw new DomainException("El correo, teléfono o usuario ya está registrado");
          }
          // Las restricciones UNIQUE también protegen registros simultáneos.
          return crearUsuario($conexion, $datos);
     }
?>