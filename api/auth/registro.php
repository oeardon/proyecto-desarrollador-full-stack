<?php
     header("Content-Type: application/json; charset=UTF-8");
     header("Cache-Control: no-store");
     require_once "../respuestas.php";
     require_once "../../app/controllers/Validaciones.php";
     require_once "../../app/models/Usuario.php";
     require_once "../../app/controllers/UsuarioController.php";
     require_once "../../app/controllers/AuthController.php";
     try {
          if ($_SERVER["REQUEST_METHOD"] !== "POST") {
               header("Allow: POST");
               responderApi(405, ["success" => false, "message" => "Método no permitido"]);
          }
          $datos = leerDatosApi();
          require_once "../../config/database.php";
          $UsuarioID = registrarCliente($conexion, $datos);
          responderApi(201, ["success" => true, 
                             "message" => "Registro correcto. Ya puede iniciar sesión",
                             "UsuarioID" => $UsuarioID]);
     } catch (Throwable $e) {
          responderErrorApi($e);
     }
?>