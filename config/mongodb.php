<?php
     require_once "../vendor/autoload.php";
     $mongoURI = "mongodb+srv://USUARIO:CONTRASENA@CLUSTER.mongodb.net/?retryWrites=true&w=majority";
     try {
          $clienteMongo = new MongoDB\Client($mongoURI);
          $mongoDB = $clienteMongo->selectDatabase("todoaqui_db");
          $mongoDB->command(["ping" => 1]);
     } catch (Throwable $e) {
          die("Error de conexión a MongoDB");
     }
?>