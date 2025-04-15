<?php 
session_start();

echo 'testsite2'.PHP_EOL;

if(!isset($_SESSION['admin'])){
$_SESSION['admin'] = 'Hello Admin';
}

var_dump($_SESSION);


try {
    $redis = new Redis();
    $redis->connect('redis', 6379);
    echo "Подключение к Redis успешно!";
} catch (RedisException $e) {
    echo "Ошибка подключения: " . $e->getMessage();
}

// example: добавление данных
$redis->set('example_key', 'Hello, Redis!');

// example: получение данных
$value = $redis->get('example_key');
echo "Значение по ключу 'example_key': " . $value;

// Не забудьте закрыть соединение при необходимости
$redis->close();