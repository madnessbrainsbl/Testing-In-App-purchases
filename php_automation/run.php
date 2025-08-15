<?php

require_once __DIR__ . '/vendor/autoload.php';
require_once __DIR__ . '/file.php';

// Замените эти значения на реальные
$controller = new VkAuthController();

// Установите реальные данные перед запуском
// В file.php измените:
// $login = 'ВАШ_НОМЕР_ТЕЛЕФОНА';
// $password = 'ВАШ_ПАРОЛЬ';
// $twoFactorCode = 'КОД_2FA';

$result = $controller->actionTest();
echo "Result code: " . $result . PHP_EOL;
