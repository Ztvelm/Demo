<?php
require_once __DIR__ . '/init.php';
require_once __DIR__ . '/db.php';

$id = (int)($_GET['id'] ?? 0);
$page_title = 'Question #' . $id;
require_once __DIR__ . '/partials/header.php';

$qRow = null;
$sRow = null;
$crit = [];

try {
  $st = $pdo->prepare('SELECT q.*, d.name AS discipline FROM questions q LEFT JOIN disciplines d ON d.discipline_id=q.discipline_id WHERE q.question_id=?');
  $st->execute([$id]);
  $qRow = $st->fetch();
} catch (Throwable $e) {}

try {
  $st = $pdo->prepare('SELECT * FROM question_stats WHERE question_id=?');
  $st->execute([$id]);
  $sRow = $st->fetch();
} catch (Throwable $e) {}

try {
  $st = $pdo->prepare('SELECT rc.name, qcs.avg_score, qcs.attempts
                       FROM question_criterion_stats qcs
                       LEFT JOIN rubric_criteria rc ON rc.criterion_id=qcs.criterion_id
                       WHERE qcs.question_id=?
                       ORDER BY qcs.avg_score ASC');
  $st->execute([$id]);
  $crit = $st->fetchAll();
} catch (Throwable $e) {}

if (!$qRow) {
  echo '<div class="alert alert-warning">Вопрос не найден.</div>';
  require_once __DIR__ . '/partials/footer.php';
  exit;
}

function fmt($v) {
  if ($v === null || $v === '') return '—';
  if (is_numeric($v)) return number_format((float)$v, 2);
  return (string)$v;
}
?>

<div class="panel mb-3">
  <div class="d-flex flex-wrap justify-content-between align-items-start gap-2">
    <div>
      <div class="fw-semibold">ID: <?=h((string)$qRow['question_id'])?></div>
      <div class="small-muted"><?=h($qRow['discipline'] ?? '—')?> · <?=h('Course: '.($qRow['course_target'] ?? '—'))?></div>
    </div>
    <a class="btn btn-outline-dark btn-sm" href="/questions.php">← Back</a>
  </div>
</div>

<div class="row g-3">
  <div class="col-12 col-xl-7">
    <div class="panel">
      <ul class="nav nav-tabs" role="tablist">
        <li class="nav-item" role="presentation"><button class="nav-link active" data-bs-toggle="tab" data-bs-target="#ru" type="button">RU</button></li>
        <li class="nav-item" role="presentation"><button class="nav-link" data-bs-toggle="tab" data-bs-target="#kz" type="button">KZ</button></li>
        <li class="nav-item" role="presentation"><button class="nav-link" data-bs-toggle="tab" data-bs-target="#en" type="button">EN</button></li>
      </ul>
      <div class="tab-content pt-3">
        <div class="tab-pane fade show active" id="ru"><pre class="m-0" style="white-space:pre-wrap"><?=h((string)($qRow['text_ru'] ?? ''))?></pre></div>
        <div class="tab-pane fade" id="kz"><pre class="m-0" style="white-space:pre-wrap"><?=h((string)($qRow['text_kz'] ?? ''))?></pre></div>
        <div class="tab-pane fade" id="en"><pre class="m-0" style="white-space:pre-wrap"><?=h((string)($qRow['text_en'] ?? ''))?></pre></div>
      </div>
    </div>
  </div>
  <div class="col-12 col-xl-5">
    <div class="panel">
      <div class="fw-semibold mb-2">Metrics</div>
      <div class="row g-2">
        <div class="col-6"><div class="small-muted">Difficulty</div><div class="fw-semibold"><?=h(fmt($sRow['difficulty_pct'] ?? null))?></div></div>
        <div class="col-6"><div class="small-muted">Corr</div><div class="fw-semibold"><?=h(fmt($sRow['corr_with_total'] ?? null))?></div></div>
        <div class="col-6"><div class="small-muted">Attempts</div><div class="fw-semibold"><?=h((string)($sRow['attempts'] ?? '—'))?></div></div>
        <div class="col-6"><div class="small-muted">Avg score</div><div class="fw-semibold"><?=h(fmt($sRow['avg_score'] ?? null))?></div></div>
      </div>
      <hr>
      <div class="small-muted mb-1">Flag</div>
      <div class="fw-semibold"><?=h((string)($sRow['flag'] ?? '—'))?></div>
      <?php if (!empty($sRow['recommendation'])): ?>
        <hr>
        <div class="small-muted mb-1">Recommendation</div>
        <div><?=h((string)$sRow['recommendation'])?></div>
      <?php endif; ?>
    </div>
  </div>
</div>

<div class="row g-3 mt-1">
  <div class="col-12">
    <div class="panel">
      <div class="fw-semibold mb-2">Rubric breakdown</div>
      <div class="table-responsive">
        <table class="table align-middle">
          <thead><tr><th>Criterion</th><th>Avg score</th><th>Attempts</th></tr></thead>
          <tbody>
            <?php if (!$crit): ?>
              <tr><td colspan="3" class="text-secondary">Нет данных по пунктам оценочного листа.</td></tr>
            <?php endif; ?>
            <?php foreach ($crit as $c): ?>
              <tr>
                <td><?=h($c['name'] ?? '—')?></td>
                <td><?=h(fmt($c['avg_score'] ?? null))?></td>
                <td><?=h((string)($c['attempts'] ?? '—'))?></td>
              </tr>
            <?php endforeach; ?>
          </tbody>
        </table>
      </div>
    </div>
  </div>
</div>

<?php require_once __DIR__ . '/partials/footer.php'; ?>
