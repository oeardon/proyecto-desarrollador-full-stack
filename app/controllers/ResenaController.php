<?php
function listarResenas($conexion, $ProductoID = null, $administrador = false) {
     return obtenerTodosResenas($conexion, $ProductoID, $administrador);
}
function buscarResena($conexion, $ResenaID) {
     return obtenerResenaPorId($conexion, $ResenaID);
}
function agregarResena($conexion, $UsuarioID, $datos) {
     if (array_diff(array_keys($datos), ["ProductoID", "Calificacion", "Comentario"])) {
          throw new InvalidArgumentException("Esta versión admite ProductoID, Calificacion y Comentario; título e imágenes requieren ampliar el esquema");
     }
     if (!validarEntero($datos["ProductoID"] ?? null) || !validarEntero($datos["Calificacion"] ?? null, 1, 5) ||
         !validarTexto($datos["Comentario"] ?? null, 10000, true)) throw new InvalidArgumentException("Producto, calificación o comentario inválidos");
     if (!usuarioComproProducto($conexion, $UsuarioID, $datos["ProductoID"])) throw new DomainException("Solo puede reseñar productos de sus órdenes entregadas");
     return crearResena($conexion, $UsuarioID, $datos);
}
function editarResena($conexion, $ResenaID, $datos, $administrador = false) {
     $actual = obtenerResenaPorId($conexion, $ResenaID);
     if (!$actual) return false;
     if ($administrador && array_keys($datos) === ["Estado"]) {
          if (!validarOpcion($datos["Estado"], ["Publicada", "Oculta"])) throw new InvalidArgumentException("Estado de reseña inválido");
          return moderarResena($conexion, $ResenaID, $datos["Estado"]);
     }
     if (!$datos || array_diff(array_keys($datos), ["Calificacion", "Comentario"])) throw new InvalidArgumentException("Solo puede editar calificación y comentario");
     $datos = array_merge($actual, $datos);
     if (!validarEntero($datos["Calificacion"], 1, 5) || !validarTexto($datos["Comentario"], 10000, true)) throw new InvalidArgumentException("Calificación o comentario inválidos");
     return actualizarResena($conexion, $ResenaID, $datos);
}
function quitarResena($conexion, $ResenaID) {
     return eliminarResena($conexion, $ResenaID);
}
