<?php
    session_start();
    header('Content-Type: application/json; charset=UTF-8');
    header('Cache-Control: no-store');
    require_once __DIR__ . '/../respuestas.php';
    require_once __DIR__ . '/../../app/controllers/Validaciones.php';
    require_once __DIR__ . '/../../app/models/Sesion.php';
    require_once __DIR__ . '/../../app/controllers/UsuarioController.php';
    require_once __DIR__ . '/../../app/models/Direccion.php';
    require_once __DIR__ . '/../../app/controllers/DireccionController.php';
    require_once __DIR__ . '/../../app/models/Orden.php';
    require_once __DIR__ . '/../../app/models/Devolucion.php';
    require_once __DIR__ . '/../../app/controllers/DevolucionController.php';
    require_once __DIR__ . '/../../app/models/ListaDeseos.php';
    require_once __DIR__ . '/../../app/models/Cuenta.php';
    try {
        $recurso = $_GET['recurso'] ?? 'perfil';
        $metodos = ['perfil' => ['GET', 'PUT'],
                    'direcciones' => ['GET', 'POST', 'PUT', 'DELETE'],
                    'ordenes' => ['GET'],
                    'lista-deseos' => ['GET', 'DELETE'],
                    'resenas' => ['GET'],
                    'productos-resenables' => ['GET'],
                    'devoluciones' => ['GET', 'POST']];
        if (!is_string($recurso) || !isset($metodos[$recurso])) responderApi(404, ['success' => false, 'message' => 'Sección no encontrada']);
        $metodo = $_SERVER['REQUEST_METHOD'];
        if (!in_array($metodo, $metodos[$recurso], true)) {
            header('Allow: ' . implode(', ', $metodos[$recurso]));
            responderApi(405, ['success' => false, 'message' => 'Método no permitido']);
        }
        require __DIR__ . '/../../config/database.php';
        $usuario = exigirSesionApi($conexion);
        $usuarioID = $usuario['UsuarioID'];
        $id = isset($_GET['id']) ? leerIdApi() : null;
        $resultado = null;
        if ($recurso === 'perfil') {
            if ($metodo === 'PUT') actualizarPerfilCuenta($conexion, $usuarioID, leerDatosApi());
            $resultado = obtenerPerfilCuenta($conexion, $usuarioID);
        } elseif ($recurso === 'direcciones') {
            $registro = $id !== null ? obtenerDireccionPorId($conexion, $id) : null;
            if ($id !== null && (!$registro || $registro['UsuarioID'] != $usuarioID)) responderApi(404, ['success' => false, 'message' => 'Dirección no encontrada']);
            if (in_array($metodo, ['PUT', 'DELETE'], true) && $id === null) leerIdApi();
            if ($metodo === 'GET') $resultado = $id !== null ? $registro : obtenerTodosDirecciones($conexion, $usuarioID);
            if ($metodo === 'POST' || $metodo === 'PUT') {
                $datos = leerDatosApi();
                $datos['UsuarioID'] = $usuarioID;
                if ($metodo === 'POST') {
                    $id = agregarDireccion($conexion, $datos);
                    responderApi(201, ['success' => true, 'DireccionID' => $id, 'message' => 'Dirección agregada']);
                }
                editarDireccion($conexion, $id, $datos);
            }
            if ($metodo === 'DELETE') quitarDireccion($conexion, $id);
        } elseif ($recurso === 'ordenes') {
            $resultado = $id !== null ? obtenerOrdenCuenta($conexion, $usuarioID, $id) : obtenerTodosOrdenes($conexion, $usuarioID);
        } elseif ($recurso === 'lista-deseos') {
            if ($metodo === 'GET') $resultado = obtenerListaDeseos($conexion, $usuarioID);
            else {
                if (!eliminarDeseo($conexion, $usuarioID, leerIdApi())) responderApi(404, ['success' => false, 'message' => 'Producto no encontrado en su lista']);
            }
        } elseif ($recurso === 'productos-resenables') {
            $resultado = consultarCuenta($conexion, "SELECT DISTINCT P.ProductoID, P.Nombre FROM Productos P INNER JOIN DetalleOrdenes D ON D.ProductoID = P.ProductoID INNER JOIN Ordenes O ON O.OrdenID = D.OrdenID WHERE O.UsuarioID = ? AND O.Estado = 'Entregada' ORDER BY P.Nombre", [$usuarioID]);
        } elseif ($recurso === 'resenas') {
            $resultado = obtenerResenasCuenta($conexion, $usuarioID);
        } elseif ($recurso === 'devoluciones') {
            if ($metodo === 'GET') {
                $resultado = $id !== null ? obtenerDevolucionCuenta($conexion, $usuarioID, $id) : consultarCuenta($conexion, 'SELECT D.DevolucionID, D.OrdenID, D.FechaSolicitud, D.Motivo, D.Estado, D.MontoReembolso FROM Devoluciones D INNER JOIN Ordenes O ON O.OrdenID = D.OrdenID WHERE O.UsuarioID = ? ORDER BY D.DevolucionID DESC', [$usuarioID]);
            } else {
                $datos = leerDatosApi();
                if (!validarEntero($datos['OrdenID'] ?? null)) throw new InvalidArgumentException('Orden inválida');
                $orden = consultarCuenta($conexion, 'SELECT OrdenID FROM Ordenes WHERE OrdenID = ? AND UsuarioID = ?', [$datos['OrdenID'], $usuarioID]);
                if (!$orden) responderApi(404, ['success' => false, 'message' => 'Orden no encontrada']);
                $id = agregarDevolucion($conexion, array_intersect_key($datos, array_flip(['OrdenID', 'Motivo', 'Detalles'])));
                responderApi(201, ['success' => true, 'DevolucionID' => $id, 'message' => 'Devolución solicitada']);
            }
        }
        if ($metodo === 'GET' && $resultado === null) responderApi(404, ['success' => false, 'message' => 'Registro no encontrado']);
        responderApi(200, ['success' => true, 'data' => $resultado, 'message' => 'Operación completada']);
    } catch (Throwable $error) {
        responderErrorApi($error);
    }
?>