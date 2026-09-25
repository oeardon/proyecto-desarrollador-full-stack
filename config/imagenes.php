<?php
     // En producción, configurar la carpeta física publicada como /productos.
     return
          ['resenas_directorio' => getenv('RESENAS_IMAGENES_DIR') 
               ?: __DIR__ . '/../public/uploads/resenas', 'directorio' => getenv('PRODUCTOS_IMAGENES_DIR') 
               ?: __DIR__ . '/../frontend/public/productos'];
?>