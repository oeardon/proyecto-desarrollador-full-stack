<?php
    if (PHP_SAPI !== 'cli') { http_response_code(404); exit; }
    require_once __DIR__ . '/../app/services/ResenasMongo.php';
    try {
        if (($argv[1] ?? '') !== '--aplicar') {
            echo "Uso: php database/preparar_resenas_mongo.php --aplicar\n";
            echo "Prepara índices únicos y contador sobre la colección Resenas existente. No importa documentos.\n";
            exit;
        }
        ejecutarResenasMongo(fn($database) => prepararResenasMongo($database));
        echo "Índices y contador de reseñas preparados.\n";
    } catch (Throwable $error) {
        fwrite(STDERR, "No se pudo preparar MongoDB. Comprueba conexión, permisos y duplicados en ResenaID o UsuarioID/ProductoID.\n");
        exit(1);
    }
?>