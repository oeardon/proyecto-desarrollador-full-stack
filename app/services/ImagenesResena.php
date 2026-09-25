<?php
const PREFIJO_IMAGEN_RESENA = '/tienda_online/public/uploads/resenas/';

function archivosImagenesResena(): array {
    if (!isset($_FILES['Imagenes'])) return [];
    $grupo = $_FILES['Imagenes'];
    if (!is_array($grupo['error'] ?? null)) throw new InvalidArgumentException('Envíe las imágenes como Imagenes[].');
    $archivos = [];
    foreach ($grupo['error'] as $indice => $error) {
        if ($error === UPLOAD_ERR_NO_FILE) continue;
        if (!is_int($error) || !is_string($grupo['tmp_name'][$indice] ?? null)) throw new InvalidArgumentException('Archivo inválido.');
        $archivos[] = ['error' => $error, 'tmp_name' => $grupo['tmp_name'][$indice]];
    }
    return $archivos;
}
function eliminarImagenesResena(array $rutas): void {
    $config = require __DIR__ . '/../../config/imagenes.php';
    foreach ($rutas as $ruta) {
        if (!is_string($ruta) || !preg_match('~^' . preg_quote(PREFIJO_IMAGEN_RESENA, '~') . '(resena-[a-f0-9]{32}\.(?:jpg|png|webp))$~D', $ruta, $m)) continue;
        $archivo = $config['resenas_directorio'] . DIRECTORY_SEPARATOR . $m[1];
        if (is_file($archivo) && !@unlink($archivo)) error_log('No se pudo eliminar una imagen de reseña: ' . $m[1]);
    }
}
function prepararImagenesResena(array $actuales, array $datos, array $archivos): array {
    $conservar = $datos['Imagenes'] ?? $actuales;
    if (!is_array($conservar) || !array_is_list($conservar) || count($conservar) > 3) throw new InvalidArgumentException('Lista de imágenes inválida.');
    foreach ($conservar as $ruta) {
        if (!is_string($ruta) || !in_array($ruta, $actuales, true)) throw new InvalidArgumentException('Solo puede conservar imágenes de esta reseña.');
    }
    if (count(array_unique($conservar)) !== count($conservar) || count($conservar) + count($archivos) > 3) {
        throw new InvalidArgumentException('Cada reseña permite un máximo de 3 imágenes en total.');
    }
    $config = require __DIR__ . '/../../config/imagenes.php';
    $nuevas = [];
    try {
        foreach ($archivos as $archivo) {
            if (($archivo['error'] ?? null) !== UPLOAD_ERR_OK || !is_uploaded_file($archivo['tmp_name'])) throw new InvalidArgumentException('No se pudo recibir la imagen. Máximo 2 MB por archivo.');
            $temporal = $archivo['tmp_name'];
            if (!filesize($temporal) || filesize($temporal) > 2 * 1024 * 1024) throw new InvalidArgumentException('Cada imagen debe pesar como máximo 2 MB.');
            $mime = (new finfo(FILEINFO_MIME_TYPE))->file($temporal);
            $extensiones = ['image/jpeg' => 'jpg', 'image/png' => 'png', 'image/webp' => 'webp'];
            $medidas = @getimagesize($temporal);
            if (!isset($extensiones[$mime]) || !$medidas || $medidas['mime'] !== $mime || $medidas[0] * $medidas[1] > 20000000) {
                throw new InvalidArgumentException('Seleccione imágenes JPG, PNG o WebP válidas, de hasta 20 megapíxeles.');
            }
            $directorio = $config['resenas_directorio'];
            // Windows puede marcar la carpeta como solo lectura y permitir crear archivos.
            // move_uploaded_file verifica el permiso real y su resultado se comprueba abajo.
            if (!is_dir($directorio)) throw new RuntimeException('La carpeta de imágenes de reseñas no está disponible.');
            $nombre = 'resena-' . bin2hex(random_bytes(16)) . '.' . $extensiones[$mime];
            if (!move_uploaded_file($temporal, $directorio . DIRECTORY_SEPARATOR . $nombre)) throw new RuntimeException('No se pudo guardar la imagen.');
            $nuevas[] = PREFIJO_IMAGEN_RESENA . $nombre;
        }
    } catch (Throwable $error) { eliminarImagenesResena($nuevas); throw $error; }
    return ['Imagenes' => array_merge($conservar, $nuevas), 'nuevas' => $nuevas, 'eliminadas' => array_values(array_diff($actuales, $conservar))];
}
function deshacerImagenesResena(array $nuevas, Throwable $error): void {
    // Una caída de MongoDB puede ocurrir después de confirmar la escritura: conservar
    // el archivo evita romper una referencia cuyo resultado todavía es incierto.
    if ($error instanceof ResenasNoDisponibles) { error_log('Carga de imágenes con resultado MongoDB incierto; revisar archivos huérfanos.'); return; }
    eliminarImagenesResena($nuevas);
}
