<?php
// Recursos auxiliares de administración. Los documentos conservan sus controladores.
session_start();
header('Content-Type: application/json; charset=UTF-8');
header('Cache-Control: no-store');
require_once __DIR__ . '/../respuestas.php';
require_once __DIR__ . '/../../app/controllers/Validaciones.php';
require_once __DIR__ . '/../../app/models/Sesion.php';
try {
    require __DIR__ . '/../../config/database.php';
    exigirAdministradorApi(exigirSesionApi($conexion));
    $recursos = [
        'productos-proveedores' => ['ProductosProveedores', ['ProductoID', 'ProveedorID'], ['ProductoID', 'ProveedorID', 'CostoCompra', 'EsPrincipal']],
        'productos-promociones' => ['ProductosPromociones', ['ProductoID', 'PromocionID'], ['ProductoID', 'PromocionID']],
        'lista-deseos' => ['ListaDeseos', ['UsuarioID', 'ProductoID'], ['UsuarioID', 'ProductoID']],
        'detalle-ordenes' => ['DetalleOrdenes', ['DetalleOrdenID'], []],
        'detalle-facturas' => ['DetalleFacturas', ['DetalleFacturaID'], []],
        'detalle-devoluciones' => ['DetalleDevoluciones', ['DetalleDevolucionID'], []],
    ];
    $recurso = $_GET['recurso'] ?? '';
    if (!is_string($recurso) || !isset($recursos[$recurso])) responderApi(404, ['success' => false, 'message' => 'Recurso no encontrado']);
    [$tabla, $claves, $campos] = $recursos[$recurso];
    $metodo = $_SERVER['REQUEST_METHOD'];
    $permitidos = ['GET', 'POST', 'PUT', 'DELETE'];
    if (!in_array($metodo, $permitidos, true)) {
        header('Allow: ' . implode(', ', $permitidos));
        responderApi(405, ['success' => false, 'message' => 'Método no permitido']);
    }
    $ids = [];
    $individual = count(array_intersect($claves, array_keys($_GET))) > 0 || in_array($metodo, ['PUT', 'DELETE'], true);
    if ($individual) foreach ($claves as $clave) $ids[] = leerIdApi($clave);
    $where = implode(' AND ', array_map(fn($clave) => "`$clave` = ?", $claves));
    if ($metodo === 'GET') {
        $consulta = $conexion->prepare("SELECT * FROM `$tabla`" . ($individual ? " WHERE $where" : '') . ' ORDER BY ' . implode(', ', $claves));
        $consulta->execute($ids);
        $datos = $individual ? $consulta->fetch(PDO::FETCH_ASSOC) : $consulta->fetchAll(PDO::FETCH_ASSOC);
        if ($individual && !$datos) responderApi(404, ['success' => false, 'message' => 'Registro no encontrado']);
        responderApi(200, ['success' => true, 'data' => $datos]);
    }
    $datos = $metodo !== 'DELETE' ? leerDatosApi() : [];
    if (!$campos) {
        require_once __DIR__ . '/../../app/controllers/DetalleAdminController.php';
        $id = modificarDetalleAdmin($conexion, $recurso, $metodo, $ids[0] ?? null, $datos);
        responderApi($metodo === 'POST' ? 201 : 200, ['success' => true, 'id' => $id, 'message' => $metodo === 'DELETE' ? 'Detalle eliminado correctamente' : 'Detalle guardado correctamente']);
    }
    if (array_diff(array_keys($datos), $campos)) throw new InvalidArgumentException('Campos no permitidos');
    if ($metodo !== 'DELETE') {
        foreach ($claves as $clave) if (!validarEntero($datos[$clave] ?? null)) throw new InvalidArgumentException("$clave debe ser un entero positivo");
        if ($recurso === 'productos-proveedores') {
            $datos['CostoCompra'] = $datos['CostoCompra'] ?? null;
            $datos['EsPrincipal'] = $datos['EsPrincipal'] ?? 0;
            if ($datos['CostoCompra'] !== null && !validarMonto($datos['CostoCompra'])) throw new InvalidArgumentException('Costo de compra inválido');
            if (!in_array($datos['EsPrincipal'], [0, 1, true, false], true)) throw new InvalidArgumentException('Indicador de proveedor principal inválido');
            $datos['EsPrincipal'] = (int) $datos['EsPrincipal'];
        }
    }
    $conexion->beginTransaction();
    try {
        if ($individual) {
            $consulta = $conexion->prepare("SELECT * FROM `$tabla` WHERE $where FOR UPDATE");
            $consulta->execute($ids);
            if (!$consulta->fetch()) {
                $conexion->rollBack();
                responderApi(404, ['success' => false, 'message' => 'Registro no encontrado']);
            }
        }
        if ($metodo === 'DELETE') {
            $consulta = $conexion->prepare("DELETE FROM `$tabla` WHERE $where");
            $consulta->execute($ids);
        } else {
            $valores = array_map(fn($campo) => $datos[$campo], $campos);
            if ($metodo === 'POST') {
                $columnas = implode(', ', $campos);
                $marcas = implode(', ', array_fill(0, count($campos), '?'));
                $consulta = $conexion->prepare("INSERT INTO `$tabla` ($columnas) VALUES ($marcas)");
                $consulta->execute($valores);
            } else {
                $asignaciones = implode(', ', array_map(fn($campo) => "`$campo` = ?", $campos));
                $consulta = $conexion->prepare("UPDATE `$tabla` SET $asignaciones WHERE $where");
                $consulta->execute(array_merge($valores, $ids));
            }
        }
        $conexion->commit();
    } catch (Throwable $e) {
        if ($conexion->inTransaction()) $conexion->rollBack();
        throw $e;
    }
    responderApi($metodo === 'POST' ? 201 : 200, ['success' => true, 'message' => $metodo === 'DELETE' ? 'Registro eliminado correctamente' : 'Registro guardado correctamente']);
} catch (Throwable $e) {
    responderErrorApi($e);
}
