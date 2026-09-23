<?php
     session_start();
     header("Content-Type: application/json; charset=UTF-8");
     require_once "../respuestas.php";
     require_once "../../app/controllers/Validaciones.php";
     require_once "../../app/models/Sesion.php";
     require_once "../../app/models/Proveedor.php";
     require_once "../../app/controllers/ProveedorController.php";
     try {
          $metodo = $_SERVER["REQUEST_METHOD"];
          if (!in_array($metodo, ["GET", "POST", "PUT", "DELETE"], true)) {
               header("Allow: GET, POST, PUT, DELETE");
               responderApi(405, ["success" => false, "message" => "Método no permitido"]);
          }
          require_once "../../config/database.php";
          $usuario = exigirSesionApi($conexion);
          exigirAdministradorApi($usuario);
          $id = null;
          $registro = null;
          if (isset($_GET["id"]) || $metodo === "PUT" || $metodo === "DELETE") {
               $id = leerIdApi();
               $registro = buscarProveedor($conexion, $id);
               if (!$registro) {
                    responderApi(404, ["success" => false, "message" => "Registro no encontrado"]);
               }
          }
          switch ($metodo) {
               case "GET":
                    $resultado = $id !== null ? $registro : listarProveedores($conexion);
                    responderApi(200, ["success" => true, "data" => $resultado]);
               case "POST":
                    $datos = leerDatosApi();
                    $id = agregarProveedor($conexion, $datos);
                    responderApi(201, ["success" => true, "ProveedorID" => $id, "message" => "Registro creado correctamente"]);
               case "PUT":
                    $datos = leerDatosApi();
                    editarProveedor($conexion, $id, $datos);
                    responderApi(200, ["success" => true, "message" => "Registro actualizado correctamente"]);
               case "DELETE":
                    if (!quitarProveedor($conexion, $id)) responderApi(404, ["success" => false, "message" => "Registro no encontrado"]);
                    responderApi(200, ["success" => true, "message" => "Registro eliminado correctamente"]);
          }
     } catch (Throwable $e) {
          responderErrorApi($e);
     }
?>