<?php
     function responderApi($codigo, $respuesta) {
          http_response_code($codigo);
          echo json_encode($respuesta, JSON_UNESCAPED_UNICODE);
          exit();
     }

     function leerDatosApi() {
          $tipo = strtolower(trim(explode(";", $_SERVER["CONTENT_TYPE"] ?? "")[0]));
          if ($tipo !== "application/json") responderApi(415, ["success" => false, "message" => "Use Content-Type: application/json"]);
          $contenido = file_get_contents("php://input");
          $objeto = json_decode($contenido);
          if (json_last_error() !== JSON_ERROR_NONE || !is_object($objeto)) {
               responderApi(400, ["success" => false, "message" => "Debe enviar un objeto JSON válido"]);
          }
          return json_decode($contenido, true);
     }

     function leerIdApi($campo = "id") {
          $valor = $_GET[$campo] ?? null;
          if (!validarEntero($valor)) {
               responderApi(400, ["success" => false, "message" => "Debe indicar un ID entero positivo"]);
          }
          return (int) $valor;
     }

     function exigirSesionApi($conexion) {
          if (!isset($_SESSION["UsuarioID"])) {
               responderApi(401, ["success" => false, "message" => "Debe iniciar sesión"]);
          }
          $usuario = obtenerUsuarioSesion($conexion, $_SESSION["UsuarioID"]);
          if (!$usuario || $usuario["Estado"] !== "Activo") {
               $_SESSION = [];
               responderApi(401, ["success" => false, "message" => "La sesión ya no es válida"]);
          }
          return $usuario;
     }

     function exigirAdministradorApi($usuario) {
          if ($usuario["TipoUsuario"] !== "Administrador") {
               responderApi(403, ["success" => false, "message" => "No tiene permisos para realizar esta operación"]);
          }
     }

     function responderErrorApi($error) {
          if ($error instanceof PDOException) {
               $codigo = $error->errorInfo[1] ?? 0;
               if ($codigo == 1062) responderApi(409, ["success" => false, "message" => "Ya existe un registro con esos datos únicos"]);
               if ($codigo == 1451) responderApi(409, ["success" => false, "message" => "No se puede eliminar: existen registros relacionados"]);
               if ($codigo == 1452) responderApi(400, ["success" => false, "message" => "Uno de los registros relacionados no existe"]);
          }
          if ($error instanceof InvalidArgumentException) responderApi(400, ["success" => false, "message" => $error->getMessage()]);
          if ($error instanceof DomainException) responderApi(409, ["success" => false, "message" => $error->getMessage()]);
          error_log((string) $error);
          responderApi(500, ["success" => false, "message" => "Error al procesar la operación"]);
     }
?>