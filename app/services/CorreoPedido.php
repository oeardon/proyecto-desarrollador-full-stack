<?php
function contenidoCorreoPedido($pedido) {
    $esc = fn($valor) => htmlspecialchars((string)$valor, ENT_QUOTES | ENT_SUBSTITUTE, 'UTF-8');
    $monto = fn($valor) => 'Q. ' . number_format((float)$valor, 2);
    $filas = '';
    $texto = "Pedido #{$pedido['OrdenID']}\nHola {$pedido['Cliente']}\n";
    foreach ($pedido['Detalles'] as $detalle) {
        $filas .= '<tr><td>' . $esc($detalle['Producto']) . '</td><td>' . $esc($detalle['Cantidad']) . '</td><td>' . $monto($detalle['PrecioUnitario']) . '</td><td>' . $monto($detalle['Subtotal']) . '</td></tr>';
        $texto .= $detalle['Producto'] . ' — ' . $detalle['Cantidad'] . ' unidades — ' . $monto($detalle['Subtotal']) . "\n";
    }
    $resumen = '<p>Forma de pago: ' . $esc($pedido['MetodoPago']) . ' (pendiente).</p><p>Envío: ' . $esc($pedido['DireccionEnvio']) . '</p><p>Facturación: ' . $esc($pedido['Factura']['Nombre']) . ' · NIT ' . $esc($pedido['Factura']['NIT']) . '<br>' . $esc($pedido['DireccionPago']) . '</p>';
    return [
        'html' => '<h2>Confirmación de pedido #' . $esc($pedido['OrdenID']) . '</h2><p>Hola ' . $esc($pedido['Cliente']) . ', recibimos tu pedido.</p><table border="1" cellpadding="8"><tr><th>Producto</th><th>Cantidad</th><th>Precio unitario</th><th>Subtotal</th></tr>' . $filas . '</table><h3>Total: ' . $monto($pedido['Total']) . '</h3>' . $resumen . '<p>Gracias por comprar en TodoAquí.</p>',
        'text' => $texto . 'Total: ' . $monto($pedido['Total']) . "\nForma de pago: " . $pedido['MetodoPago'] . " (pendiente)\nEnvío: " . $pedido['DireccionEnvio'] . "\nFacturación: " . $pedido['Factura']['Nombre'] . ' / NIT ' . $pedido['Factura']['NIT'] . "\n" . $pedido['DireccionPago'],
    ];
}
function enviarCorreoPedido($pedido) {
    try {
        $config = require __DIR__ . '/../../config/mail.php';
        if (!$config['enabled'] || !$config['host'] || !$config['from'] || !$config['username'] || !$config['password']) return 'no_configurado';
        require_once __DIR__ . '/../../vendor/autoload.php';
        $mail = new \PHPMailer\PHPMailer\PHPMailer(true);
        $mail->isSMTP();
        $mail->Host = $config['host'];
        $mail->Port = $config['port'];
        $mail->SMTPAuth = true;
        $mail->Username = $config['username'];
        $mail->Password = $config['password'];
        $mail->SMTPSecure = $config['encryption'];
        $mail->Timeout = 10;
        $mail->Timelimit = 15;
        $mail->CharSet = 'UTF-8';
        $mail->setFrom($config['from'], $config['name']);
        $mail->addAddress($pedido['Correo'], $pedido['Cliente']);
        $contenido = contenidoCorreoPedido($pedido);
        $mail->isHTML(true);
        $mail->Subject = 'Confirmación de pedido #' . $pedido['OrdenID'];
        $mail->Body = $contenido['html'];
        $mail->AltBody = $contenido['text'];
        $mail->send();
        return 'enviado';
    } catch (Throwable $error) {
        // No registrar credenciales ni mensajes SMTP que puedan incluir datos privados.
        error_log('No se pudo enviar confirmación del pedido ' . (int)$pedido['OrdenID']);
        return 'fallido';
    }
}
