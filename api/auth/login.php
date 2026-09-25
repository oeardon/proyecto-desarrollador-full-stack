<?php
     header("Content-Type: application/json; charset=UTF-8");
     header("Cache-Control: no-store");
     require_once "../respuestas.php";
     require_once "../../app/controllers/Validaciones.php";
     require_once "../../app/models/Usuario.php";
     require_once "../../app/controllers/AuthController.php";
     try {
          if ($_SERVER["REQUEST_METHOD"] !== "POST") {
               header("Allow: POST");
               responderApi(405, ["success" => false, "message" => "Método no permitido"]);
          }
          $datos = leerDatosApi();
          require_once "../../config/database.php";
          session_start();
          $usuario = autenticarUsuario($conexion, $datos);
          if (!$usuario) {
               // Un intento fallido no deja autenticada una cuenta anterior.
               $_SESSION = [];
               responderApi(401, ["success" => false, "message" => "Usuario, correo o contraseña incorrectos"]);
          }
          $_SESSION = [];
          if (!session_regenerate_id(true)) throw new RuntimeException("No se pudo renovar la sesión");
          $_SESSION["UsuarioID"] = $usuario["UsuarioID"];
          $_SESSION["Usuario"] = $usuario["Usuario"];
          $_SESSION["TipoUsuario"] = $usuario["TipoUsuario"];
          responderApi(200, ["success" => true,"message" => "Inicio de sesión correcto",
                             "usuario" => ["UsuarioID" => $usuario["UsuarioID"],
                             "Usuario" => $usuario["Usuario"],
                             "TipoUsuario" => $usuario["TipoUsuario"]]]);
     } catch (Throwable $e) {
          responderErrorApi($e);
     }
?>