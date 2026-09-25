<?php
function tokenCheckout($valor) {
    if (!is_string($valor) || !preg_match('/^[a-f0-9]{32}$/D', $valor)) throw new InvalidArgumentException('Identificador de compra inválido');
    return $valor;
}
function facturaCheckout($conexion, $usuarioID, $token) {
    $consulta = $conexion->prepare('SELECT F.* FROM Facturas F INNER JOIN Ordenes O ON O.OrdenID = F.OrdenID WHERE F.NumeroFactura = ? AND O.UsuarioID = ?');
    $consulta->execute(['TA-' . $token, $usuarioID]);
    return $consulta->fetch(PDO::FETCH_ASSOC);
}
function resumenCheckout($conexion, $usuarioID, $factura) {
    $consulta = $conexion->prepare('SELECT O.*, CONCAT(U.Nombres, " ", U.Apellidos) AS Cliente, U.Correo FROM Ordenes O INNER JOIN Usuarios U ON U.UsuarioID = O.UsuarioID WHERE O.OrdenID = ? AND O.UsuarioID = ?');
    $consulta->execute([$factura['OrdenID'], $usuarioID]);
    $pedido = $consulta->fetch(PDO::FETCH_ASSOC);
    $pedido['Detalles'] = obtenerDetallesOrden($conexion, $pedido['OrdenID']);
    $consulta = $conexion->prepare('SELECT MetodoPago, Estado FROM Pagos WHERE OrdenID = ? ORDER BY PagoID LIMIT 1');
    $consulta->execute([$pedido['OrdenID']]);
    $pago = $consulta->fetch(PDO::FETCH_ASSOC);
    $pedido['MetodoPago'] = $pago['MetodoPago'] ?? 'Sin pago registrado';
    $pedido['EstadoPago'] = $pago['Estado'] ?? 'Pendiente';
    $meta = json_decode($factura['Notas'] ?? '', true) ?: [];
    $pedido['CorreoEstado'] = $meta['correo'] ?? 'pendiente';
    unset($factura['Notas']);
    $pedido['Factura'] = $factura;
    return $pedido;
}
function direccionCheckout($conexion, $usuarioID, $datos, $campo) {
    $id = $datos[$campo . 'ID'] ?? null;
    if ($id !== null && $id !== '') {
        if (!validarEntero($id)) throw new InvalidArgumentException('Dirección inválida');
        $consulta = $conexion->prepare('SELECT Direccion, Ciudad, Subnacional, Pais, CodigoPostal FROM Direcciones WHERE DireccionID = ? AND UsuarioID = ?');
        $consulta->execute([$id, $usuarioID]);
        $direccion = $consulta->fetch(PDO::FETCH_ASSOC);
        if (!$direccion) throw new InvalidArgumentException('La dirección seleccionada no pertenece a tu cuenta');
        $texto = implode(', ', array_filter($direccion, fn($valor) => $valor !== null && $valor !== ''));
    } else $texto = is_string($datos[$campo] ?? null) ? trim($datos[$campo]) : null;
    if (!validarTexto($texto, 255)) throw new InvalidArgumentException('Completa las direcciones de envío y facturación (máximo 255 caracteres)');
    return $texto;
}
function realizarCheckout($conexion, $usuarioID, $datos) {
    $token = tokenCheckout($datos['SolicitudID'] ?? null);
    $permitidos = ['SolicitudID', 'NombreFactura', 'NIT', 'DireccionEnvio', 'DireccionPago', 'DireccionEnvioID', 'DireccionPagoID', 'MetodoPago', 'Detalles'];
    if (array_diff(array_keys($datos), $permitidos)) throw new InvalidArgumentException('El pedido contiene campos no permitidos');
    foreach (['NombreFactura', 'NIT'] as $campo) {
        if (!is_string($datos[$campo] ?? null)) throw new InvalidArgumentException('Completa nombre y NIT de facturación');
        $datos[$campo] = trim($datos[$campo]);
    }
    if (!validarTexto($datos['NombreFactura'], 150) || !validarTexto($datos['NIT'], 20) || !in_array($datos['MetodoPago'] ?? null, ['Efectivo', 'Transferencia'], true)) throw new InvalidArgumentException('Datos de facturación o forma de pago inválidos');
    if (!isset($datos['Detalles']) || !is_array($datos['Detalles']) || !array_is_list($datos['Detalles']) || count($datos['Detalles']) < 1 || count($datos['Detalles']) > 100) throw new InvalidArgumentException('El carrito debe contener entre 1 y 100 productos');
    $detalles = [];
    foreach ($datos['Detalles'] as $detalle) {
        if (!is_array($detalle) || !validarEntero($detalle['ProductoID'] ?? null) || !validarEntero($detalle['Cantidad'] ?? null) || !validarMonto($detalle['PrecioEsperado'] ?? null) || array_diff(array_keys($detalle), ['ProductoID', 'Cantidad', 'PrecioEsperado'])) throw new InvalidArgumentException('Producto, cantidad o precio de revisión inválidos');
        $id = (int)$detalle['ProductoID'];
        if (isset($detalles[$id])) throw new InvalidArgumentException('No repita productos en el carrito');
        $detalles[$id] = ['ProductoID' => $id, 'Cantidad' => (int)$detalle['Cantidad'], 'PrecioEsperado' => bcadd((string)$detalle['PrecioEsperado'], '0', 2)];
    }
    ksort($detalles);
    $datos['Detalles'] = array_values($detalles);
    ksort($datos);
    $huella = hash('sha256', json_encode($datos, JSON_UNESCAPED_UNICODE));
    $conexion->beginTransaction();
    try {
        // Serializa intentos del mismo usuario, también desde sesiones distintas.
        $consulta = $conexion->prepare("SELECT UsuarioID FROM Usuarios WHERE UsuarioID = ? AND Estado = 'Activo' FOR UPDATE");
        $consulta->execute([$usuarioID]);
        if (!$consulta->fetch()) throw new DomainException('La cuenta ya no está activa');
        $anterior = facturaCheckout($conexion, $usuarioID, $token);
        if ($anterior) {
            $meta = json_decode($anterior['Notas'] ?? '', true) ?: [];
            if (($meta['huella'] ?? '') !== $huella) throw new DomainException('Este intento ya fue registrado con otros datos. Consulta tus órdenes antes de volver a comprar');
            $conexion->commit();
            return ['nuevo' => false, 'pedido' => resumenCheckout($conexion, $usuarioID, $anterior)];
        }
        $envio = direccionCheckout($conexion, $usuarioID, $datos, 'DireccionEnvio');
        $pago = direccionCheckout($conexion, $usuarioID, $datos, 'DireccionPago');
        $categorias = array_column(categoriasCatalogo($conexion), 'CategoriaID');
        $promociones = promocionesCatalogo($conexion);
        $total = '0.00';
        foreach ($detalles as $id => &$detalle) {
            $consulta = $conexion->prepare('SELECT ProductoID, CategoriaID, Nombre, Precio, Cantidad, Estado FROM Productos WHERE ProductoID = ? FOR UPDATE');
            $consulta->execute([$id]);
            $producto = $consulta->fetch(PDO::FETCH_ASSOC);
            if (!$producto || $producto['Estado'] !== 'Activo' || !in_array($producto['CategoriaID'], $categorias)) throw new DomainException('Uno de los productos ya no está disponible. Actualiza el carrito');
            if ($producto['Cantidad'] < $detalle['Cantidad']) throw new DomainException('Existencias insuficientes para ' . $producto['Nombre']);
            $precio = precioCatalogo($producto, $promociones)['PrecioVenta'];
            if (bccomp($precio, $detalle['PrecioEsperado'], 2) !== 0) throw new DomainException('El precio de ' . $producto['Nombre'] . ' cambió. Actualiza el carrito y revisa el total');
            $detalle['PrecioUnitario'] = $precio;
            $detalle['Subtotal'] = bcmul($precio, (string)$detalle['Cantidad'], 2);
            $total = bcadd($total, $detalle['Subtotal'], 2);
            if (bccomp($total, '99999999.99', 2) > 0) throw new InvalidArgumentException('El total supera el máximo permitido');
        }
        unset($detalle);
        $ordenID = crearOrden($conexion, ['UsuarioID' => $usuarioID, 'DireccionEnvio' => $envio, 'DireccionPago' => $pago, 'Subtotal' => $total, 'Total' => $total]);
        foreach ($detalles as $detalle) {
            crearDetalleOrden($conexion, $ordenID, $detalle);
            cambiarExistenciasOrden($conexion, $detalle['ProductoID'], -$detalle['Cantidad']);
        }
        $facturaID = crearFactura($conexion, ['OrdenID' => $ordenID, 'NumeroFactura' => 'TA-' . $token, 'Nombre' => $datos['NombreFactura'], 'NIT' => $datos['NIT'], 'Direccion' => $pago, 'Subtotal' => $total, 'ImpuestoTotal' => '0.00', 'DescuentoTotal' => '0.00', 'Total' => $total, 'Estado' => 'Emitida', 'Notas' => json_encode(['huella' => $huella, 'correo' => 'pendiente'])]);
        foreach (obtenerDetallesOrden($conexion, $ordenID) as $detalle) crearDetalleFactura($conexion, $facturaID, $detalle);
        crearPago($conexion, ['OrdenID' => $ordenID, 'Monto' => $total, 'MetodoPago' => $datos['MetodoPago'], 'ReferenciaPago' => null, 'Notas' => null, 'Estado' => 'Pendiente']);
        $conexion->commit();
    } catch (Throwable $error) {
        if ($conexion->inTransaction()) $conexion->rollBack();
        throw $error;
    }
    $factura = facturaCheckout($conexion, $usuarioID, $token);
    $pedido = resumenCheckout($conexion, $usuarioID, $factura);
    // El correo se intenta únicamente después del commit; su fallo no deshace la compra.
    $estadoCorreo = enviarCorreoPedido($pedido);
    try {
        $consulta = $conexion->prepare('UPDATE Facturas SET Notas = ? WHERE FacturaID = ?');
        $consulta->execute([json_encode(['huella' => $huella, 'correo' => $estadoCorreo]), $facturaID]);
    } catch (Throwable $error) { error_log('No se pudo actualizar el estado de correo del pedido ' . (int)$ordenID); }
    $pedido['CorreoEstado'] = $estadoCorreo;
    return ['nuevo' => true, 'pedido' => $pedido];
}
