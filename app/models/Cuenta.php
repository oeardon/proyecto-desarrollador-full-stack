<?php
// Consultas del panel personal: el propietario siempre procede de la sesión.
function consultarCuenta($conexion, $sql, $parametros) {
    $consulta = $conexion->prepare($sql);
    $consulta->execute($parametros);
    return $consulta->fetchAll(PDO::FETCH_ASSOC);
}

function obtenerPerfilCuenta($conexion, $usuarioID) {
    $filas = consultarCuenta($conexion, "SELECT Nombres, Apellidos, Correo, Telefono, Usuario FROM Usuarios WHERE UsuarioID = ?", [$usuarioID]);
    return $filas[0] ?? null;
}

function actualizarPerfilCuenta($conexion, $usuarioID, $datos) {
    $permitidos = ['Nombres', 'Apellidos', 'Correo', 'Telefono', 'Usuario', 'Contrasena'];
    if (array_diff(array_keys($datos), $permitidos)) throw new InvalidArgumentException('Solo puede editar los campos de su perfil');
    if (($datos['Contrasena'] ?? null) === '') unset($datos['Contrasena']);
    if (isset($datos['Contrasena']) && (!is_string($datos['Contrasena']) || str_contains($datos['Contrasena'], "\0"))) {
        throw new InvalidArgumentException('Contraseña inválida');
    }
    foreach (['Nombres', 'Apellidos', 'Correo', 'Telefono', 'Usuario'] as $campo) {
        if (isset($datos[$campo]) && is_string($datos[$campo])) $datos[$campo] = trim($datos[$campo]);
    }
    $datos = prepararDatosUsuario($datos, obtenerPerfilCuenta($conexion, $usuarioID));
    $sql = 'UPDATE Usuarios SET Nombres = ?, Apellidos = ?, Correo = ?, Telefono = ?, Usuario = ?';
    $parametros = array_map(fn($campo) => $datos[$campo], array_slice($permitidos, 0, 5));
    if ($datos['Contrasena'] !== null) {
        $sql .= ', Contrasena = ?';
        $parametros[] = $datos['Contrasena'];
    }
    $parametros[] = $usuarioID;
    $consulta = $conexion->prepare($sql . ' WHERE UsuarioID = ?');
    $consulta->execute($parametros);
    $_SESSION['Usuario'] = $datos['Usuario'];
}

function obtenerOrdenCuenta($conexion, $usuarioID, $id) {
    $filas = consultarCuenta($conexion, 'SELECT * FROM Ordenes WHERE OrdenID = ? AND UsuarioID = ?', [$id, $usuarioID]);
    if (!$filas) return null;
    $orden = $filas[0];
    $orden['Detalles'] = obtenerDetallesOrden($conexion, $id);
    foreach ($orden['Detalles'] as &$detalle) {
        $detalle['CantidadDisponibleDevolucion'] = max(0, (int)$detalle['Cantidad'] - cantidadDevueltaDetalle($conexion, $detalle['DetalleOrdenID']));
    }
    unset($detalle);
    $orden['Facturas'] = consultarCuenta($conexion, 'SELECT FacturaID, NumeroFactura, FechaEmision, Nombre, NIT, Direccion, Subtotal, ImpuestoTotal, DescuentoTotal, Total, Estado FROM Facturas WHERE OrdenID = ? ORDER BY FacturaID DESC', [$id]);
    foreach ($orden['Facturas'] as &$factura) {
        $factura['Detalles'] = consultarCuenta($conexion, 'SELECT Descripcion, Cantidad, PrecioUnitario, Descuento, Impuesto, Subtotal FROM DetalleFacturas WHERE FacturaID = ?', [$factura['FacturaID']]);
    }
    unset($factura);
    $orden['Pagos'] = consultarCuenta($conexion, 'SELECT PagoID, FechaPago, Monto, MetodoPago, ReferenciaPago, Estado FROM Pagos WHERE OrdenID = ? ORDER BY PagoID DESC', [$id]);
    return $orden;
}

function obtenerResenasCuenta($conexion, $usuarioID) {
    return consultarCuenta($conexion, 'SELECT R.ResenaID, R.ProductoID, R.Calificacion, R.Comentario, R.FechaResena, R.Estado, P.Nombre AS Producto FROM Resenas R INNER JOIN Productos P ON P.ProductoID = R.ProductoID WHERE R.UsuarioID = ? ORDER BY R.FechaResena DESC', [$usuarioID]);
}

function obtenerDevolucionCuenta($conexion, $usuarioID, $id) {
    $filas = consultarCuenta($conexion, 'SELECT D.DevolucionID, D.OrdenID, D.FechaSolicitud, D.Motivo, D.Estado, D.MontoReembolso FROM Devoluciones D INNER JOIN Ordenes O ON O.OrdenID = D.OrdenID WHERE D.DevolucionID = ? AND O.UsuarioID = ?', [$id, $usuarioID]);
    if (!$filas) return null;
    $devolucion = $filas[0];
    $devolucion['Detalles'] = consultarCuenta($conexion, 'SELECT DD.Cantidad, DD.Motivo, DD.MontoReembolso, P.Nombre AS Producto FROM DetalleDevoluciones DD INNER JOIN DetalleOrdenes DO ON DO.DetalleOrdenID = DD.DetalleOrdenID INNER JOIN Productos P ON P.ProductoID = DO.ProductoID WHERE DD.DevolucionID = ?', [$id]);
    return $devolucion;
}
