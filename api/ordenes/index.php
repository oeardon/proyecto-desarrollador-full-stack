<?php
     session_start();
     header("Content-Type: application/json; charset=UTF-8");
     require_once "../respuestas.php";
     require_once "../../app/controllers/Validaciones.php";
     require_once "../../app/models/Sesion.php";
     require_once "../../app/models/Orden.php";
     require_once "../../app/controllers/OrdenController.php";
     try {
          $metodo = $_SERVER["REQUEST_METHOD"];
          if (!in_array($metodo, ["GET", "POST", "PUT", "DELETE"], true)) {
               header("Allow: GET, POST, PUT, DELETE");
               responderApi(405, ["success" => false, "message" => "Método no permitido"]);
          }
          require_once "../../config/database.php";
          $usuario = exigirSesionApi($conexion);
          $administrador = $usuario["TipoUsuario"] === "Administrador";
          if ($metodo === "PUT" || $metodo === "DELETE") exigirAdministradorApi($usuario);
          $id = null;
          $registro = null;
          if (isset($_GET["id"]) || $metodo === "PUT" || $metodo === "DELETE") {
               $id = leerIdApi();
               $registro = buscarOrden($conexion, $id);
               if (!$registro || (!$administrador && $registro["UsuarioID"] != $usuario["UsuarioID"])) responderApi(404, ["success" => false, "message" => "Registro no encontrado"]);
          }
          switch ($metodo) {
               case "GET":
                    $resultado = $id !== null ? $registro : listarOrdenes($conexion, $administrador ? null : $usuario["UsuarioID"]);
                    responderApi(200, ["success" => true, "data" => $resultado]);
               case "POST":
                    $datos = leerDatosApi();
                    if (!$administrador) $datos["UsuarioID"] = $usuario["UsuarioID"];
                    if (!validarEntero($datos["UsuarioID"] ?? null)) responderApi(400, ["success" => false, "message" => "UsuarioID inválido"]);
                    $cliente = obtenerUsuarioSesion($conexion, $datos["UsuarioID"]);
                    if (!$cliente || $cliente["Estado"] !== "Activo") responderApi(400, ["success" => false, "message" => "El usuario no está activo"]);
                    $id = agregarOrden($conexion, $datos);
                    responderApi(201, ["success" => true, "OrdenID" => $id, "message" => "Registro creado correctamente"]);
               case "PUT":
                    $resultado = editarOrden($conexion, $id, leerDatosApi());
                    if (!$resultado) responderApi(404, ["success" => false, "message" => "Registro no encontrado"]);
                    responderApi(200, ["success" => true, "message" => "Registro actualizado correctamente"]);
               case "DELETE":
                    if (!quitarOrden($conexion, $id)) responderApi(404, ["success" => false, "message" => "Registro no encontrado"]);
                    responderApi(200, ["success" => true, "message" => "Registro eliminado correctamente"]);
          }
     } catch (Throwable $e) {
          responderErrorApi($e);
     }
?>