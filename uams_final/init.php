<?php
// init.php — сессия, язык, утилиты (+ optional UI texts/help/menu from MySQL)
session_start();

$supported_langs = [
  'ru' => 'Русский',
  'kz' => 'Қазақша',
  'en' => 'English'
];

// set language from ?lang=..
if (isset($_GET['lang'])) {
  $l = strtolower(trim((string)$_GET['lang']));
  if (isset($supported_langs[$l])) {
    $_SESSION['lang'] = $l;
  }
}

$lang = $_SESSION['lang'] ?? 'ru';
if (!isset($supported_langs[$lang])) {
  $lang = 'ru';
}

// Fallback словари (используются, если UI-таблицы еще не импортированы)
$T = require __DIR__ . '/lang/' . $lang . '.php';

// UI-кэш (подсказки/онбординг/меню) — загружается из MySQL, если таблицы существуют.
$UI = [
  'bootstrapped' => false,
  'texts' => [],
  'help' => [],
  'onboarding' => [],
  'menu' => []
];

function h(string $s): string {
  return htmlspecialchars($s, ENT_QUOTES | ENT_SUBSTITUTE, 'UTF-8');
}

function t(string $key): string {
  global $T, $UI;
  if (!empty($UI['texts']) && array_key_exists($key, $UI['texts'])) {
    return (string)$UI['texts'][$key];
  }
  return $T[$key] ?? $key;
}

function ui_help(string $context): ?string {
  global $UI;
  return $UI['help'][$context] ?? null;
}

function ui_onboarding(string $route): ?string {
  global $UI;
  return $UI['onboarding'][$route] ?? null;
}

function is_active(string $file): string {
  $cur = basename(parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH));
  return $cur === $file ? 'active' : '';
}

function ui_table_exists(PDO $pdo, string $table): bool {
  $st = $pdo->prepare('SELECT 1 FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = ? LIMIT 1');
  $st->execute([$table]);
  return (bool)$st->fetchColumn();
}

// Загружаем UI-меню/тексты/подсказки из MySQL.
// Вызывайте после подключения $pdo (обычно в header.php).
function ui_bootstrap(PDO $pdo): void {
  global $UI, $lang;
  if ($UI['bootstrapped']) return;

  // Texts
  if (ui_table_exists($pdo, 'ui_texts')) {
    $col = ($lang === 'kz') ? 'kz' : (($lang === 'en') ? 'en' : 'ru');
    $st = $pdo->query("SELECT `key_name`, `$col` AS v FROM ui_texts");
    foreach ($st->fetchAll(PDO::FETCH_ASSOC) as $row) {
      if ($row['key_name'] === null) continue;
      $UI['texts'][(string)$row['key_name']] = (string)($row['v'] ?? '');
    }
  }

  // Help
  if (ui_table_exists($pdo, 'ui_help')) {
    $col = ($lang === 'kz') ? 'kz' : (($lang === 'en') ? 'en' : 'ru');
    $st = $pdo->query("SELECT `context`, `$col` AS v FROM ui_help");
    foreach ($st->fetchAll(PDO::FETCH_ASSOC) as $row) {
      if ($row['context'] === null) continue;
      $UI['help'][(string)$row['context']] = (string)($row['v'] ?? '');
    }
  }

  // Onboarding
  if (ui_table_exists($pdo, 'ui_onboarding')) {
    $col = ($lang === 'kz') ? 'kz' : (($lang === 'en') ? 'en' : 'ru');
    $st = $pdo->query("SELECT `route`, `$col` AS v FROM ui_onboarding");
    foreach ($st->fetchAll(PDO::FETCH_ASSOC) as $row) {
      if ($row['route'] === null) continue;
      $UI['onboarding'][(string)$row['route']] = (string)($row['v'] ?? '');
    }
  }

  // Menu
  if (ui_table_exists($pdo, 'ui_menu')) {
    $st = $pdo->query('SELECT id, parent_id, route, icon, title_key, sort_order, is_active FROM ui_menu WHERE is_active = 1 ORDER BY sort_order, id');
    $flat = $st->fetchAll(PDO::FETCH_ASSOC);
    $by_parent = [];
    foreach ($flat as $it) {
      $p = $it['parent_id'] ?? 0;
      if ($p === null) $p = 0;
      $by_parent[(int)$p][] = $it;
    }
    $build = function($parent) use (&$build, &$by_parent) {
      $out = [];
      foreach ($by_parent[(int)$parent] ?? [] as $it) {
        $it['children'] = $build((int)$it['id']);
        $out[] = $it;
      }
      return $out;
    };
    $UI['menu'] = $build(0);
  }

  $UI['bootstrapped'] = true;
}
