<?php
     $cadena = "";
     $hash = "";
     if ($_SERVER["REQUEST_METHOD"] == "POST") {
          $cadena = trim($_POST["cadena"] ?? "");
          if ($cadena != "") {
               $hash = password_hash($cadena, PASSWORD_DEFAULT);
          }
     }
?>
<!DOCTYPE html>
<html lang="es">
<head>
     <meta charset="UTF-8">
     <meta name="viewport" content="width=device-width, initial-scale=1.0">
     <title>Generador Hash</title>
</head>
<body style="text-align: center; padding-top: 20px;">
     <h1>Generador Hash</h1><br>
     <form method="POST">
          <label for="cadena">Ingrese texto</label><br><br>
          <input type="text" name="cadena" id="cadena" 
               value="<?php echo htmlspecialchars($cadena); ?>" required><br><br>
          <button type="submit">Convertir</button>
          <?php if ($hash != "") { ?>
               <hr><br>
               <label for="hash">Texto convertido</label><br><br>
               <input type="text" name="hash" id="hash" size="70" readonly
                    value="<?php echo $hash; ?>">
               <button type="button" onclick="copiarHash()">Copiar hash</button><br><br>
               <button>
                    <a href="<?php echo $_SERVER["PHP_SELF"]; ?>" 
                         style="text-decoration: none;">Restablecer
                    </a>
               </button>
          <?php } ?>
     </form>
     <script>
          function copiarHash() {
               const hash = document.getElementById("hash").value;
               navigator.clipboard.writeText(hash)
                    .then(() => {
                         alert("Hash copiado al portapapeles.");
                    })
                    .catch(() => {
                         alert("No se pudo copiar el hash.");
                    });
          }
     </script>
</body>
</html>