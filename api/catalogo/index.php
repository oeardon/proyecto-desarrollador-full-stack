<?php
    header('Content-Type: application/json; charset=UTF-8');
    header('Cache-Control: no-store');
    require_once __DIR__ . '/../respuestas.php';
    require_once __DIR__ . '/../../app/models/Catalogo.php';
    try {
        if ($_SERVER['REQUEST_METHOD'] !== 'GET') {
            header('Allow: GET');
            responderApi(405, ['success' => false, 'message' => 'Método no permitido']);
        }
        require __DIR__ . '/../../config/database.php';
        $categorias = categoriasCatalogo($conexion);
        responderApi(200, ['success' => true, 'data' => ['Categorias' => $categorias, 'Productos' => productosCatalogo($conexion, $categorias)]]);
    } catch (Throwable $error) { responderErrorApi($error); }
?>