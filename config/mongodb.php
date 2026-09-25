<?php
    function conexionMongoDB() {
        static $database;
        if ($database !== null) return $database;
        require_once __DIR__ . '/../vendor/autoload.php';
        $uri = getenv('MONGODB_URI');
        if (!$uri) {
            require __DIR__ . '/api_keys.php';
            $uri = $mongoURI ?? '';
        }
        if (!is_string($uri) || trim($uri) === '') throw new RuntimeException('MongoDB no está configurado');
        $client = new MongoDB\Client($uri, [
            'serverSelectionTimeoutMS' => 3000, 'connectTimeoutMS' => 3000, 'socketTimeoutMS' => 5000,
        ], ['typeMap' => ['root' => 'array', 'document' => 'array', 'array' => 'array']]);
        $database = $client->selectDatabase(getenv('MONGODB_DATABASE') ?: 'todoaqui_db');
        return $database;
    }
?>