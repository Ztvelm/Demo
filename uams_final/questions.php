<?php
require_once __DIR__ . '/init.php';
$page_title = t('nav_questions');
require_once __DIR__ . '/db.php';
require_once __DIR__ . '/partials/header.php';

// Filters
$q = trim($_GET['q'] ?? '');
$discipline_id = trim($_GET['discipline_id'] ?? '');
$course = trim($_GET['course'] ?? '');
$status = trim($_GET['status'] ?? '');

// Load disciplines for filter
$disciplines = [];
try {
  $disciplines = $pdo->query('SELECT discipline_id, name FROM disciplines ORDER BY name')->fetchAll();
} catch (Throwable $e) {}

$where = [];
$params = [];
if ($q !== '') {
  // ищем по любому тексту
  $where[] = '(q.text_ru LIKE :q OR q.text_kz LIKE :q OR q.text_en LIKE :q)';
  $params[':q'] = '%' . $q . '%';
}
if ($discipline_id !== '') {
  $where[] = 'q.discipline_id = :discipline_id';
  $params[':discipline_id'] = $discipline_id;
}
if ($course !== '') {
  $where[] = 'q.course_target = :course';
  $params[':course'] = $course;
}
if ($status !== '') {
  // status берём из question_stats.flag если есть
  $where[] = 'qs.flag = :status';
  $params[':status'] = $status;
}

$where_sql = $where ? ('WHERE ' . implode(' AND ', $where)) : '';

$sql = "
SELECT
  q.question_id,
  q.discipline_id,
  d.name AS discipline,
  q.course_target,
  qs.difficulty_pct,
  qs.corr_with_total,
  qs.flag,
  qs.recommendation
FROM questions q
LEFT JOIN disciplines d ON d.discipline_id = q.discipline_id
LEFT JOIN (
  SELECT t.question_id, t.difficulty_pct, t.corr_with_total, t.flag, t.recommendation
  FROM v_question_exam_stats t
  JOIN (
    SELECT question_id, MAX(exam_date) AS max_date
    FROM v_question_exam_stats
    GROUP BY question_id
  ) m ON m.question_id = t.question_id AND m.max_date = t.exam_date
) qs ON qs.question_id = q.question_id
{$where_sql}
ORDER BY q.question_id DESC
LIMIT 500
";

$rows = [];
try {
  $st = $pdo->prepare($sql);
  $st->execute($params);
  $rows = $st->fetchAll();
} catch (Throwable $e) {
  echo '<div class="alert alert-danger">Ошибка запроса: ' . h($e->getMessage()) . '</div>';
}

function status_badge($flag): array {
  $flag = (string)$flag;
  if ($flag === 'red') return ['badge-status badge-bad', 'Red'];
  if ($flag === 'yellow') return ['badge-status badge-warn', 'Yellow'];
  if ($flag === 'green') return ['badge-status badge-good', 'Green'];
  return ['text-secondary', '—'];
}
?>

<div class="panel mb-3">
  <form method="get" class="row g-2 align-items-end">
    <div class="col-12 col-md-4">
      <label class="form-label mb-1"><?=h(t('search'))?></label>
      <input class="form-control" name="q" value="<?=h($q)?>" placeholder="...">
    </div>
    <div class="col-12 col-md-3">
      <label class="form-label mb-1"><?=h(t('discipline'))?></label>
      <select class="form-select" name="discipline_id">
        <option value="">—</option>
        <?php foreach ($disciplines as $d): ?>
          <option value="<?=h((string)$d['discipline_id'])?>" <?= ($discipline_id!=='' && (string)$discipline_id===(string)$d['discipline_id'])?'selected':'' ?>><?=h($d['name'])?></option>
        <?php endforeach; ?>
      </select>
    </div>
    <div class="col-6 col-md-2">
      <label class="form-label mb-1"><?=h(t('course'))?></label>
      <select class="form-select" name="course">
        <option value="">—</option>
        <?php for ($i=1;$i<=7;$i++): ?>
          <option value="<?=$i?>" <?= ($course!=='' && (string)$course===(string)$i)?'selected':'' ?>><?=$i?></option>
        <?php endfor; ?>
      </select>
    </div>
    <div class="col-6 col-md-2">
      <label class="form-label mb-1"><?=h(t('status'))?></label>
      <select class="form-select" name="status">
        <option value="">—</option>
        <option value="green" <?= $status==='green'?'selected':'' ?>>Green</option>
        <option value="yellow" <?= $status==='yellow'?'selected':'' ?>>Yellow</option>
        <option value="red" <?= $status==='red'?'selected':'' ?>>Red</option>
      </select>
    </div>
    <div class="col-12 col-md-1 d-grid">
      <button class="btn btn-dark" type="submit">OK</button>
    </div>
  </form>
</div>

<div class="panel">
  <div class="table-responsive">
    <table class="table align-middle">
      <thead>
        <tr>
          <th>ID</th>
          <th><?=h(t('discipline'))?></th>
          <th><?=h(t('course'))?></th>
          <th>Difficulty <?php if ($txt = ui_help('questions.difficulty')): ?><span class="ms-1 text-muted" data-bs-toggle="tooltip" title="<?=h($txt)?>">ⓘ</span><?php endif; ?></th>
          <th>Corr <?php if ($txt = ui_help('questions.corr_with_total')): ?><span class="ms-1 text-muted" data-bs-toggle="tooltip" title="<?=h($txt)?>">ⓘ</span><?php endif; ?></th>
          <th><?=h(t('status'))?></th>
          <th><?=h(t('actions'))?></th>
        </tr>
      </thead>
      <tbody>
        <?php if (!$rows): ?>
          <tr><td colspan="8" class="text-secondary">Нет данных (пока не импортировали CSV).</td></tr>
        <?php endif; ?>
        <?php foreach ($rows as $r): ?>
          <?php [$cls,$label] = status_badge($r['flag'] ?? null); ?>
          <tr>
            <td><?=h((string)$r['question_id'])?></td>
            <td><?=h($r['discipline'] ?? '—')?></td>
            <td><?=h((string)($r['course_target'] ?? '—'))?></td>
            <td><?= isset($r['difficulty_pct']) ? h(number_format((float)$r['difficulty_pct'],2)) : '—' ?></td>
            <td><?= isset($r['corr_with_total']) ? h(number_format((float)$r['corr_with_total'],2)) : '—' ?></td>
            <td><span class="badge <?=$cls?>"><?=$label?></span></td>
            <td><a class="btn btn-sm btn-outline-dark" href="question.php?id=<?=h((string)$r['question_id'])?>"><?=h(t('open'))?></a></td>
          </tr>
        <?php endforeach; ?>
      </tbody>
    </table>
  </div>
</div>

<?php require_once __DIR__ . '/partials/footer.php'; ?>
