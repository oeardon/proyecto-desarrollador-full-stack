<?php
// Actualización puntual de imágenes del catálogo de demostración; ejecutar solo por CLI.
if (PHP_SAPI !== 'cli') { http_response_code(404); exit; }
$modo = $argv[1] ?? '--verificar';
if (!in_array($modo, ['--verificar', '--aplicar', '--revertir'], true)) {
    fwrite(STDERR, "Uso: php database/actualizar_imagenes_productos.php [--verificar|--aplicar|--revertir]\n");
    exit(2);
}
try {
    $filas = json_decode(file_get_contents(__DIR__ . '/imagenes_productos.json'), true, 512, JSON_THROW_ON_ERROR);
    if (!is_array($filas) || !$filas) { throw new RuntimeException('El manifiesto está vacío.'); }
    require __DIR__ . '/../config/database.php';
    if (!isset($conexion) || !($conexion instanceof PDO)) { throw new RuntimeException('Conexión no disponible.'); }
    $conexion->beginTransaction();
    $consulta = $conexion->prepare('SELECT SKU, Nombre, Imagen FROM Productos WHERE ProductoID = ? FOR UPDATE');
    $actualizar = $conexion->prepare('UPDATE Productos SET Imagen = ? WHERE ProductoID = ?');
    $pendientes = [];
    $vistos = [];
    foreach ($filas as $fila) {
        $id = $fila['ProductoID'];
        if (isset($vistos[$id])) { throw new RuntimeException("ID duplicado en manifiesto: $id"); }
        $vistos[$id] = true;
        if ($fila['ImagenAnterior'] === $fila['ImagenNueva']) { continue; }
        $consulta->execute([$id]);
        $actual = $consulta->fetch();
        if (!$actual || $actual['SKU'] !== $fila['SKU'] || $actual['Nombre'] !== $fila['Nombre']) {
            throw new RuntimeException("Producto $id ausente o distinto del catálogo auditado; no se aplicó ningún cambio.");
        }
        $origen = $modo === '--revertir' ? $fila['ImagenNueva'] : $fila['ImagenAnterior'];
        $destino = $modo === '--revertir' ? $fila['ImagenAnterior'] : $fila['ImagenNueva'];
        if ($actual['Imagen'] === $destino) { continue; }
        if ($actual['Imagen'] !== $origen) {
            throw new RuntimeException("La imagen del producto $id cambió desde la auditoría; no se aplicó ningún cambio.");
        }
        if ($modo !== '--revertir' && str_starts_with($destino, '/productos/')) {
            $archivo = __DIR__ . '/../frontend/public' . $destino;
            if (!is_file($archivo) || @getimagesize($archivo) === false) {
                throw new RuntimeException("Imagen local ausente o inválida para el producto $id.");
            }
        }
        $pendientes[] = [$destino, $id];
    }
    if ($modo === '--verificar') {
        $conexion->rollBack();
        echo count($pendientes) . " imágenes pendientes. Verificación correcta; base de datos sin modificar.\n";
    } else {
        foreach ($pendientes as $cambio) { $actualizar->execute($cambio); }
        $conexion->commit();
        echo count($pendientes) . " imágenes " . ($modo === '--revertir' ? 'restauradas' : 'actualizadas') . ".\n";
    }
} catch (Throwable $error) {
    if (isset($conexion) && $conexion instanceof PDO && $conexion->inTransaction()) { $conexion->rollBack(); }
    fwrite(STDERR, $error->getMessage() . "\n");
    exit(1);
}
