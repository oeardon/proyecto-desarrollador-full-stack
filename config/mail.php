<?php
// Los valores privados se proporcionan mediante entorno o mail.local.php (ignorado por Git).
$config = [
    'enabled' => filter_var(getenv('SMTP_ENABLED') ?: 'false', FILTER_VALIDATE_BOOLEAN),
    'host' => getenv('SMTP_HOST') ?: 'smtp.gmail.com',
    'port' => (int)(getenv('SMTP_PORT') ?: 587),
    'username' => getenv('SMTP_USERNAME') ?: '',
    'password' => getenv('SMTP_PASSWORD') ?: '',
    'encryption' => getenv('SMTP_ENCRYPTION') ?: 'tls',
    'from' => getenv('SMTP_FROM') ?: '',
    'name' => getenv('SMTP_FROM_NAME') ?: 'TodoAquí',
];
$local = __DIR__ . '/mail.local.php';
if (is_file($local)) $config = array_replace($config, require $local);
return $config;
