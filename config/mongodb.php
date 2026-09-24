<?php
     require_once "../vendor/autoload.php";
     require_once "api_keys.php";
     try {
          $clienteMongo = new MongoDB\Client($mongoURI);
          $mongoDB = $clienteMongo->selectDatabase("todoaqui_db");
          $mongoDB->command(["ping" => 1]);
     } catch (Throwable $e) {
          die("Error de conexión a MongoDB");
     }
?>