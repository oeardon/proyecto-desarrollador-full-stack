<?php
     session_start();
     header("Content-Type: application/json; charset=UTF-8");
     require_once "../respuestas.php";
     require_once "../../app/controllers/Validaciones.php";
     require_once "../../app/models/Sesion.php";
     require_once "../../app/models/Usuario.php";
     require_once "../../app/controllers/UsuarioController.php";
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
               $registro = buscarUsuario($conexion, $id);
               if (!$registro) {
                    responderApi(404, ["success" => false, "message" => "Registro no encontrado"]);
               }
          }
          switch ($metodo) {
               case "GET":
                    $resultado = $id !== null ? $registro : listarUsuarios($conexion);
                    responderApi(200, ["success" => true, "data" => $resultado]);
               case "POST":
                    $datos = leerDatosApi();
                    $id = agregarUsuario($conexion, $datos);
                    responderApi(201, ["success" => true, "UsuarioID" => $id, "message" => "Registro creado correctamente"]);
               case "PUT":
                    $datos = leerDatosApi();
                    if ($id == $usuario["UsuarioID"] && (
                         (isset($datos["Estado"]) && $datos["Estado"] !== "Activo") ||
                         (isset($datos["TipoUsuario"]) && $datos["TipoUsuario"] !== "Administrador"))) {
                         responderApi(409, ["success" => false, "message" => "No puede desactivar ni quitar permisos a su propia cuenta"]);
                    }
                    editarUsuario($conexion, $id, $datos);
                    responderApi(200, ["success" => true, "message" => "Registro actualizado correctamente"]);
               case "DELETE":
                    if ($id == $usuario["UsuarioID"]) responderApi(409, ["success" => false, "message" => "No puede eliminar su propia cuenta"]);
                    if (!quitarUsuario($conexion, $id)) responderApi(404, ["success" => false, "message" => "Registro no encontrado"]);
                    responderApi(200, ["success" => true, "message" => "Registro eliminado correctamente"]);
          }
     } catch (Throwable $e) {
          responderErrorApi($e);
     }
?>