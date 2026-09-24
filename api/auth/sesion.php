<?php
     header("Content-Type: application/json; charset=UTF-8");
     require_once "../respuestas.php";
     require_once "../../app/models/Sesion.php";
     try {
          if ($_SERVER["REQUEST_METHOD"] !== "GET") {
               header("Allow: GET");
               responderApi(405, ["success" => false,"message" => "Método no permitido"]);
          }
          session_start();
          if (!isset($_SESSION["UsuarioID"])) {
               responderApi(200, ["success" => true,"autenticado" => false,"usuario" => null]);
          }
          require_once "../../config/database.php";
          $usuario = obtenerUsuarioSesion($conexion,$_SESSION["UsuarioID"]);
          if (!$usuario || $usuario["Estado"] !== "Activo") {
               session_unset();
               responderApi(200, ["success" => true,"autenticado" => false,"usuario" => null]);
          }
          // Actualizar los datos por si cambiaron en la base de datos.
          $_SESSION["Usuario"] = $usuario["Usuario"];
          $_SESSION["TipoUsuario"] = $usuario["TipoUsuario"];
          responderApi(200, ["success" => true,"autenticado" => true,
                             "usuario" => ["UsuarioID" => $usuario["UsuarioID"],
                                           "Usuario" => $usuario["Usuario"],
                                           "TipoUsuario" => $usuario["TipoUsuario"]]
                            ]);
     } catch (Throwable $e) {
          responderErrorApi($e);
     }
?>