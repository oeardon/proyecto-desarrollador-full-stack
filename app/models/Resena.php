<?php
require_once __DIR__ . '/../services/ResenasMongo.php';
require_once __DIR__ . '/../services/ImagenesResena.php';

function obtenerTodosResenas($conexion, $ProductoID = null, $administrador = false) {
    $filter = $administrador ? [] : ['Estado' => 'Publicada'];
    if ($ProductoID !== null) $filter['ProductoID'] = (int)$ProductoID;
    return consultarResenasMongo($filter);
}
function obtenerResenaPorId($conexion, $ResenaID) {
    $rows = consultarResenasMongo(['ResenaID' => (int)$ResenaID], true);
    return $rows[0] ?? false;
}
function usuarioComproProducto($conexion, $UsuarioID, $ProductoID) {
    $stmt = $conexion->prepare("SELECT COUNT(*) FROM Ordenes O INNER JOIN DetalleOrdenes D ON D.OrdenID = O.OrdenID WHERE O.UsuarioID = :UsuarioID AND D.ProductoID = :ProductoID AND O.Estado = 'Entregada'");
    $stmt->execute([':UsuarioID' => $UsuarioID, ':ProductoID' => $ProductoID]);
    return (int)$stmt->fetchColumn() > 0;
}
function crearResena($conexion, $UsuarioID, $datos) {
    return ejecutarResenasMongo(function($database) use ($UsuarioID, $datos) {
        // Safe with concurrent requests and with existing imported numeric IDs.
        prepararResenasMongo($database);
        $counter = $database->selectCollection('Contadores')->findOneAndUpdate(
            ['_id' => 'Resenas'], ['$inc' => ['secuencia' => 1]],
            ['returnDocument' => MongoDB\Operation\FindOneAndUpdate::RETURN_DOCUMENT_AFTER]);
        $id = (int)$counter['secuencia'];
        $database->selectCollection('Resenas')->insertOne([
            'ResenaID' => $id, 'UsuarioID' => (int)$UsuarioID, 'ProductoID' => (int)$datos['ProductoID'],
            'Calificacion' => (int)$datos['Calificacion'], 'Comentario' => $datos['Comentario'] ?? null,
            'FechaResena' => new MongoDB\BSON\UTCDateTime(), 'Estado' => 'Publicada',
            'Imagenes' => $datos['Imagenes'] ?? [], 'Version' => 0,
        ]);
        return $id;
    });
}
function actualizarResena($conexion, $ResenaID, $datos) {
    return ejecutarResenasMongo(function($database) use ($ResenaID, $datos) {
        $filtro = ['ResenaID' => (int)$ResenaID];
        $version = (int)($datos['Version'] ?? 0);
        if ($version === 0) $filtro['$or'] = [['Version' => 0], ['Version' => ['$exists' => false]]];
        else $filtro['Version'] = $version;
        $resultado = $database->selectCollection('Resenas')->updateOne($filtro,
            ['$set' => ['Calificacion' => (int)$datos['Calificacion'], 'Comentario' => $datos['Comentario'], 'Imagenes' => $datos['Imagenes'] ?? []], '$inc' => ['Version' => 1]]);
        if (!$resultado->getMatchedCount()) throw new DomainException('La reseña cambió. Vuelva a cargarla antes de guardar.');
        return true;
    });
}

function moderarResena($conexion, $ResenaID, $Estado) {
    return ejecutarResenasMongo(fn($database) => $database->selectCollection('Resenas')->updateOne(
        ['ResenaID' => (int)$ResenaID], ['$set' => ['Estado' => $Estado]]
    )->getMatchedCount() > 0);
}
function eliminarResena($conexion, $ResenaID) {
    $anterior = ejecutarResenasMongo(fn($database) => $database->selectCollection('Resenas')->findOneAndDelete(['ResenaID' => (int)$ResenaID]));
    if (!$anterior) return false;
    eliminarImagenesResena(array_values((array)($anterior['Imagenes'] ?? [])));
    return true;
}
