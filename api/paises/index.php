<?php
    header('Content-Type: application/json; charset=UTF-8');
    if ($_SERVER['REQUEST_METHOD'] !== 'GET') {
        header('Allow: GET');
        http_response_code(405);
        echo json_encode(['success' => false, 'message' => 'Método no permitido']);
        exit;
    }
    $lock = null;
    $locked = false;
    $refreshing = false;
    $temporary = null;
    try {
        $cache = sys_get_temp_dir() . '/tienda-paises-' . md5(__DIR__) . '.json';
        $lock = @fopen($cache . '.lock', 'c+');
        if (!$lock) throw new RuntimeException('Cache unavailable');
        $locked = flock($lock, LOCK_EX | LOCK_NB);
        if (!$locked) throw new RuntimeException('Refresh in progress');
        $countries = is_file($cache) && filemtime($cache) > time() - 86400
            ? json_decode(file_get_contents($cache), true) : null;
        if (!is_array($countries) || !$countries) {
            rewind($lock);
            if ((int)stream_get_contents($lock) > time()) throw new RuntimeException('Refresh cooldown');
            $deadline = (string)(time() + 180);
            rewind($lock);
            if (!ftruncate($lock, 0) || fwrite($lock, $deadline) !== strlen($deadline) || !fflush($lock)) {
                throw new RuntimeException('Cannot persist refresh deadline');
            }
            $refreshing = true;
            require __DIR__ . '/../../config/api_keys.php';
            $countries = [];
            for ($offset = 0; $offset < 1000; $offset += 100) {
                $url = 'https://api.restcountries.com/countries/v5?' . http_build_query([
                    'response_fields' => 'names.common,names.translations.spa.common,codes.alpha_2', 'limit' => 100, 'offset' => $offset,
                ]);
                $ch = curl_init($url);
                curl_setopt_array($ch, [CURLOPT_HTTPHEADER => ['Authorization: Bearer ' . $restCountriesApiKey],
                    CURLOPT_RETURNTRANSFER => true, CURLOPT_CONNECTTIMEOUT => 5, CURLOPT_TIMEOUT => 15]);
                $body = curl_exec($ch);
                $status = curl_getinfo($ch, CURLINFO_HTTP_CODE);
                curl_close($ch);
                if ($body === false || $status !== 200) throw new RuntimeException('Provider unavailable');
                $page = json_decode($body, true, 512, JSON_THROW_ON_ERROR)['data']['objects'] ?? null;
                if (!is_array($page)) throw new RuntimeException('Invalid response');
                foreach ($page as $country) {
                    $code = $country['names']['common'] ?? '';
                    if (!is_string($code) || $code === '' || isset($countries[$code])) throw new RuntimeException('Invalid pagination');
                    $countries[$code] = $country;
                }
                if (count($page) < 100) break;
            }
            if (!$countries || $offset >= 1000) throw new RuntimeException('Incomplete list');
            $countries = array_values($countries);
            $json = json_encode($countries, JSON_THROW_ON_ERROR);
            $temporary = @tempnam(dirname($cache), 'tienda-paises-');
            if ($temporary === false || @file_put_contents($temporary, $json) !== strlen($json)
                || !@rename($temporary, $cache)) {
                throw new RuntimeException('Cannot save countries cache');
            }
            $temporary = null;
            $refreshing = false;
        }
        echo json_encode(['success' => true, 'data' => $countries], JSON_UNESCAPED_UNICODE | JSON_THROW_ON_ERROR);
    } catch (Throwable $e) {
        if ($refreshing && $locked) {
            rewind($lock);
            $deadline = (string)(time() + 60);
            if (!ftruncate($lock, 0) || fwrite($lock, $deadline) !== strlen($deadline) || !fflush($lock)) {
                error_log('Countries API: cannot persist retry deadline.');
            }
        }
        error_log('Countries API: request failed (' . get_class($e) . ').');
        header('Retry-After: 60');
        http_response_code(503);
        echo json_encode(['success' => false, 'message' => 'No se pudo obtener el listado de países. Intenta nuevamente.']);
    } finally {
        if (is_string($temporary) && is_file($temporary)) @unlink($temporary);
        if ($locked) flock($lock, LOCK_UN);
        if (is_resource($lock)) fclose($lock);
    }
?>