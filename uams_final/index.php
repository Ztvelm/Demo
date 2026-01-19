<?php
require_once __DIR__ . '/init.php';
$page_title = t('nav_dashboard');
require_once __DIR__ . '/db.php';
require_once __DIR__ . '/partials/header.php';

function scalar(PDO $pdo, string $sql, array $params = []) {
    $st = $pdo->prepare($sql);
    $st->execute($params);
    return $st->fetchColumn();
}

$total_questions = (int) scalar($pdo, 'SELECT COUNT(*) FROM questions');

// avg difficulty + avg correlation: prefer question_stats if present
$avg_difficulty = null;
$avg_corr = null;
$problems = 0;

try {
    $avg_difficulty = (float) scalar($pdo, 'SELECT AVG(difficulty_pct) FROM question_stats');
    // corr_with_total может быть NULL, берём среднее по не-NULL
    $avg_corr = (float) scalar($pdo, 'SELECT AVG(corr_with_total) FROM question_stats WHERE corr_with_total IS NOT NULL');
    // В текущей схеме flag: green/yellow/red. Считаем проблемными всё, что не green.
    $problems = (int) scalar($pdo, "SELECT COUNT(*) FROM question_stats WHERE flag IN ('yellow','red')");
} catch (Throwable $e) {
    // если таблицы/поля нет — оставим пусто
}

// Difficulty distribution (easy/medium/hard) — на основе difficulty_pct
$dist = ['easy'=>0,'medium'=>0,'hard'=>0];
try {
    $st = $pdo->query('SELECT difficulty_pct FROM question_stats WHERE difficulty_pct IS NOT NULL');
    foreach ($st->fetchAll(PDO::FETCH_COLUMN) as $v) {
        $v = (float)$v;
        if ($v >= 0.75) $dist['easy']++;      // высокий % правильных = легко
        elseif ($v >= 0.4) $dist['medium']++;
        else $dist['hard']++;
    }
} catch (Throwable $e) {
    // fallback: если нет stats — пусто
}

// Questions by discipline
$by_discipline = [];
try {
    $st = $pdo->query('SELECT d.name AS discipline, COUNT(*) AS cnt
                       FROM questions q
                       LEFT JOIN disciplines d ON d.discipline_id = q.discipline_id
                       GROUP BY d.name
                       ORDER BY cnt DESC
                       LIMIT 8');
    $by_discipline = $st->fetchAll(PDO::FETCH_ASSOC);
} catch (Throwable $e) {}

// Format
$avg_difficulty_str = ($avg_difficulty === null || is_nan($avg_difficulty)) ? '—' : number_format($avg_difficulty, 2);
$avg_corr_str = ($avg_corr === null || is_nan($avg_corr)) ? '—' : number_format($avg_corr, 2);

?>

<div class="row g-3">
  <div class="col-12 col-md-6 col-xl-3">
    <div class="card card-kpi p-3 bg-white">
      <div class="d-flex justify-content-between align-items-center">
        <div>
          <div class="kpi-label">
            <?=h(t('kpi_total_questions'))?>
            <?php if ($txt = ui_help('kpi_total_questions')): ?>
              <span class="ms-1 text-muted" data-bs-toggle="tooltip" title="<?=h($txt)?>">ⓘ</span>
            <?php endif; ?>
          </div>
          <div class="kpi-value"><?=h((string)$total_questions)?></div>
        </div>
        <div class="rounded-3 p-3" style="background:#dbeafe">❓</div>
      </div>
    </div>
  </div>
  <div class="col-12 col-md-6 col-xl-3">
    <div class="card card-kpi p-3 bg-white">
      <div class="d-flex justify-content-between align-items-center">
        <div>
          <div class="kpi-label">
            <?=h(t('kpi_avg_difficulty'))?>
            <?php if ($txt = ui_help('kpi_avg_difficulty')): ?>
              <span class="ms-1 text-muted" data-bs-toggle="tooltip" title="<?=h($txt)?>">ⓘ</span>
            <?php endif; ?>
          </div>
          <div class="kpi-value"><?=h($avg_difficulty_str)?></div>
        </div>
        <div class="rounded-3 p-3" style="background:#ffedd5">📊</div>
      </div>
    </div>
  </div>
  <div class="col-12 col-md-6 col-xl-3">
    <div class="card card-kpi p-3 bg-white">
      <div class="d-flex justify-content-between align-items-center">
        <div>
          <div class="kpi-label">
            <?=h(t('kpi_avg_corr'))?>
            <?php if ($txt = ui_help('kpi_avg_corr')): ?>
              <span class="ms-1 text-muted" data-bs-toggle="tooltip" title="<?=h($txt)?>">ⓘ</span>
            <?php endif; ?>
          </div>
          <div class="kpi-value"><?=h($avg_corr_str)?></div>
        </div>
        <div class="rounded-3 p-3" style="background:#dcfce7">📈</div>
      </div>
    </div>
  </div>
  <div class="col-12 col-md-6 col-xl-3">
    <div class="card card-kpi p-3 bg-white">
      <div class="d-flex justify-content-between align-items-center">
        <div>
          <div class="kpi-label">
            <?=h(t('kpi_problems'))?>
            <?php if ($txt = ui_help('kpi_problems')): ?>
              <span class="ms-1 text-muted" data-bs-toggle="tooltip" title="<?=h($txt)?>">ⓘ</span>
            <?php endif; ?>
          </div>
          <div class="kpi-value"><?=h((string)$problems)?></div>
        </div>
        <div class="rounded-3 p-3" style="background:#fee2e2">⛔</div>
      </div>
    </div>
  </div>
</div>

<div class="row g-3 mt-1">
  <div class="col-12 col-xl-6">
    <div class="panel">
      <div class="fw-semibold mb-2"><?=h(t('chart_difficulty'))?></div>
      <canvas id="difficultyChart" height="140"></canvas>
      <div class="small-muted mt-2">Easy/Medium/Hard строится из <code>question_stats.difficulty_pct</code> (может быть пусто, пока нет данных).</div>
    </div>
  </div>
  <div class="col-12 col-xl-6">
    <div class="panel">
      <div class="fw-semibold mb-2"><?=h(t('chart_by_discipline'))?></div>
      <canvas id="disciplineChart" height="140"></canvas>
      <div class="small-muted mt-2">Счётчик: <code>COUNT(questions)</code> по дисциплинам.</div>
    </div>
  </div>
</div>

<?php
$labels = json_encode([
    t('easy'), t('medium'), t('hard')
], JSON_UNESCAPED_UNICODE);
$data = json_encode([$dist['easy'], $dist['medium'], $dist['hard']], JSON_UNESCAPED_UNICODE);

$discLabels = json_encode(array_map(fn($r) => $r['discipline'] ?? '—', $by_discipline), JSON_UNESCAPED_UNICODE);
$discData = json_encode(array_map(fn($r) => (int)$r['cnt'], $by_discipline), JSON_UNESCAPED_UNICODE);

$page_scripts = "<script>
(function(){
  const ctx1 = document.getElementById('difficultyChart');
  if (ctx1) {
    new Chart(ctx1, {
      type: 'pie',
      data: { labels: {$labels}, datasets: [{ data: {$data} }] },
      options: { plugins: { legend: { position: 'right' } } }
    });
  }
  const ctx2 = document.getElementById('disciplineChart');
  if (ctx2) {
    new Chart(ctx2, {
      type: 'bar',
      data: { labels: {$discLabels}, datasets: [{ data: {$discData} }] },
      options: { plugins: { legend: { display: false } }, scales: { y: { beginAtZero: true } } }
    });
  }
})();
</script>";

require_once __DIR__ . '/partials/footer.php';
?>
