<?php
     header("Content-Type: application/json; charset=UTF-8");
     require_once "../respuestas.php";
     try {
          if ($_SERVER["REQUEST_METHOD"] !== "POST") {
               header("Allow: POST");
               responderApi(405, ["success" => false, "message" => "Método no permitido"]);
          }
          session_start();
          session_unset();
          if (!session_destroy()) throw new RuntimeException("No se pudo cerrar la sesión");
          responderApi(200, ["success" => true, "message" => "Sesión cerrada correctamente"]);
     } catch (Throwable $e) {
          responderErrorApi($e);
     }
?>