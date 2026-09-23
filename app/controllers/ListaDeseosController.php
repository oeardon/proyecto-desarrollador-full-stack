<?php
     function listarListaDeseos($conexion, $UsuarioID) {
          return obtenerListaDeseos($conexion, $UsuarioID);
     }
     function buscarDeseo($conexion, $UsuarioID, $ProductoID) {
          return obtenerDeseoPorProducto($conexion, $UsuarioID, $ProductoID);
     }
     function agregarDeseo($conexion, $UsuarioID, $datos) {
          if (!validarEntero($datos["ProductoID"] ?? null)) throw new InvalidArgumentException("ID de producto inválido");
          return crearDeseo($conexion, $UsuarioID, $datos["ProductoID"]);
     }
     function quitarDeseo($conexion, $UsuarioID, $ProductoID) {
          return eliminarDeseo($conexion, $UsuarioID, $ProductoID);
     }
?>