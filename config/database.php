<?php
     class Database {
          private string $host = "localhost";
          private string $db_name = "tienda_online";
          private string $username = "root";
          private string $password = "";
          private string $charset = "utf8mb4";
          public function conectar(): PDO {
               $dsn = "mysql:host={$this->host};dbname={$this->db_name};charset={$this->charset}";
               $opciones = [
                    PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
                    PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
                    PDO::ATTR_EMULATE_PREPARES => false
               ];
               return new PDO($dsn,$this->username,$this->password,$opciones);
          }
     }
?>