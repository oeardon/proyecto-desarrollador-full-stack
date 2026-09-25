<?php
     session_start();
     header("Content-Type: application/json; charset=UTF-8");
     header("Cache-Control: no-store");
     require_once "../respuestas.php";
     require_once "../../app/controllers/Validaciones.php";
     require_once "../../app/models/Sesion.php";
     require_once "../../app/models/Resena.php";
     require_once "../../app/controllers/ResenaController.php";
     try {
          $metodo = $_SERVER["REQUEST_METHOD"];
          $multipart = strtolower(trim(explode(';', $_SERVER['CONTENT_TYPE'] ?? '')[0])) === 'multipart/form-data';
          if (isset($_GET['_method'])) {
               if ($metodo !== 'POST' || !$multipart || $_GET['_method'] !== 'PUT') responderApi(400, ['success' => false, 'message' => 'Operación inválida']);
               $metodo = 'PUT';
          }
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
          $archivos = [];
          if (in_array($metodo, ['POST', 'PUT'], true)) {
               if ($multipart) {
                    $json = $_POST['datos'] ?? null;
                    if (!is_string($json) || !is_object(json_decode($json))) throw new InvalidArgumentException('Formulario inválido o demasiado grande. Máximo 3 imágenes de 2 MB cada una.');
                    $datos = json_decode($json, true);
                    $archivos = archivosImagenesResena();
               } else $datos = leerDatosApi();
          }
          switch ($metodo) {
               case "GET":
                    if ($registro) {
                         unset($registro["UsuarioID"], $registro["Version"]);
                         $resultado = $registro;
                    } else {
                         $ProductoID = isset($_GET["ProductoID"]) ? leerIdApi("ProductoID") : null;
                         $resultado = listarResenas($conexion, $ProductoID, $administrador);
                    }
                    responderApi(200, ["success" => true, "data" => $resultado]);
               case "POST":
                    $id = agregarResena($conexion, $usuario["UsuarioID"], $datos, $archivos);
                    responderApi(201, ["success" => true, "ResenaID" => $id, "message" => "Reseña creada correctamente"]);
               case "PUT":
                    if (!$propietario && (array_keys($datos) !== ["Estado"] || $archivos)) responderApi(403, ["success" => false, "message" => "Solo puede moderar el estado de reseñas ajenas"]);
                    if (!editarResena($conexion, $id, $datos, $administrador, $archivos)) responderApi(404, ["success" => false, "message" => "Reseña no encontrada"]);
                    responderApi(200, ["success" => true, "message" => "Reseña actualizada correctamente"]);
               case "DELETE":
                    if (!quitarResena($conexion, $id)) responderApi(404, ["success" => false, "message" => "Reseña no encontrada"]);
                    responderApi(200, ["success" => true, "message" => "Reseña eliminada correctamente"]);
          }
     } catch (Throwable $e) {
          responderErrorApi($e);
     }
?>