<?php
     require_once "../config/database.php";
     try {
          $database = new Database();
          $conexion = $database -> conectar();
          echo "Conexión establecida correctamente";
     } catch (PDOException $e) {
          echo "Error de conexión: " . $e->getMessage();
     }
?>