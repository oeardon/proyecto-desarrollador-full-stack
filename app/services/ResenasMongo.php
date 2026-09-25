<?php
    require_once __DIR__ . '/../../config/mongodb.php';
    class ResenasNoDisponibles extends RuntimeException {}
    function ejecutarResenasMongo(callable $operacion) {
        try {
            return $operacion(conexionMongoDB());
        } catch (MongoDB\Driver\Exception\BulkWriteException $error) {
            if ($error->getCode() === 11000) throw new DomainException('Ya existe una reseña de este usuario para el producto');
            throw new ResenasNoDisponibles('Las reseñas no están disponibles temporalmente. Intenta nuevamente.');
        } catch (DomainException | InvalidArgumentException $error) {
            throw $error;
        } catch (Throwable $error) {
            throw new ResenasNoDisponibles('Las reseñas no están disponibles temporalmente. Intenta nuevamente.');
        }
    }

    function prepararResenasMongo($database) {
        $collection = $database->selectCollection('Resenas');
        $collection->createIndex(['ResenaID' => 1], ['unique' => true]);
        $collection->createIndex(['UsuarioID' => 1, 'ProductoID' => 1], ['unique' => true]);
        $collection->createIndex(['ProductoID' => 1, 'Estado' => 1]);
        $collection->createIndex(['UsuarioID' => 1, 'FechaResena' => -1]);
        $last = $collection->findOne([], ['sort' => ['ResenaID' => -1], 'projection' => ['ResenaID' => 1]]);
        $database->selectCollection('Contadores')->updateOne(['_id' => 'Resenas'],
            ['$max' => ['secuencia' => (int)($last['ResenaID'] ?? 0)]], ['upsert' => true]);
    }

    function presentarResenaMongo($document, $incluirUsuario = false) {
        $date = $document['FechaResena'];
        if ($date instanceof MongoDB\BSON\UTCDateTime) {
            $date = $date->toDateTime()->setTimezone(new DateTimeZone('America/Guatemala'))->format('Y-m-d H:i:s');
        }
        $result = ['ResenaID' => (int)$document['ResenaID'], 'ProductoID' => (int)$document['ProductoID'],
            'Calificacion' => (int)$document['Calificacion'], 'Comentario' => $document['Comentario'] ?? null,
            'FechaResena' => $date, 'Estado' => $document['Estado'],
            'Imagenes' => array_values((array)($document['Imagenes'] ?? []))];
        if ($incluirUsuario) { $result['UsuarioID'] = (int)$document['UsuarioID']; $result['Version'] = (int)($document['Version'] ?? 0); }
        return $result;
    }

    function consultarResenasMongo($filter, $incluirUsuario = false) {
        return ejecutarResenasMongo(function($database) use ($filter, $incluirUsuario) {
            $rows = [];
            foreach ($database->selectCollection('Resenas')->find($filter, ['sort' => ['ResenaID' => -1]]) as $document) {
                $rows[] = presentarResenaMongo($document, $incluirUsuario);
            }
            return $rows;
        });
    }

    function estadisticasResenasMongo() {
        return ejecutarResenasMongo(function($database) {
            $result = [];
            $pipeline = [
                ['$match' => ['Estado' => 'Publicada']],
                ['$group' => ['_id' => '$ProductoID', 'Calificacion' => ['$avg' => '$Calificacion'], 'Resenas' => ['$sum' => 1]]],
            ];
            foreach ($database->selectCollection('Resenas')->aggregate($pipeline) as $row) {
                $result[(int)$row['_id']] = ['Calificacion' => (float)$row['Calificacion'], 'Resenas' => (int)$row['Resenas']];
            }
            return $result;
        });
    }

    function exigirSinResenasMongo($campo, $id) {
        if (!in_array($campo, ['UsuarioID', 'ProductoID'], true)) throw new InvalidArgumentException('Referencia inválida');
        $exists = ejecutarResenasMongo(fn($database) => $database->selectCollection('Resenas')->findOne([$campo => (int)$id], ['projection' => ['_id' => 1]]));
        if ($exists) throw new DomainException('No se puede eliminar: existen reseñas relacionadas');
    }
?>