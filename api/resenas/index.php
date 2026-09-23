<?php
session_start();
header("Content-Type: application/json; charset=UTF-8");
require_once "../respuestas.php";
require_once "../../app/controllers/Validaciones.php";
require_once "../../app/models/Sesion.php";
require_once "../../app/models/Resena.php";
require_once "../../app/controllers/ResenaController.php";
try {
     $metodo = $_SERVER["REQUEST_METHOD"];
     if (!in_array($metodo, ["GET", "POST", "PUT", "DELETE"], true)) {
          header("Allow: GET, POST, PUT, DELETE");
          responderApi(405, ["success" => false, "message" => "Método no permitido"]);
     }
     require_once "../../config/database.php";
     $usuario = null;
     if ($metodo !== "GET" || isset($_SESSION["UsuarioID"])) $usuario = exigirSesionApi($conexion);
     $administrador = $usuario && $usuario["TipoUsuario"] === "Administrador";
     $id = null;
     $registro = null;
     if (isset($_GET["id"]) || $metodo === "PUT" || $metodo === "DELETE") {
          $id = leerIdApi();
          $registro = buscarResena($conexion, $id);
          if (!$registro) responderApi(404, ["success" => false, "message" => "Reseña no encontrada"]);
          $propietario = $usuario && $registro["UsuarioID"] == $usuario["UsuarioID"];
          if (($metodo === "GET" && $registro["Estado"] !== "Publicada" && !$administrador && !$propietario) ||
              ($metodo !== "GET" && !$administrador && !$propietario)) {
               responderApi(404, ["success" => false, "message" => "Reseña no encontrada"]);
          }
     }
     switch ($metodo) {
          case "GET":
               if ($registro) {
                    unset($registro["UsuarioID"]);
                    $resultado = $registro;
               } else {
                    $ProductoID = isset($_GET["ProductoID"]) ? leerIdApi("ProductoID") : null;
                    $resultado = listarResenas($conexion, $ProductoID, $administrador);
               }
               responderApi(200, ["success" => true, "data" => $resultado]);
          case "POST":
               $id = agregarResena($conexion, $usuario["UsuarioID"], leerDatosApi());
               responderApi(201, ["success" => true, "ResenaID" => $id, "message" => "Reseña creada correctamente"]);
          case "PUT":
               $datos = leerDatosApi();
               if (!$propietario && array_keys($datos) !== ["Estado"]) responderApi(403, ["success" => false, "message" => "Solo puede moderar el estado de reseñas ajenas"]);
               editarResena($conexion, $id, $datos, $administrador);
               responderApi(200, ["success" => true, "message" => "Reseña actualizada correctamente"]);
          case "DELETE":
               if (!quitarResena($conexion, $id)) responderApi(404, ["success" => false, "message" => "Reseña no encontrada"]);
               responderApi(200, ["success" => true, "message" => "Reseña eliminada correctamente"]);
     }
} catch (Throwable $e) {
     responderErrorApi($e);
}
