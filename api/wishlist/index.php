<?php
     session_start();
     header("Content-Type: application/json; charset=UTF-8");
     require_once "../respuestas.php";
     require_once "../../app/controllers/Validaciones.php";
     require_once "../../app/models/Sesion.php";
     require_once "../../app/models/ListaDeseos.php";
     require_once "../../app/controllers/ListaDeseosController.php";
     try {
          $metodo = $_SERVER["REQUEST_METHOD"];
          if (!in_array($metodo, ["GET", "POST", "DELETE"], true)) {
               header("Allow: GET, POST, DELETE");
               responderApi(405, ["success" => false, "message" => "Método no permitido"]);
          }
          require_once "../../config/database.php";
          $usuario = exigirSesionApi($conexion);
          $UsuarioID = $usuario["UsuarioID"];
          switch ($metodo) {
               case "GET":
                    if (isset($_GET["id"])) {
                         $resultado = buscarDeseo($conexion, $UsuarioID, leerIdApi());
                         if (!$resultado) responderApi(404, ["success" => false, "message" => "Producto no encontrado en su lista"]);
                    } else {
                         $resultado = listarListaDeseos($conexion, $UsuarioID);
                    }
                    responderApi(200, ["success" => true, "data" => $resultado]);
               case "POST":
                    $datos = leerDatosApi();
                    agregarDeseo($conexion, $UsuarioID, $datos);
                    responderApi(201, ["success" => true, "ProductoID" => $datos["ProductoID"], "message" => "Producto agregado a su lista"]);
               case "DELETE":
                    if (!quitarDeseo($conexion, $UsuarioID, leerIdApi())) responderApi(404, ["success" => false, "message" => "Producto no encontrado en su lista"]);
                    responderApi(200, ["success" => true, "message" => "Producto eliminado de su lista"]);
          }
     } catch (Throwable $e) {
          responderErrorApi($e);
     }
?>