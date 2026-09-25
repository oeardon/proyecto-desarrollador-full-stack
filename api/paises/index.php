<?php
header('Content-Type: application/json; charset=UTF-8');
if ($_SERVER['REQUEST_METHOD'] !== 'GET') {
    header('Allow: GET');
    http_response_code(405);
    echo json_encode(['success' => false, 'message' => 'Método no permitido']);
    exit;
}
try {
    // Cache outside the public directory; only complete lists are cached.
    $cache = sys_get_temp_dir() . '/tienda-paises-' . md5(__DIR__) . '.json';
    $lock = fopen($cache . '.lock', 'c');
    if (!$lock || !flock($lock, LOCK_EX)) throw new RuntimeException('Cache unavailable');
    $countries = is_file($cache) && filemtime($cache) > time() - 86400
        ? json_decode(file_get_contents($cache), true) : null;
    if (!is_array($countries) || !$countries) {
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
        file_put_contents($cache, json_encode($countries, JSON_THROW_ON_ERROR), LOCK_EX);
    }
    flock($lock, LOCK_UN);
    fclose($lock);
    echo json_encode(['success' => true, 'data' => $countries], JSON_UNESCAPED_UNICODE | JSON_THROW_ON_ERROR);
} catch (Throwable $e) {
    http_response_code(503);
    echo json_encode(['success' => false, 'message' => 'No se pudo obtener el listado de países. Intenta nuevamente.']);
}
