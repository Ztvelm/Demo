<?php
require_once __DIR__ . '/../init.php';
// Ensure DB is available for dynamic UI (menu/text/help)
if (!isset($pdo)) {
  require_once __DIR__ . '/../db.php';
}
try { ui_bootstrap($pdo); } catch (Throwable $e) { /* fallback to local lang files */ }

// Build menu items (from DB if present, otherwise fallback)
$menu_items = [];
if (!empty($UI['menu'])) {
  foreach ($UI['menu'] as $it) {
    $menu_items[] = [
      'route' => $it['route'],
      'icon' => $it['icon'] ?? '',
      'title' => t((string)$it['title_key'])
    ];
  }
} else {
  $menu_items = [
    ['route' => '/index.php', 'icon' => '🏠', 'title' => t('nav_dashboard')],
    ['route' => '/questions.php', 'icon' => '❓', 'title' => t('nav_questions')],
    ['route' => '/import_csv.php', 'icon' => '⬆️', 'title' => t('nav_import')],
  ];
}
?>
<!doctype html>
<html lang="<?=h($lang)?>">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width,initial-scale=1">
  <title><?= isset($page_title) ? h($page_title).' — ' : '' ?><?=h(t('app_name'))?></title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="/assets/app.css">
</head>
<body>
<div class="d-flex">
  <aside class="sidebar">
    <div class="brand">
      <div class="title"><?=h(t('app_name'))?></div>
      <div class="subtitle"><?=h(t('app_subtitle'))?></div>
    </div>
    <nav class="nav-side">
      <?php foreach ($menu_items as $mi):
        $file = basename($mi['route']);
      ?>
        <a class="<?=is_active($file)?>" href="<?=h($mi['route'])?>"><?=h($mi['icon'])?> <?=h($mi['title'])?></a>
      <?php endforeach; ?>
    </nav>
  </aside>

  <main class="content">
    <div class="topbar d-flex align-items-center justify-content-between">
      <div class="fw-semibold"><?= isset($page_title) ? h($page_title) : h(t('app_subtitle')) ?></div>
      <div class="d-flex align-items-center gap-2">
        <span class="small-muted">🌐</span>
        <form method="get" class="m-0">
          <select class="form-select form-select-sm" name="lang" onchange="this.form.submit()" style="width:auto">
            <?php foreach ($supported_langs as $code => $label): ?>
              <option value="<?=h($code)?>" <?= $lang===$code ? 'selected' : '' ?>><?=h($label)?></option>
            <?php endforeach; ?>
          </select>
        </form>
      </div>
    </div>

    <div class="container-fluid py-4">

      <?php
        $route = basename(parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH));
        $ob = ui_onboarding($route);
        if ($ob):
      ?>
        <div class="alert alert-info small mb-3"><?= $ob ?></div>
      <?php endif; ?>
