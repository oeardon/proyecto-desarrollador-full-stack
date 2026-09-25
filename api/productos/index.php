<?php
     session_start();
     header("Content-Type: application/json; charset=UTF-8");
     require_once "../respuestas.php";
     require_once "../../app/controllers/Validaciones.php";
     require_once "../../app/models/Sesion.php";
     require_once "../../app/models/Producto.php";
     require_once "../../app/controllers/ProductoController.php";
     require_once "../../app/services/ImagenProducto.php";
     try {
          $metodo = $_SERVER["REQUEST_METHOD"];
          $multipart = strtolower(trim(explode(';', $_SERVER['CONTENT_TYPE'] ?? '')[0])) === 'multipart/form-data';
          if (isset($_GET['_method'])) {
               if ($metodo !== 'POST' || !$multipart || $_GET['_method'] !== 'PUT') {
                    responderApi(400, ['success' => false, 'message' => 'Operación de formulario inválida']);
               }
               $metodo = 'PUT';
          }
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
               $registro = buscarProducto($conexion, $id);
               if (!$registro) responderApi(404, ["success" => false, "message" => "Registro no encontrado"]);
          }
          if ($multipart && in_array($metodo, ['POST', 'PUT'], true)) {
               $json = $_POST['datos'] ?? null;
               if (!is_string($json) || !is_object(json_decode($json))) {
                    throw new InvalidArgumentException('Formulario inválido o demasiado grande. La imagen debe pesar como máximo 5 MB.');
               }
               $datos = json_decode($json, true);
               $archivo = $_FILES['Imagen'] ?? null;
               $productoId = guardarProductoConImagen($conexion, $metodo === 'PUT' ? $id : null, $datos, $archivo);
               responderApi($metodo === 'POST' ? 201 : 200, ['success' => true, 'ProductoID' => $productoId, 'message' => $metodo === 'POST' ? 'Registro creado correctamente' : 'Registro actualizado correctamente']);
          }
          switch ($metodo) {
               case "GET":
                    $resultado = $id !== null ? $registro : listarProductos($conexion);
                    responderApi(200, ["success" => true, "data" => $resultado]);
               case "POST":
                    $id = agregarProducto($conexion, leerDatosApi());
                    responderApi(201, ["success" => true, "ProductoID" => $id, "message" => "Registro creado correctamente"]);
               case "PUT":
                    if (!editarProducto($conexion, $id, leerDatosApi())) {
                         responderApi(404, ["success" => false, "message" => "Registro no encontrado"]);
                    }
                    responderApi(200, ["success" => true, "message" => "Registro actualizado correctamente"]);
               case "DELETE":
                    if (!quitarProducto($conexion, $id)) {
                         responderApi(404, ["success" => false, "message" => "Registro no encontrado"]);
                    }
                    responderApi(200, ["success" => true, "message" => "Registro eliminado correctamente"]);
          }
     } catch (Throwable $e) {
          responderErrorApi($e);
     }
?>