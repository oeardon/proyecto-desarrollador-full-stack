<?php
     session_start();
     header("Content-Type: application/json; charset=UTF-8");
     require_once "../respuestas.php";
     require_once "../../app/controllers/Validaciones.php";
     require_once "../../app/models/Sesion.php";
     require_once "../../app/models/Categoria.php";
     require_once "../../app/controllers/CategoriaController.php";
     try {
          $metodo = $_SERVER["REQUEST_METHOD"];
          if (!in_array($metodo, ["GET", "POST", "PUT", "DELETE"], true)) {
               header("Allow: GET, POST, PUT, DELETE");
               responderApi(405, ["success" => false, "message" => "Método no permitido"]);
          }
          require_once "../../config/database.php";
          if ($metodo !== "GET") {
               $usuario = exigirSesionApi($conexion);
               exigirAdministradorApi($usuario);
          }
          $id = null;
          $registro = null;
          if (isset($_GET["id"]) || $metodo === "PUT" || $metodo === "DELETE") {
               $id = leerIdApi();
               $registro = buscarCategoria($conexion, $id);
               if (!$registro) responderApi(404, ["success" => false, "message" => "Registro no encontrado"]);
          }
          switch ($metodo) {
               case "GET":
                    $resultado = $id !== null ? $registro : listarCategorias($conexion);
                    responderApi(200, ["success" => true, "data" => $resultado]);
               case "POST":
                    $id = agregarCategoria($conexion, leerDatosApi());
                    responderApi(201, ["success" => true, "CategoriaID" => $id, "message" => "Registro creado correctamente"]);
               case "PUT":
                    if (!editarCategoria($conexion, $id, leerDatosApi())) {
                         responderApi(404, ["success" => false, "message" => "Registro no encontrado"]);
                    }
                    responderApi(200, ["success" => true, "message" => "Registro actualizado correctamente"]);
               case "DELETE":
                    if (!quitarCategoria($conexion, $id)) {
                         responderApi(404, ["success" => false, "message" => "Registro no encontrado"]);
                    }
                    responderApi(200, ["success" => true, "message" => "Registro eliminado correctamente"]);
          }
     } catch (Throwable $e) {
          responderErrorApi($e);
     }
?>