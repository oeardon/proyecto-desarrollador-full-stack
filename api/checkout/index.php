<?php
session_start();
header('Content-Type: application/json; charset=UTF-8');
header('Cache-Control: no-store');
require_once __DIR__ . '/../respuestas.php';
require_once __DIR__ . '/../../app/controllers/Validaciones.php';
require_once __DIR__ . '/../../app/models/Sesion.php';
require_once __DIR__ . '/../../app/models/Orden.php';
require_once __DIR__ . '/../../app/models/Factura.php';
require_once __DIR__ . '/../../app/models/Pago.php';
require_once __DIR__ . '/../../app/models/Catalogo.php';
require_once __DIR__ . '/../../app/services/CorreoPedido.php';
require_once __DIR__ . '/../../app/controllers/CheckoutController.php';
try {
    $metodo = $_SERVER['REQUEST_METHOD'];
    if (!in_array($metodo, ['GET', 'POST'], true)) {
        header('Allow: GET, POST');
        responderApi(405, ['success' => false, 'message' => 'Método no permitido']);
    }
    require __DIR__ . '/../../config/database.php';
    $usuario = exigirSesionApi($conexion);
    if ($metodo === 'GET') {
        $factura = facturaCheckout($conexion, $usuario['UsuarioID'], tokenCheckout($_GET['solicitud'] ?? null));
        if (!$factura) responderApi(404, ['success' => false, 'message' => 'Todavía no se ha registrado este pedido']);
        responderApi(200, ['success' => true, 'data' => resumenCheckout($conexion, $usuario['UsuarioID'], $factura)]);
    }
    $resultado = realizarCheckout($conexion, $usuario['UsuarioID'], leerDatosApi());
    responderApi($resultado['nuevo'] ? 201 : 200, ['success' => true, 'data' => $resultado['pedido']]);
} catch (Throwable $error) { responderErrorApi($error); }
