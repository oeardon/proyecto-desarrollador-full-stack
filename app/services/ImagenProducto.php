<?php
function guardarImagenProducto(array $archivo): array {
    if (!isset($archivo['error']) || is_array($archivo['error']) || $archivo['error'] !== UPLOAD_ERR_OK) {
        throw new InvalidArgumentException('No se pudo recibir la imagen. Seleccione un archivo de hasta 5 MB.');
    }
    $temporal = $archivo['tmp_name'] ?? '';
    if (!is_string($temporal) || !is_uploaded_file($temporal)) throw new InvalidArgumentException('Archivo de imagen inválido.');
    $tamano = filesize($temporal);
    if (!$tamano || $tamano > 5 * 1024 * 1024) throw new InvalidArgumentException('La imagen debe pesar como máximo 5 MB.');
    $mime = (new finfo(FILEINFO_MIME_TYPE))->file($temporal);
    $extensiones = ['image/jpeg' => 'jpg', 'image/png' => 'png', 'image/webp' => 'webp'];
    $medidas = @getimagesize($temporal);
    if (!isset($extensiones[$mime]) || !$medidas || $medidas['mime'] !== $mime) {
        throw new InvalidArgumentException('Solo se permiten imágenes JPG, PNG o WebP válidas.');
    }
    if ($medidas[0] * $medidas[1] > 20000000) throw new InvalidArgumentException('La imagen no debe superar 20 megapíxeles.');
    $config = require __DIR__ . '/../../config/imagenes.php';
    $directorio = $config['directorio'];
    if (!is_dir($directorio) || !is_writable($directorio)) throw new RuntimeException('La carpeta de imágenes no está disponible para escritura.');
    $nombre = 'producto-' . bin2hex(random_bytes(16)) . '.' . $extensiones[$mime];
    $destino = $directorio . DIRECTORY_SEPARATOR . $nombre;
    if (!move_uploaded_file($temporal, $destino)) throw new RuntimeException('No se pudo guardar la imagen.');
    return ['ruta' => '/productos/' . $nombre, 'archivo' => $destino];
}

function guardarProductoConImagen(PDO $conexion, ?int $id, array $datos, ?array $archivo): int {
    $nuevo = null;
    $conexion->beginTransaction();
    try {
        // El bloqueo evita perder una sustitución de imagen realizada por otro administrador.
        $actual = null;
        if ($id !== null) {
            $consulta = $conexion->prepare('SELECT Imagen FROM Productos WHERE ProductoID = ? FOR UPDATE');
            $consulta->execute([$id]);
            $actual = $consulta->fetch();
            if (!$actual) throw new InvalidArgumentException('El producto ya no existe.');
        }
        $datos['Imagen'] = $actual['Imagen'] ?? null;
        if ($archivo !== null && ($archivo['error'] ?? null) !== UPLOAD_ERR_NO_FILE) {
            $nuevo = guardarImagenProducto($archivo);
            $datos['Imagen'] = $nuevo['ruta'];
        }
        if ($id === null) $id = (int) agregarProducto($conexion, $datos);
        elseif (!editarProducto($conexion, $id, $datos)) throw new RuntimeException('No se pudo actualizar el producto.');
        $conexion->commit();
        return $id;
    } catch (Throwable $error) {
        if ($conexion->inTransaction()) $conexion->rollBack();
        if ($nuevo !== null && is_file($nuevo['archivo'])) unlink($nuevo['archivo']);
        throw $error;
    }
}
