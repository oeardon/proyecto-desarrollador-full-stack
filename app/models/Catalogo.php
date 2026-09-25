<?php
require_once __DIR__ . '/../services/ResenasMongo.php';
function categoriasCatalogo($conexion) {
    $filas = $conexion->query("SELECT CategoriaID, CategoriaPadreID, Nombre, Descripcion FROM Categorias WHERE Estado = 'Activo' ORDER BY Nombre")->fetchAll(PDO::FETCH_ASSOC);
    $mapa = array_column($filas, null, 'CategoriaID');
    return array_values(array_filter($filas, function($fila) use ($mapa) {
        $vistos = [];
        while ($fila['CategoriaPadreID'] !== null) {
            $padre = $fila['CategoriaPadreID'];
            if (!isset($mapa[$padre]) || isset($vistos[$padre])) return false;
            $vistos[$padre] = true;
            $fila = $mapa[$padre];
        }
        return true;
    }));
}
function promocionesCatalogo($conexion) {
    return $conexion->query("SELECT M.*, PP.ProductoID FROM Promociones M LEFT JOIN ProductosPromociones PP ON PP.PromocionID = M.PromocionID WHERE M.Estado = 'Activo' AND M.RequiereCupon = 0 AND M.FechaInicio <= NOW() AND (M.FechaFin IS NULL OR M.FechaFin >= NOW()) ORDER BY M.PromocionID")->fetchAll(PDO::FETCH_ASSOC);
}
function precioCatalogo($producto, $promociones) {
    $precio = $producto['Precio'];
    $nombre = null;
    foreach ($promociones as $promocion) {
        if (!$promocion['AplicaTodosProductos'] && $promocion['ProductoID'] != $producto['ProductoID']) continue;
        $descuento = $promocion['TipoDescuento'] === 'Porcentaje'
            ? bcdiv(bcmul($producto['Precio'], $promocion['ValorDescuento'], 4), '100', 2)
            : $promocion['ValorDescuento'];
        $candidato = bcsub($producto['Precio'], $descuento, 2);
        if (bccomp($candidato, '0', 2) < 0) $candidato = '0.00';
        if (bccomp($candidato, $precio, 2) < 0) { $precio = $candidato; $nombre = $promocion['Nombre']; }
    }
    return ['PrecioVenta' => $precio, 'Promocion' => $nombre];
}
function productosCatalogo($conexion, $categorias) {
    $productos = $conexion->query("SELECT P.*, C.Nombre AS Categoria,
        COALESCE(V.Vendidos, 0) AS Vendidos
        FROM Productos P INNER JOIN Categorias C ON C.CategoriaID = P.CategoriaID
        LEFT JOIN (SELECT D.ProductoID, SUM(D.Cantidad) AS Vendidos FROM DetalleOrdenes D INNER JOIN Ordenes O ON O.OrdenID = D.OrdenID WHERE O.Estado IN ('Confirmada','Procesando','Enviada','Entregada') GROUP BY D.ProductoID) V ON V.ProductoID = P.ProductoID
        WHERE P.Estado = 'Activo' ORDER BY P.Nombre")->fetchAll(PDO::FETCH_ASSOC);
    $resenasDisponibles = true;
    try { $stats = estadisticasResenasMongo(); }
    catch (ResenasNoDisponibles $error) { $stats = []; $resenasDisponibles = false; }
    $ids = array_column($categorias, 'CategoriaID');
    $promociones = promocionesCatalogo($conexion);
    $resultado = [];
    foreach ($productos as $producto) {
        if (!in_array($producto['CategoriaID'], $ids)) continue;
        $rating = $resenasDisponibles ? ($stats[(int)$producto['ProductoID']] ?? ['Calificacion' => 0, 'Resenas' => 0]) : ['Calificacion' => null, 'Resenas' => null];
        $resultado[] = array_merge($producto, precioCatalogo($producto, $promociones), $rating, ['ResenasDisponibles' => $resenasDisponibles]);
    }
    return $resultado;
}
