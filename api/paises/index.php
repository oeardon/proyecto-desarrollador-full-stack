<?php
     header("Content-Type: application/json; charset=UTF-8");
     try {
          if ($_SERVER["REQUEST_METHOD"] !== "GET") {
               http_response_code(405);
               echo json_encode(["success" => false, "message" => "Método no permitido"]);
               exit();
          }
          $url = "https://api.restcountries.com/countries/v5"
               . "?response_fields=names.common,codes.alpha_2,flag.emoji"
               . "&limit=100";
          $ch = curl_init($url);
          require_once "../../config/api_keys.php";
          curl_setopt($ch, CURLOPT_HTTPHEADER, ['Authorization: Bearer '. $restCountriesApiKey]);
          curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
          $respuesta = curl_exec($ch);
          if ($respuesta === false) {
               throw new RuntimeException("No se pudo consultar la API de países");
          }
          $codigoHttp = curl_getinfo($ch, CURLINFO_HTTP_CODE);
          curl_close($ch);
          if ($codigoHttp !== 200) {
               throw new RuntimeException("La API de países respondió con error");
          }
          $datos = json_decode($respuesta, true);
          echo json_encode(["success" => true, "data" => $datos["data"]["objects"]]);
     } catch (Throwable $e) {
          http_response_code(500);
          echo json_encode(["success" => false, "message" => "No se pudo obtener el listado de países"]);
     }
?>