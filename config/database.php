<?php
     require_once "api_keys.php";
     try {
          $conexion = new PDO("mysql:host=$host;dbname=$bd;charset=utf8mb4", $usuario, $contrasena);
          $conexion->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
          $conexion->setAttribute(PDO::ATTR_DEFAULT_FETCH_MODE, PDO::FETCH_ASSOC);
     } catch (PDOException $e) {
          http_response_code(500);
          header("Content-Type: application/json; charset=UTF-8");
          echo json_encode(["success" => false, "message" => "Error de conexión a la base de datos"]);
          exit();
     }
?>