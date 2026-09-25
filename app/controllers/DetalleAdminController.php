<?php
    // Operaciones de líneas: bloqueo de la orden antes del documento y sus detalles.
    function consultaDetalleAdmin($db, $sql, $params = []) {
        $stmt = $db->prepare($sql);
        $stmt->execute($params);
        return $stmt;
    }
    function modificarDetalleAdmin($db, $recurso, $metodo, $id, $datos) {
        $mapa = ['detalle-ordenes' => ['DetalleOrdenes', 'DetalleOrdenID', 'Ordenes', 'OrdenID', 'ProductoID', ['OrdenID', 'ProductoID', 'Cantidad']],
                 'detalle-facturas' => ['DetalleFacturas', 'DetalleFacturaID', 'Facturas', 'FacturaID', 'DetalleOrdenID', ['FacturaID', 'DetalleOrdenID', 'Cantidad', 'Descripcion']],
                 'detalle-devoluciones' => ['DetalleDevoluciones', 'DetalleDevolucionID', 'Devoluciones', 'DevolucionID', 'DetalleOrdenID', ['DevolucionID', 'DetalleOrdenID', 'Cantidad', 'Motivo']],
        ];
        [$tabla, $pk, $padre, $fk, $referencia, $permitidos] = $mapa[$recurso];
        if (array_diff(array_keys($datos), $permitidos)) throw new InvalidArgumentException('Campos no permitidos');
        if ($metodo !== 'DELETE') {
            foreach ([$fk, $referencia, 'Cantidad'] as $campo) if (!validarEntero($datos[$campo] ?? null)) throw new InvalidArgumentException("$campo debe ser un entero positivo");
            if ($recurso === 'detalle-facturas' && !validarTexto($datos['Descripcion'] ?? null, 255)) throw new InvalidArgumentException('Descripción obligatoria');
            if ($recurso === 'detalle-devoluciones' && !validarTexto($datos['Motivo'] ?? null, 255, true)) throw new InvalidArgumentException('Motivo inválido');
        }
        // Leer el estado más reciente después de esperar por el bloqueo de la orden.
        $db->exec('SET TRANSACTION ISOLATION LEVEL READ COMMITTED');
        $db->beginTransaction();
        try {
            $anterior = $id ? consultaDetalleAdmin($db, "SELECT * FROM $tabla WHERE $pk = ?", [$id])->fetch(PDO::FETCH_ASSOC) : null;
            if ($id && !$anterior) throw new DomainException('El detalle ya no existe');
            $padreID = $anterior[$fk] ?? $datos[$fk];
            if ($anterior && $metodo !== 'DELETE' && ((int)$datos[$fk] !== (int)$padreID || (int)$datos[$referencia] !== (int)$anterior[$referencia])) throw new InvalidArgumentException('No se puede cambiar el documento ni la referencia de una línea existente');
            $documento = consultaDetalleAdmin($db, "SELECT * FROM $padre WHERE $fk = ?", [$padreID])->fetch(PDO::FETCH_ASSOC);
            if (!$documento) throw new InvalidArgumentException('Documento no encontrado');
            $ordenID = $documento['OrdenID'];
            $orden = consultaDetalleAdmin($db, 'SELECT * FROM Ordenes WHERE OrdenID = ? FOR UPDATE', [$ordenID])->fetch(PDO::FETCH_ASSOC);
            $documento = consultaDetalleAdmin($db, "SELECT * FROM $padre WHERE $fk = ? FOR UPDATE", [$padreID])->fetch(PDO::FETCH_ASSOC);
            if (!$orden || !$documento) throw new DomainException('Documento no disponible');
            if ($id) {
                $anterior = consultaDetalleAdmin($db, "SELECT * FROM $tabla WHERE $pk = ? FOR UPDATE", [$id])->fetch(PDO::FETCH_ASSOC);
                if (!$anterior) throw new DomainException('El detalle ya no existe');
            }
            $cantidadLineas = (int) consultaDetalleAdmin($db, "SELECT COUNT(*) FROM $tabla WHERE $fk = ?", [$padreID])->fetchColumn();
            if ($metodo === 'DELETE' && $cantidadLineas <= 1) throw new DomainException('El documento debe conservar al menos una línea');
            if ($metodo === 'POST' && $cantidadLineas >= 100) throw new DomainException('El documento admite hasta 100 líneas');
            $nuevo = [];
            if ($recurso === 'detalle-ordenes') {
                if ($orden['Estado'] !== 'Pendiente') throw new DomainException('Solo se pueden modificar líneas de órdenes pendientes');
                foreach (['Pagos', 'Facturas', 'Devoluciones'] as $relacion) {
                    if (consultaDetalleAdmin($db, "SELECT COUNT(*) FROM $relacion WHERE OrdenID = ?", [$ordenID])->fetchColumn()) throw new DomainException('La orden ya tiene pagos, facturas o devoluciones vinculadas');
                }
                foreach (['DescuentoTotal', 'ImpuestoTotal', 'CostoEnvio'] as $cargo) if (bccomp($orden[$cargo], '0', 2) !== 0) throw new DomainException('La orden tiene cargos que requieren un desglose adicional');
                if (consultaDetalleAdmin($db, 'SELECT COUNT(*) FROM DetalleOrdenes WHERE OrdenID = ? AND Descuento <> 0', [$ordenID])->fetchColumn()) throw new DomainException('La orden contiene descuentos que requieren un desglose adicional');
                $productoID = $anterior['ProductoID'] ?? $datos['ProductoID'];
                $producto = consultaDetalleAdmin($db, 'SELECT * FROM Productos WHERE ProductoID = ? FOR UPDATE', [$productoID])->fetch(PDO::FETCH_ASSOC);
                if (!$producto) throw new InvalidArgumentException('Producto inexistente');
                $cantidad = $metodo === 'DELETE' ? 0 : (int)$datos['Cantidad'];
                $diferencia = $cantidad - (int)($anterior['Cantidad'] ?? 0);
                if ($diferencia > 0 && ($producto['Estado'] !== 'Activo' || $producto['Cantidad'] < $diferencia)) throw new DomainException('Producto inactivo o existencias insuficientes');
                if ($metodo === 'POST' && consultaDetalleAdmin($db, 'SELECT COUNT(*) FROM DetalleOrdenes WHERE OrdenID = ? AND ProductoID = ?', [$ordenID, $productoID])->fetchColumn()) throw new DomainException('El producto ya está en la orden; edite su cantidad');
                consultaDetalleAdmin($db, 'UPDATE Productos SET Cantidad = Cantidad - ? WHERE ProductoID = ?', [$diferencia, $productoID]);
                $precio = $anterior['PrecioUnitario'] ?? $producto['Precio'];
                $nuevo = ['OrdenID' => $ordenID, 'ProductoID' => $productoID, 'Cantidad' => $cantidad, 'PrecioUnitario' => $precio, 'Descuento' => '0.00', 'Subtotal' => bcmul($precio, (string)$cantidad, 2)];
            } else {
                $estado = $recurso === 'detalle-facturas' ? 'Emitida' : 'Solicitada';
                if ($documento['Estado'] !== $estado) throw new DomainException("El documento debe estar en estado $estado");
                if ($recurso === 'detalle-facturas') {
                    if ($orden['Estado'] !== 'Pendiente') throw new DomainException('Solo se pueden ajustar facturas de órdenes pendientes');
                    if (consultaDetalleAdmin($db, 'SELECT COUNT(*) FROM Pagos WHERE OrdenID = ?', [$ordenID])->fetchColumn()) throw new DomainException('La orden facturada ya tiene pagos vinculados');
                }
                if ($recurso === 'detalle-devoluciones' && $orden['Estado'] !== 'Entregada') throw new DomainException('La orden debe estar entregada');
                if ($metodo !== 'DELETE') {
                    $original = consultaDetalleAdmin($db, 'SELECT * FROM DetalleOrdenes WHERE DetalleOrdenID = ? AND OrdenID = ? FOR UPDATE', [$datos['DetalleOrdenID'], $ordenID])->fetch(PDO::FETCH_ASSOC);
                    if (!$original) throw new InvalidArgumentException('El detalle no pertenece a la orden del documento');
                    $cantidad = (int)$datos['Cantidad'];
                    if ($cantidad > $original['Cantidad']) throw new DomainException('La cantidad supera la línea original');
                    $nuevo = [$fk => $padreID, 'DetalleOrdenID' => $datos['DetalleOrdenID'], 'Cantidad' => $cantidad];
                    if ($recurso === 'detalle-devoluciones') {
                        $reservada = consultaDetalleAdmin($db, "SELECT COALESCE(SUM(L.Cantidad), 0) FROM DetalleDevoluciones L JOIN Devoluciones D ON D.DevolucionID = L.DevolucionID WHERE L.DetalleOrdenID = ? AND D.Estado <> 'Rechazada' AND L.DetalleDevolucionID <> ?", [$datos['DetalleOrdenID'], $id ?? 0])->fetchColumn();
                        if ($cantidad + $reservada > $original['Cantidad']) throw new DomainException('La cantidad supera lo disponible para devolver');
                        $nuevo['Motivo'] = $datos['Motivo'] ?? null;
                        $nuevo['MontoReembolso'] = bcmul(bcdiv($original['Subtotal'], (string)$original['Cantidad'], 4), (string)$cantidad, 2);
                    } else {
                        $nuevo['Descripcion'] = $datos['Descripcion'];
                        $nuevo['PrecioUnitario'] = $original['PrecioUnitario'];
                        $nuevo['Descuento'] = bcmul(bcdiv($original['Descuento'], (string)$original['Cantidad'], 4), (string)$cantidad, 2);
                        $nuevo['Impuesto'] = '0.00';
                        $nuevo['Subtotal'] = bcsub(bcmul($original['PrecioUnitario'], (string)$cantidad, 2), $nuevo['Descuento'], 2);
                        if (bccomp($documento['ImpuestoTotal'], '0', 2) !== 0) throw new DomainException('La factura contiene impuestos que requieren un desglose adicional');
                    }
                }
            }
            if ($metodo === 'DELETE') {
                consultaDetalleAdmin($db, "DELETE FROM $tabla WHERE $pk = ?", [$id]);
            } elseif ($metodo === 'POST') {
                $campos = implode(', ', array_keys($nuevo));
                $marcas = implode(', ', array_fill(0, count($nuevo), '?'));
                consultaDetalleAdmin($db, "INSERT INTO $tabla ($campos) VALUES ($marcas)", array_values($nuevo));
                $id = $db->lastInsertId();
            } else {
                $campos = implode(', ', array_map(fn($campo) => "$campo = ?", array_keys($nuevo)));
                consultaDetalleAdmin($db, "UPDATE $tabla SET $campos WHERE $pk = ?", array_merge(array_values($nuevo), [$id]));
            }
            if ($recurso === 'detalle-devoluciones') {
                consultaDetalleAdmin($db, 'UPDATE Devoluciones SET MontoReembolso = (SELECT COALESCE(SUM(MontoReembolso),0) FROM DetalleDevoluciones WHERE DevolucionID = ?) WHERE DevolucionID = ?', [$padreID, $padreID]);
            } elseif ($recurso === 'detalle-ordenes') {
                $suma = consultaDetalleAdmin($db, 'SELECT SUM(Subtotal) FROM DetalleOrdenes WHERE OrdenID = ?', [$padreID])->fetchColumn();
                consultaDetalleAdmin($db, 'UPDATE Ordenes SET Subtotal = ?, Total = ? WHERE OrdenID = ?', [$suma, $suma, $padreID]);
            } else {
                $sumas = consultaDetalleAdmin($db, 'SELECT SUM(Cantidad * PrecioUnitario) AS Base, SUM(Descuento) AS Descuentos, SUM(Impuesto) AS Impuestos, SUM(Subtotal + Impuesto) AS Total FROM DetalleFacturas WHERE FacturaID = ?', [$padreID])->fetch(PDO::FETCH_ASSOC);
                consultaDetalleAdmin($db, 'UPDATE Facturas SET Subtotal = ?, DescuentoTotal = ?, ImpuestoTotal = ?, Total = ? WHERE FacturaID = ?', [$sumas['Base'], $sumas['Descuentos'], $sumas['Impuestos'], $sumas['Total'], $padreID]);
            }
            $db->commit();
            return $id;
        } catch (Throwable $e) {
            if ($db->inTransaction()) $db->rollBack();
            throw $e;
        }
    }
?>