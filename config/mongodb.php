<?php
     try {
          require_once __DIR__ . "/../vendor/autoload.php";
          require_once __DIR__ . "/api_keys.php";
          if (!isset($mongoURI) || !is_string($mongoURI) || trim($mongoURI) === "") {
               throw new RuntimeException("La URI de MongoDB no está configurada");
          }
          $clienteMongo = new MongoDB\Client($mongoURI);
          $mongoDB = $clienteMongo->selectDatabase("todoaqui_db");
          $mongoDB->command(["ping" => 1]);
     } catch (Throwable $e) {
          // La API se encarga de responder con el código HTTP y el JSON apropiados.
          throw new RuntimeException("Error de conexión a MongoDB", 0, $e);
     }
?>