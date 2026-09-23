<?php
function obtenerTodosResenas($conexion, $ProductoID = null, $administrador = false) {
     $condiciones = [];
     $parametros = [];
     if (!$administrador) $condiciones[] = "Estado = 'Publicada'";
     if ($ProductoID !== null) {
          $condiciones[] = "ProductoID = :ProductoID";
          $parametros[":ProductoID"] = $ProductoID;
     }
     $sql = "SELECT ResenaID, ProductoID, Calificacion, Comentario, FechaResena, Estado FROM Resenas";
     if ($condiciones) $sql .= " WHERE " . implode(" AND ", $condiciones);
     $stmt = $conexion->prepare($sql . " ORDER BY ResenaID DESC");
     $stmt->execute($parametros);
     return $stmt->fetchAll();
}
function obtenerResenaPorId($conexion, $ResenaID) {
     $stmt = $conexion->prepare("SELECT * FROM Resenas WHERE ResenaID = :ResenaID");
     $stmt->execute([":ResenaID" => $ResenaID]);
     return $stmt->fetch();
}
function usuarioComproProducto($conexion, $UsuarioID, $ProductoID) {
     $stmt = $conexion->prepare("SELECT COUNT(*) FROM Ordenes O INNER JOIN DetalleOrdenes D ON D.OrdenID = O.OrdenID WHERE O.UsuarioID = :UsuarioID AND D.ProductoID = :ProductoID AND O.Estado = 'Entregada'");
     $stmt->execute([":UsuarioID" => $UsuarioID, ":ProductoID" => $ProductoID]);
     return (int) $stmt->fetchColumn() > 0;
}
function crearResena($conexion, $UsuarioID, $datos) {
     $stmt = $conexion->prepare("INSERT INTO Resenas (UsuarioID, ProductoID, Calificacion, Comentario) VALUES (:UsuarioID, :ProductoID, :Calificacion, :Comentario)");
     $stmt->execute([":UsuarioID" => $UsuarioID, ":ProductoID" => $datos["ProductoID"], ":Calificacion" => $datos["Calificacion"], ":Comentario" => $datos["Comentario"] ?? null]);
     return $conexion->lastInsertId();
}
function actualizarResena($conexion, $ResenaID, $datos) {
     $stmt = $conexion->prepare("UPDATE Resenas SET Calificacion = :Calificacion, Comentario = :Comentario WHERE ResenaID = :ResenaID");
     return $stmt->execute([":Calificacion" => $datos["Calificacion"], ":Comentario" => $datos["Comentario"], ":ResenaID" => $ResenaID]);
}
function moderarResena($conexion, $ResenaID, $Estado) {
     $stmt = $conexion->prepare("UPDATE Resenas SET Estado = :Estado WHERE ResenaID = :ResenaID");
     return $stmt->execute([":Estado" => $Estado, ":ResenaID" => $ResenaID]);
}
function eliminarResena($conexion, $ResenaID) {
     $stmt = $conexion->prepare("DELETE FROM Resenas WHERE ResenaID = :ResenaID");
     $stmt->execute([":ResenaID" => $ResenaID]);
     return $stmt->rowCount() > 0;
}
