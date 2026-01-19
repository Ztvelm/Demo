<?php
require_once __DIR__ . '/init.php';
$page_title = t('nav_import');
require_once __DIR__ . '/db.php';
require_once __DIR__ . '/partials/header.php';

$allowed_tables = [
  'disciplines' => ['discipline_id','name'],
  'questions' => ['question_id','discipline_id','course_target','text_ru','text_kz','text_en'],
  'question_stats' => ['question_id','attempts','avg_score','difficulty_pct','corr_with_total','flag','recommendation'],
];

$result = null;
$error = null;

function read_csv_rows(string $path, string $delimiter, bool $has_header): array {
  $rows = [];
  if (($h = fopen($path, 'rb')) === false) return $rows;
  while (($data = fgetcsv($h, 0, $delimiter)) !== false) {
    // skip empty rows
    if ($data === [null] || (count($data)==1 && trim((string)$data[0])==='')) continue;
    $rows[] = $data;
  }
  fclose($h);
  if (!$rows) return $rows;
  if ($has_header) {
    $header = array_map(fn($s) => trim((string)$s), array_shift($rows));
    return ['header'=>$header, 'rows'=>$rows];
  }
  return ['header'=>null,'rows'=>$rows];
}

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
  $table = $_POST['table'] ?? '';
  $delimiter = $_POST['delimiter'] ?? ',';
  $has_header = isset($_POST['has_header']);

  if (!isset($allowed_tables[$table])) {
    $error = 'Unknown table';
  } elseif (!isset($_FILES['csv']) || $_FILES['csv']['error'] !== UPLOAD_ERR_OK) {
    $error = 'CSV upload failed';
  } else {
    $tmp = $_FILES['csv']['tmp_name'];
    $parsed = read_csv_rows($tmp, $delimiter, $has_header);
    $header = $parsed['header'];
    $rows = $parsed['rows'];

    $cols = $allowed_tables[$table];

    // map columns
    $map = [];
    if ($header) {
      $hLower = array_map(fn($s)=>strtolower(trim($s)), $header);
      foreach ($cols as $i => $col) {
        $pos = array_search(strtolower($col), $hLower, true);
        $map[$col] = ($pos === false) ? null : $pos;
      }
    }

    $inserted = 0;
    $skipped = 0;
    $pdo->beginTransaction();
    try {
      $placeholders = '(' . implode(',', array_fill(0, count($cols), '?')) . ')';
      $sql = 'INSERT INTO ' . $table . ' (' . implode(',', $cols) . ') VALUES ' . $placeholders;

      // upsert for tables where primary key exists
      if ($table === 'disciplines') {
        $sql .= ' ON DUPLICATE KEY UPDATE name=VALUES(name)';
      }
      if ($table === 'questions') {
        $sql .= ' ON DUPLICATE KEY UPDATE discipline_id=VALUES(discipline_id), course_target=VALUES(course_target), text_ru=VALUES(text_ru), text_kz=VALUES(text_kz), text_en=VALUES(text_en)';
      }
      if ($table === 'question_stats') {
        $sql .= ' ON DUPLICATE KEY UPDATE attempts=VALUES(attempts), avg_score=VALUES(avg_score), difficulty_pct=VALUES(difficulty_pct), corr_with_total=VALUES(corr_with_total), flag=VALUES(flag), recommendation=VALUES(recommendation)';
      }

      $st = $pdo->prepare($sql);

      foreach ($rows as $r) {
        $vals = [];
        foreach ($cols as $idx => $col) {
          if ($header) {
            $pos = $map[$col];
            $vals[] = ($pos === null) ? null : ($r[$pos] ?? null);
          } else {
            $vals[] = $r[$idx] ?? null;
          }
        }

        // minimal validation
        if ($table === 'questions') {
          $qid = $vals[0];
          $did = $vals[1];
          if ($qid === null || $qid === '' || $did === null || $did === '') { $skipped++; continue; }
        }
        if ($table === 'disciplines') {
          if (($vals[0]??'')==='' || ($vals[1]??'')==='') { $skipped++; continue; }
        }
        if ($table === 'question_stats') {
          if (($vals[0]??'')==='') { $skipped++; continue; }
        }

        $st->execute($vals);
        $inserted++;
      }

      $pdo->commit();
      $result = ['inserted'=>$inserted, 'skipped'=>$skipped, 'table'=>$table];
    } catch (Throwable $e) {
      $pdo->rollBack();
      $error = $e->getMessage();
    }
  }
}
?>

<div class="row g-3">
  <div class="col-12 col-xl-5">
    <div class="panel">
      <div class="fw-semibold mb-2"><?=h(t('upload_csv'))?></div>

      <?php if ($error): ?>
        <div class="alert alert-danger mb-3"><?=h($error)?></div>
      <?php endif; ?>
      <?php if ($result): ?>
        <div class="alert alert-success mb-3">
          <?=h(t('import_result'))?>: inserted <?=h((string)$result['inserted'])?>, skipped <?=h((string)$result['skipped'])?> (<?=h($result['table'])?>)
        </div>
      <?php endif; ?>

      <form method="post" enctype="multipart/form-data" class="row g-2">
        <div class="col-12">
          <label class="form-label mb-1"><?=h(t('choose_table'))?></label>
          <select class="form-select" name="table" required>
            <?php foreach ($allowed_tables as $tbl => $cols): ?>
              <option value="<?=h($tbl)?>"><?=h($tbl)?></option>
            <?php endforeach; ?>
          </select>
          <div class="small-muted mt-1">Поддержка заголовков: если в CSV есть колонка с тем же именем (например <code>question_id</code>), она будет сопоставлена автоматически.</div>
        </div>

        <div class="col-6">
          <label class="form-label mb-1"><?=h(t('delimiter'))?></label>
          <select class="form-select" name="delimiter">
            <option value=",">,</option>
            <option value=";">;</option>
            <option value="\t">TAB</option>
          </select>
        </div>
        <div class="col-6 d-flex align-items-end">
          <div class="form-check">
            <input class="form-check-input" type="checkbox" name="has_header" id="has_header" checked>
            <label class="form-check-label" for="has_header"><?=h(t('has_header'))?></label>
          </div>
        </div>

        <div class="col-12">
          <input class="form-control" type="file" name="csv" accept=".csv,text/csv" required>
        </div>

        <div class="col-12 d-grid">
          <button class="btn btn-dark" type="submit"><?=h(t('import'))?></button>
        </div>
      </form>
    </div>
  </div>

  <div class="col-12 col-xl-7">
    <div class="panel">
      <div class="fw-semibold mb-2">CSV templates</div>
      <div class="small-muted mb-2">Можно копировать структуру, чтобы быстро наполнить базу тестовыми данными.</div>

      <div class="mb-3">
        <div class="fw-semibold">disciplines.csv</div>
        <pre class="bg-light p-2 rounded-2 small">discipline_id,name
1,Internal medicine
2,Surgery</pre>
      </div>

      <div class="mb-3">
        <div class="fw-semibold">questions.csv</div>
        <pre class="bg-light p-2 rounded-2 small">question_id,discipline_id,course_target,text_ru,text_kz,text_en
1001,1,3,"Что такое инфаркт миокарда?","Миокард инфаркты деген не?","What is myocardial infarction?"</pre>
      </div>

      <div>
        <div class="fw-semibold">question_stats.csv</div>
        <pre class="bg-light p-2 rounded-2 small">question_id,attempts,avg_score,difficulty_pct,corr_with_total,flag,recommendation
1001,210,7.2,0.68,0.79,good,"OK"</pre>
      </div>
    </div>
  </div>
</div>

<?php require_once __DIR__ . '/partials/footer.php'; ?>
