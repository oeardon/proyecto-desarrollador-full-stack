<?php
     function listarResenas($conexion, $ProductoID = null, $administrador = false) {
          return obtenerTodosResenas($conexion, $ProductoID, $administrador);
     }
     function buscarResena($conexion, $ResenaID) {
          return obtenerResenaPorId($conexion, $ResenaID);
     }
     function agregarResena($conexion, $UsuarioID, $datos, $archivos = []) {
          if (array_diff(array_keys($datos), ["ProductoID", "Calificacion", "Comentario", "Imagenes"])) {
               throw new InvalidArgumentException("Campos de reseña no admitidos");
          }
          if (!validarEntero($datos["ProductoID"] ?? null) || !validarEntero($datos["Calificacion"] ?? null, 1, 5) ||
              !validarTexto($datos["Comentario"] ?? null, 10000, true)) throw new InvalidArgumentException("Producto, calificación o comentario inválidos");
          if (!usuarioComproProducto($conexion, $UsuarioID, $datos["ProductoID"])) throw new DomainException("Solo puede reseñar productos de sus órdenes entregadas");
          $imagenes = prepararImagenesResena([], $datos, $archivos);
          $datos['Imagenes'] = $imagenes['Imagenes'];
          try { return crearResena($conexion, $UsuarioID, $datos); }
          catch (Throwable $error) { deshacerImagenesResena($imagenes['nuevas'], $error); throw $error; }
     }
     function editarResena($conexion, $ResenaID, $datos, $administrador = false, $archivos = []) {
          $actual = obtenerResenaPorId($conexion, $ResenaID);
          if (!$actual) return false;
          if ($administrador && array_keys($datos) === ["Estado"] && !$archivos) {
               if (!validarOpcion($datos["Estado"], ["Publicada", "Oculta"])) throw new InvalidArgumentException("Estado de reseña inválido");
               return moderarResena($conexion, $ResenaID, $datos["Estado"]);
          }
          if (!$datos || array_diff(array_keys($datos), ["Calificacion", "Comentario", "Imagenes"])) throw new InvalidArgumentException("Solo puede editar calificación, comentario e imágenes");
          $datos = array_merge($actual, $datos);
          if (!validarEntero($datos["Calificacion"], 1, 5) || !validarTexto($datos["Comentario"], 10000, true)) throw new InvalidArgumentException("Calificación o comentario inválidos");
          $imagenes = prepararImagenesResena($actual['Imagenes'] ?? [], $datos, $archivos);
          $datos['Imagenes'] = $imagenes['Imagenes'];
          try { $resultado = actualizarResena($conexion, $ResenaID, $datos); }
          catch (Throwable $error) { deshacerImagenesResena($imagenes['nuevas'], $error); throw $error; }
          eliminarImagenesResena($imagenes['eliminadas']);
          return $resultado;
     }
     function quitarResena($conexion, $ResenaID) {
          return eliminarResena($conexion, $ResenaID);
     }
?>