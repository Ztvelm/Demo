-- UI + demo patch for exam_quality (MySQL 8.4)
-- Safe to run multiple times: uses IF NOT EXISTS / ON DUPLICATE KEY UPDATE

SET NAMES utf8mb4;

-- -----------------------------
-- 1) UI tables (site structure in MySQL)
-- -----------------------------

CREATE TABLE IF NOT EXISTS `ui_menu` (
  `id` int NOT NULL AUTO_INCREMENT,
  `parent_id` int DEFAULT NULL,
  `route` varchar(255) NOT NULL,
  `icon` varchar(32) DEFAULT NULL,
  `title_key` varchar(128) NOT NULL,
  `sort_order` int NOT NULL DEFAULT 0,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_ui_menu_parent` (`parent_id`),
  KEY `idx_ui_menu_sort` (`sort_order`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `ui_texts` (
  `key_name` varchar(128) NOT NULL,
  `ru` text,
  `kz` text,
  `en` text,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`key_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `ui_help` (
  `context` varchar(128) NOT NULL,
  `ru` text,
  `kz` text,
  `en` text,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`context`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `ui_onboarding` (
  `route` varchar(128) NOT NULL,
  `ru` text,
  `kz` text,
  `en` text,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`route`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- -----------------------------
-- 2) Optional flags for demo data (MySQL-compatible idempotent ALTER)
--    MySQL does NOT support: ADD COLUMN IF NOT EXISTS
--    So we check INFORMATION_SCHEMA and run dynamic ALTER only when needed.
-- -----------------------------

-- add is_demo to `departments` if missing
SET @__db := DATABASE();
SET @__tbl := 'departments';
SET @__tbl_exists := (
  SELECT COUNT(*) FROM INFORMATION_SCHEMA.TABLES
  WHERE TABLE_SCHEMA = @__db AND TABLE_NAME = @__tbl
);
SET @__col_exists := (
  SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_SCHEMA = @__db AND TABLE_NAME = @__tbl AND COLUMN_NAME = 'is_demo'
);
SET @__sql := IF(
  @__tbl_exists = 1 AND @__col_exists = 0,
  CONCAT('ALTER TABLE `', @__tbl, '` ADD COLUMN `is_demo` TINYINT(1) NOT NULL DEFAULT 0'),
  CONCAT('SELECT "skip: ", @__tbl, " (table missing or column exists)"')
);
PREPARE __stmt FROM @__sql;
EXECUTE __stmt;
DEALLOCATE PREPARE __stmt;

-- add is_demo to `disciplines` if missing
SET @__db := DATABASE();
SET @__tbl := 'disciplines';
SET @__tbl_exists := (
  SELECT COUNT(*) FROM INFORMATION_SCHEMA.TABLES
  WHERE TABLE_SCHEMA = @__db AND TABLE_NAME = @__tbl
);
SET @__col_exists := (
  SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_SCHEMA = @__db AND TABLE_NAME = @__tbl AND COLUMN_NAME = 'is_demo'
);
SET @__sql := IF(
  @__tbl_exists = 1 AND @__col_exists = 0,
  CONCAT('ALTER TABLE `', @__tbl, '` ADD COLUMN `is_demo` TINYINT(1) NOT NULL DEFAULT 0'),
  CONCAT('SELECT "skip: ", @__tbl, " (table missing or column exists)"')
);
PREPARE __stmt FROM @__sql;
EXECUTE __stmt;
DEALLOCATE PREPARE __stmt;

-- add is_demo to `teachers` if missing
SET @__db := DATABASE();
SET @__tbl := 'teachers';
SET @__tbl_exists := (
  SELECT COUNT(*) FROM INFORMATION_SCHEMA.TABLES
  WHERE TABLE_SCHEMA = @__db AND TABLE_NAME = @__tbl
);
SET @__col_exists := (
  SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_SCHEMA = @__db AND TABLE_NAME = @__tbl AND COLUMN_NAME = 'is_demo'
);
SET @__sql := IF(
  @__tbl_exists = 1 AND @__col_exists = 0,
  CONCAT('ALTER TABLE `', @__tbl, '` ADD COLUMN `is_demo` TINYINT(1) NOT NULL DEFAULT 0'),
  CONCAT('SELECT "skip: ", @__tbl, " (table missing or column exists)"')
);
PREPARE __stmt FROM @__sql;
EXECUTE __stmt;
DEALLOCATE PREPARE __stmt;

-- add is_demo to `rubrics` if missing
SET @__db := DATABASE();
SET @__tbl := 'rubrics';
SET @__tbl_exists := (
  SELECT COUNT(*) FROM INFORMATION_SCHEMA.TABLES
  WHERE TABLE_SCHEMA = @__db AND TABLE_NAME = @__tbl
);
SET @__col_exists := (
  SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_SCHEMA = @__db AND TABLE_NAME = @__tbl AND COLUMN_NAME = 'is_demo'
);
SET @__sql := IF(
  @__tbl_exists = 1 AND @__col_exists = 0,
  CONCAT('ALTER TABLE `', @__tbl, '` ADD COLUMN `is_demo` TINYINT(1) NOT NULL DEFAULT 0'),
  CONCAT('SELECT "skip: ", @__tbl, " (table missing or column exists)"')
);
PREPARE __stmt FROM @__sql;
EXECUTE __stmt;
DEALLOCATE PREPARE __stmt;

-- add is_demo to `rubric_criteria` if missing
SET @__db := DATABASE();
SET @__tbl := 'rubric_criteria';
SET @__tbl_exists := (
  SELECT COUNT(*) FROM INFORMATION_SCHEMA.TABLES
  WHERE TABLE_SCHEMA = @__db AND TABLE_NAME = @__tbl
);
SET @__col_exists := (
  SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_SCHEMA = @__db AND TABLE_NAME = @__tbl AND COLUMN_NAME = 'is_demo'
);
SET @__sql := IF(
  @__tbl_exists = 1 AND @__col_exists = 0,
  CONCAT('ALTER TABLE `', @__tbl, '` ADD COLUMN `is_demo` TINYINT(1) NOT NULL DEFAULT 0'),
  CONCAT('SELECT "skip: ", @__tbl, " (table missing or column exists)"')
);
PREPARE __stmt FROM @__sql;
EXECUTE __stmt;
DEALLOCATE PREPARE __stmt;

-- add is_demo to `exams` if missing
SET @__db := DATABASE();
SET @__tbl := 'exams';
SET @__tbl_exists := (
  SELECT COUNT(*) FROM INFORMATION_SCHEMA.TABLES
  WHERE TABLE_SCHEMA = @__db AND TABLE_NAME = @__tbl
);
SET @__col_exists := (
  SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_SCHEMA = @__db AND TABLE_NAME = @__tbl AND COLUMN_NAME = 'is_demo'
);
SET @__sql := IF(
  @__tbl_exists = 1 AND @__col_exists = 0,
  CONCAT('ALTER TABLE `', @__tbl, '` ADD COLUMN `is_demo` TINYINT(1) NOT NULL DEFAULT 0'),
  CONCAT('SELECT "skip: ", @__tbl, " (table missing or column exists)"')
);
PREPARE __stmt FROM @__sql;
EXECUTE __stmt;
DEALLOCATE PREPARE __stmt;

-- add is_demo to `questions` if missing
SET @__db := DATABASE();
SET @__tbl := 'questions';
SET @__tbl_exists := (
  SELECT COUNT(*) FROM INFORMATION_SCHEMA.TABLES
  WHERE TABLE_SCHEMA = @__db AND TABLE_NAME = @__tbl
);
SET @__col_exists := (
  SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_SCHEMA = @__db AND TABLE_NAME = @__tbl AND COLUMN_NAME = 'is_demo'
);
SET @__sql := IF(
  @__tbl_exists = 1 AND @__col_exists = 0,
  CONCAT('ALTER TABLE `', @__tbl, '` ADD COLUMN `is_demo` TINYINT(1) NOT NULL DEFAULT 0'),
  CONCAT('SELECT "skip: ", @__tbl, " (table missing or column exists)"')
);
PREPARE __stmt FROM @__sql;
EXECUTE __stmt;
DEALLOCATE PREPARE __stmt;

-- add is_demo to `question_stats` if missing
SET @__db := DATABASE();
SET @__tbl := 'question_stats';
SET @__tbl_exists := (
  SELECT COUNT(*) FROM INFORMATION_SCHEMA.TABLES
  WHERE TABLE_SCHEMA = @__db AND TABLE_NAME = @__tbl
);
SET @__col_exists := (
  SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_SCHEMA = @__db AND TABLE_NAME = @__tbl AND COLUMN_NAME = 'is_demo'
);
SET @__sql := IF(
  @__tbl_exists = 1 AND @__col_exists = 0,
  CONCAT('ALTER TABLE `', @__tbl, '` ADD COLUMN `is_demo` TINYINT(1) NOT NULL DEFAULT 0'),
  CONCAT('SELECT "skip: ", @__tbl, " (table missing or column exists)"')
);
PREPARE __stmt FROM @__sql;
EXECUTE __stmt;
DEALLOCATE PREPARE __stmt;

-- add is_demo to `question_validity` if missing
SET @__db := DATABASE();
SET @__tbl := 'question_validity';
SET @__tbl_exists := (
  SELECT COUNT(*) FROM INFORMATION_SCHEMA.TABLES
  WHERE TABLE_SCHEMA = @__db AND TABLE_NAME = @__tbl
);
SET @__col_exists := (
  SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_SCHEMA = @__db AND TABLE_NAME = @__tbl AND COLUMN_NAME = 'is_demo'
);
SET @__sql := IF(
  @__tbl_exists = 1 AND @__col_exists = 0,
  CONCAT('ALTER TABLE `', @__tbl, '` ADD COLUMN `is_demo` TINYINT(1) NOT NULL DEFAULT 0'),
  CONCAT('SELECT "skip: ", @__tbl, " (table missing or column exists)"')
);
PREPARE __stmt FROM @__sql;
EXECUTE __stmt;
DEALLOCATE PREPARE __stmt;

-- add is_demo to `question_criterion_stats` if missing
SET @__db := DATABASE();
SET @__tbl := 'question_criterion_stats';
SET @__tbl_exists := (
  SELECT COUNT(*) FROM INFORMATION_SCHEMA.TABLES
  WHERE TABLE_SCHEMA = @__db AND TABLE_NAME = @__tbl
);
SET @__col_exists := (
  SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_SCHEMA = @__db AND TABLE_NAME = @__tbl AND COLUMN_NAME = 'is_demo'
);
SET @__sql := IF(
  @__tbl_exists = 1 AND @__col_exists = 0,
  CONCAT('ALTER TABLE `', @__tbl, '` ADD COLUMN `is_demo` TINYINT(1) NOT NULL DEFAULT 0'),
  CONCAT('SELECT "skip: ", @__tbl, " (table missing or column exists)"')
);
PREPARE __stmt FROM @__sql;
EXECUTE __stmt;
DEALLOCATE PREPARE __stmt;

-- add is_demo to `syllabus_topics` if missing
SET @__db := DATABASE();
SET @__tbl := 'syllabus_topics';
SET @__tbl_exists := (
  SELECT COUNT(*) FROM INFORMATION_SCHEMA.TABLES
  WHERE TABLE_SCHEMA = @__db AND TABLE_NAME = @__tbl
);
SET @__col_exists := (
  SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_SCHEMA = @__db AND TABLE_NAME = @__tbl AND COLUMN_NAME = 'is_demo'
);
SET @__sql := IF(
  @__tbl_exists = 1 AND @__col_exists = 0,
  CONCAT('ALTER TABLE `', @__tbl, '` ADD COLUMN `is_demo` TINYINT(1) NOT NULL DEFAULT 0'),
  CONCAT('SELECT "skip: ", @__tbl, " (table missing or column exists)"')
);
PREPARE __stmt FROM @__sql;
EXECUTE __stmt;
DEALLOCATE PREPARE __stmt;

-- add is_demo to `student_groups` if missing
SET @__db := DATABASE();
SET @__tbl := 'student_groups';
SET @__tbl_exists := (
  SELECT COUNT(*) FROM INFORMATION_SCHEMA.TABLES
  WHERE TABLE_SCHEMA = @__db AND TABLE_NAME = @__tbl
);
SET @__col_exists := (
  SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_SCHEMA = @__db AND TABLE_NAME = @__tbl AND COLUMN_NAME = 'is_demo'
);
SET @__sql := IF(
  @__tbl_exists = 1 AND @__col_exists = 0,
  CONCAT('ALTER TABLE `', @__tbl, '` ADD COLUMN `is_demo` TINYINT(1) NOT NULL DEFAULT 0'),
  CONCAT('SELECT "skip: ", @__tbl, " (table missing or column exists)"')
);
PREPARE __stmt FROM @__sql;
EXECUTE __stmt;
DEALLOCATE PREPARE __stmt;

-- add is_demo to `students` if missing
SET @__db := DATABASE();
SET @__tbl := 'students';
SET @__tbl_exists := (
  SELECT COUNT(*) FROM INFORMATION_SCHEMA.TABLES
  WHERE TABLE_SCHEMA = @__db AND TABLE_NAME = @__tbl
);
SET @__col_exists := (
  SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_SCHEMA = @__db AND TABLE_NAME = @__tbl AND COLUMN_NAME = 'is_demo'
);
SET @__sql := IF(
  @__tbl_exists = 1 AND @__col_exists = 0,
  CONCAT('ALTER TABLE `', @__tbl, '` ADD COLUMN `is_demo` TINYINT(1) NOT NULL DEFAULT 0'),
  CONCAT('SELECT "skip: ", @__tbl, " (table missing or column exists)"')
);
PREPARE __stmt FROM @__sql;
EXECUTE __stmt;
DEALLOCATE PREPARE __stmt;

-- -----------------------------
-- 3) Seed UI texts (RU/KZ/EN)
-- -----------------------------

INSERT INTO ui_texts (key_name, ru, kz, en) VALUES
('app_name', 'Exam Quality Analyzer', 'Exam Quality Analyzer', 'Exam Quality Analyzer'),
('app_subtitle', 'Аналитика качества экзаменационных вопросов', 'Емтихан сұрақтарының сапасын талдау', 'Exam question quality analytics'),
('nav_dashboard', 'Панель', 'Басқару', 'Dashboard'),
('nav_questions', 'Вопросы', 'Сұрақтар', 'Questions'),
('nav_import', 'Импорт CSV', 'CSV импорт', 'CSV import'),
('kpi_total_questions', 'Всего вопросов', 'Сұрақ саны', 'Total questions'),
('kpi_avg_difficulty', 'Средняя сложность', 'Орташа қиындық', 'Average difficulty'),
('kpi_avg_corr', 'Средняя корреляция', 'Орташа корреляция', 'Average correlation'),
('kpi_problems', 'Проблемные вопросы', 'Мәселелі сұрақтар', 'Problem questions'),
('chart_difficulty', 'Распределение сложности', 'Қиындық үлестірімі', 'Difficulty distribution'),
('chart_by_discipline', 'Вопросы по дисциплинам', 'Пәндер бойынша сұрақтар', 'Questions by discipline'),
('easy', 'Легко', 'Оңай', 'Easy'),
('medium', 'Средне', 'Орташа', 'Medium'),
('hard', 'Сложно', 'Қиын', 'Hard'),
('search', 'Поиск', 'Іздеу', 'Search'),
('discipline', 'Дисциплина', 'Пән', 'Discipline'),
('course', 'Курс', 'Курс', 'Course'),
('status', 'Статус', 'Күйі', 'Status'),
('actions', 'Действия', 'Әрекеттер', 'Actions'),
('open', 'Открыть', 'Ашу', 'Open'),
('import_title', 'Импорт данных', 'Деректерді импорттау', 'Import data'),
('import_choose', 'Выберите CSV и загрузите в базу', 'CSV таңдаңыз және базаға жүктеңіз', 'Choose CSV and upload into database')
ON DUPLICATE KEY UPDATE ru=VALUES(ru), kz=VALUES(kz), en=VALUES(en);

-- -----------------------------
-- 4) Seed help tooltips
-- -----------------------------

INSERT INTO ui_help (context, ru, kz, en) VALUES
('kpi_total_questions', 'Количество вопросов в таблице questions.', 'questions кестесіндегі сұрақ саны.', 'Number of records in questions.'),
('kpi_avg_difficulty', 'Среднее значение difficulty_pct (0..1). Чем выше, тем легче вопрос.', 'difficulty_pct орташа мәні (0..1). Жоғары болса – оңай.', 'Average difficulty_pct (0..1). Higher means easier.'),
('kpi_avg_corr', 'Среднее corr_with_total. Показывает вклад вопроса в итоговый балл.', 'corr_with_total орташа мәні. Сұрақтың жалпы баллға ықпалы.', 'Average corr_with_total. Shows contribution to total score.'),
('kpi_problems', 'Количество вопросов со статусом yellow/red (требуют внимания).', 'yellow/red мәртебесі бар сұрақ саны.', 'Count of yellow/red questions (need attention).'),
('questions.difficulty', 'difficulty_pct = доля успешных ответов (0..1).', 'difficulty_pct = дұрыс жауап үлесі (0..1).', 'difficulty_pct = share of successful answers (0..1).'),
('questions.corr_with_total', 'corr_with_total: связь оценки по вопросу с итоговым баллом.', 'corr_with_total: сұрақ бағасы мен жалпы балл байланысы.', 'corr_with_total: correlation between item score and total.')
ON DUPLICATE KEY UPDATE ru=VALUES(ru), kz=VALUES(kz), en=VALUES(en);

-- -----------------------------
-- 5) Seed onboarding (page hints)
-- -----------------------------

INSERT INTO ui_onboarding (route, ru, kz, en) VALUES
('index.php', '<b>Что делать:</b> 1) импортируйте CSV, 2) откройте «Вопросы», 3) проверьте red/yellow и рекомендации.', '<b>Не істеу керек:</b> 1) CSV импорттаңыз, 2) «Сұрақтар» ашыңыз, 3) red/yellow және ұсыныстарды тексеріңіз.', '<b>What to do:</b> 1) Import CSV, 2) open Questions, 3) review red/yellow and recommendations.'),
('questions.php', '<b>Подсказка:</b> фильтруйте по дисциплине/курсу и смотрите корреляцию/сложность. Red = переработать, Yellow = проверить.', '<b>Кеңес:</b> пән/курс бойынша сүзгіден өткізіңіз. Red = қайта жасау, Yellow = тексеру.', '<b>Tip:</b> filter by discipline/course and watch difficulty/correlation. Red = rework, Yellow = review.'),
('import_csv.php', '<b>Импорт:</b> загрузите выгрузку (CSV). Если пока данных нет — используйте демо-набор (в базе уже есть 10 вопросов).', '<b>Импорт:</b> CSV жүктеңіз. Дерек жоқ болса — демо-наборды қолданыңыз (10 сұрақ бар).', '<b>Import:</b> upload CSV export. If no real data yet, use demo set (10 questions are already inserted).')
ON DUPLICATE KEY UPDATE ru=VALUES(ru), kz=VALUES(kz), en=VALUES(en);

-- -----------------------------
-- 6) Seed menu (if empty)
-- -----------------------------

INSERT INTO ui_menu (id, parent_id, route, icon, title_key, sort_order, is_active)
SELECT * FROM (
  SELECT 1 AS id, NULL AS parent_id, '/index.php' AS route, '🏠' AS icon, 'nav_dashboard' AS title_key, 10 AS sort_order, 1 AS is_active
  UNION ALL SELECT 2, NULL, '/questions.php', '❓', 'nav_questions', 20, 1
  UNION ALL SELECT 3, NULL, '/import_csv.php', '⬆️', 'nav_import', 30, 1
) x
ON DUPLICATE KEY UPDATE route=VALUES(route), icon=VALUES(icon), title_key=VALUES(title_key), sort_order=VALUES(sort_order), is_active=VALUES(is_active);

-- -----------------------------
-- 7) Demo dataset (10 questions in RU/KZ/EN)
-- -----------------------------

-- Use high ids to avoid collisions
SET @DEMO_DEPT := 9001;
SET @DEMO_DISC := 9001;
SET @DEMO_TEACH := 9001;
SET @DEMO_RUBRIC := 9001;
SET @DEMO_EXAM := 9000001;

INSERT INTO departments (department_id, name, is_demo)
VALUES (@DEMO_DEPT, 'DEMO: Внутренние болезни / Internal medicine', 1)
ON DUPLICATE KEY UPDATE name=VALUES(name), is_demo=1;

INSERT INTO disciplines (discipline_id, department_id, name, is_demo)
VALUES (@DEMO_DISC, @DEMO_DEPT, 'DEMO: Кардиология / Cardiology', 1)
ON DUPLICATE KEY UPDATE department_id=VALUES(department_id), name=VALUES(name), is_demo=1;

INSERT INTO teachers (teacher_id, discipline_id, role, login, password_hash, is_active, is_demo)
VALUES (@DEMO_TEACH, @DEMO_DISC, 'teacher', 'demo_teacher', NULL, 1, 1)
ON DUPLICATE KEY UPDATE discipline_id=VALUES(discipline_id), role=VALUES(role), is_active=1, is_demo=1;

INSERT INTO rubrics (rubric_id, discipline_id, name, version, is_demo)
VALUES (@DEMO_RUBRIC, @DEMO_DISC, 'DEMO rubric', '1.0', 1)
ON DUPLICATE KEY UPDATE discipline_id=VALUES(discipline_id), name=VALUES(name), version=VALUES(version), is_demo=1;

INSERT INTO rubric_criteria (criterion_id, rubric_id, title, max_score, order_index, is_demo) VALUES
(90001, @DEMO_RUBRIC, 'Соответствие теме / Topic relevance', 10, 1, 1),
(90002, @DEMO_RUBRIC, 'Клиническая логика / Clinical reasoning', 10, 2, 1),
(90003, @DEMO_RUBRIC, 'Корректность дозировок / Dosages', 10, 3, 1),
(90004, @DEMO_RUBRIC, 'Полнота ответа / Completeness', 10, 4, 1),
(90005, @DEMO_RUBRIC, 'Терминология / Terminology', 10, 5, 1)
ON DUPLICATE KEY UPDATE rubric_id=VALUES(rubric_id), title=VALUES(title), max_score=VALUES(max_score), order_index=VALUES(order_index), is_demo=1;

INSERT INTO exams (exam_id, discipline_id, rubric_id, exam_date, note, is_demo)
VALUES (@DEMO_EXAM, @DEMO_DISC, @DEMO_RUBRIC, '2026-01-15', 'DEMO exam for UI and analytics', 1)
ON DUPLICATE KEY UPDATE discipline_id=VALUES(discipline_id), rubric_id=VALUES(rubric_id), exam_date=VALUES(exam_date), note=VALUES(note), is_demo=1;

-- Questions
INSERT INTO questions (question_id, discipline_id, teacher_id, course_target, text_ru, text_kz, text_en, is_active, is_demo) VALUES
(9000001001, @DEMO_DISC, @DEMO_TEACH, 3,
 'Назовите основные диагностические критерии инфаркта миокарда (ЭКГ, тропонины, клиника).',
 'Миокард инфарктін диагностикалаудың негізгі критерийлерін атаңыз (ЭКГ, тропониндер, клиника).',
 'Name the main diagnostic criteria for myocardial infarction (ECG, troponins, symptoms).', 1, 1),
(9000001002, @DEMO_DISC, @DEMO_TEACH, 3,
 'Опишите алгоритм первичной помощи при подозрении на острый коронарный синдром.',
 'Жедел коронарлық синдромға күдік болса бастапқы көмектің алгоритмін сипаттаңыз.',
 'Describe the initial management algorithm for suspected acute coronary syndrome.', 1, 1),
(9000001003, @DEMO_DISC, @DEMO_TEACH, 4,
 'Перечислите абсолютные противопоказания к тромболитической терапии.',
 'Тромболитикалық терапияға абсолютті қарсы көрсетілімдерді атаңыз.',
 'List absolute contraindications to thrombolytic therapy.', 1, 1),
(9000001004, @DEMO_DISC, @DEMO_TEACH, 4,
 'Как интерпретировать подъём сегмента ST? Приведите минимум 2 возможные причины.',
 'ST сегментінің көтерілуін қалай түсіндіресіз? Кемінде 2 себеп келтіріңіз.',
 'How to interpret ST-segment elevation? Provide at least two possible causes.', 1, 1),
(9000001005, @DEMO_DISC, @DEMO_TEACH, 5,
 'Назовите основные группы препаратов для лечения хронической сердечной недостаточности.',
 'Созылмалы жүрек жеткіліксіздігін емдеуге арналған дәрілердің негізгі топтарын атаңыз.',
 'Name the main drug classes for chronic heart failure treatment.', 1, 1),
(9000001006, @DEMO_DISC, @DEMO_TEACH, 5,
 'Что такое шкала CHA2DS2-VASc и для чего она используется?',
 'CHA2DS2-VASc шкаласы дегеніміз не және ол не үшін қолданылады?',
 'What is the CHA2DS2-VASc score and what is it used for?', 1, 1),
(9000001007, @DEMO_DISC, @DEMO_TEACH, 6,
 'Опишите тактику ведения пациента с фибрилляцией предсердий и высоким риском инсульта.',
 'Жүрекшелер фибрилляциясы және инсульт қаупі жоғары науқасты жүргізу тактикасын сипаттаңыз.',
 'Describe management of atrial fibrillation with high stroke risk.', 1, 1),
(9000001008, @DEMO_DISC, @DEMO_TEACH, 6,
 'Как корректно подобрать дозировку бета-блокатора при ХСН? Укажите принцип титрования.',
 'ЖЖ (ХСН) кезінде бета-блокатор дозасын қалай дұрыс таңдайсыз? Титрлеу қағидасын көрсетіңіз.',
 'How to choose beta-blocker dosage in chronic heart failure? State titration principle.', 1, 1),
(9000001009, @DEMO_DISC, @DEMO_TEACH, 7,
 'Назначьте схему лечения STEMI с указанием дозировок (антиагреганты/антикоагулянты).',
 'STEMI емдеу сызбасын дозаларымен тағайындаңыз (антиагреганттар/антикоагулянттар).',
 'Provide a STEMI treatment regimen with dosages (antiplatelets/anticoagulants).', 1, 1),
(9000001010, @DEMO_DISC, @DEMO_TEACH, 7,
 'Составьте план дифференциальной диагностики боли в груди (минимум 5 причин).',
 'Кеуде ауыруының дифференциалды диагностика жоспарын құрыңыз (кемінде 5 себеп).',
 'Create a differential diagnosis plan for chest pain (at least five causes).', 1, 1)
ON DUPLICATE KEY UPDATE discipline_id=VALUES(discipline_id), teacher_id=VALUES(teacher_id), course_target=VALUES(course_target), text_ru=VALUES(text_ru), text_kz=VALUES(text_kz), text_en=VALUES(text_en), is_active=1, is_demo=1;

-- Demo validity signals
INSERT INTO question_validity (question_id, topic_id, validity_score, recommended_course, translation_risk, comment, is_demo) VALUES
(9000001001, NULL, 0.92, 3, 'low', 'Соответствует теме и уровню курса. / Fits course level.', 1),
(9000001002, NULL, 0.78, 3, 'medium', 'Возможна неоднозначность формулировки (алгоритм...).', 1),
(9000001003, NULL, 0.74, 4, 'low', 'Хорошо проверяет знание противопоказаний.', 1),
(9000001004, NULL, 0.65, 4, 'high', 'Риск перевода: размытые формулировки, требуется уточнение.', 1),
(9000001005, NULL, 0.88, 5, 'low', 'Базовая фармакотерапия ХСН.', 1),
(9000001006, NULL, 0.81, 5, 'medium', 'Следует указать контекст применения (AF).', 1),
(9000001007, NULL, 0.73, 6, 'medium', 'Нужно уточнить критерии «высокого риска».', 1),
(9000001008, NULL, 0.60, 6, 'high', 'Часто проваливается пункт дозировок/титрования.', 1),
(9000001009, NULL, 0.55, 7, 'high', 'Слишком сложно для части обучающихся; проверить соответствие силабусу.', 1),
(9000001010, NULL, 0.84, 7, 'low', 'Хорошая дифдиагностика, измеряет клиническое мышление.', 1)
ON DUPLICATE KEY UPDATE validity_score=VALUES(validity_score), recommended_course=VALUES(recommended_course), translation_risk=VALUES(translation_risk), comment=VALUES(comment), is_demo=1;

-- Demo stats (difficulty, corr, flags)
INSERT INTO question_stats (exam_id, question_id, attempts, avg_score, difficulty_pct, corr_with_total, flag, recommendation, is_demo) VALUES
(@DEMO_EXAM, 9000001001, 200, 8.10, 0.78, 0.42, 'green', 'Оставить.', 1),
(@DEMO_EXAM, 9000001002, 200, 7.40, 0.63, 0.31, 'yellow', 'Уточнить алгоритм в формулировке.', 1),
(@DEMO_EXAM, 9000001003, 200, 7.20, 0.58, 0.28, 'yellow', 'Проверить уровень сложности и соответствие силлабусу.', 1),
(@DEMO_EXAM, 9000001004, 200, 6.20, 0.44, 0.10, 'red', 'Переформулировать, снизить неоднозначность.', 1),
(@DEMO_EXAM, 9000001005, 200, 8.30, 0.80, 0.36, 'green', 'Оставить.', 1),
(@DEMO_EXAM, 9000001006, 200, 7.80, 0.70, 0.33, 'green', 'Оставить.', 1),
(@DEMO_EXAM, 9000001007, 200, 6.90, 0.52, 0.22, 'yellow', 'Уточнить критерии риска.', 1),
(@DEMO_EXAM, 9000001008, 200, 5.80, 0.39, 0.18, 'red', 'Разбить на под-вопросы, добавить подсказку по титрованию.', 1),
(@DEMO_EXAM, 9000001009, 200, 5.10, 0.28, 0.12, 'red', 'Слишком сложно: рекомендовать для более высокого курса.', 1),
(@DEMO_EXAM, 9000001010, 200, 7.60, 0.66, 0.29, 'green', 'Оставить.', 1)
ON DUPLICATE KEY UPDATE attempts=VALUES(attempts), avg_score=VALUES(avg_score), difficulty_pct=VALUES(difficulty_pct), corr_with_total=VALUES(corr_with_total), flag=VALUES(flag), recommendation=VALUES(recommendation), is_demo=1;

-- Demo criterion stats (show where students fail)
INSERT INTO question_criterion_stats (exam_id, question_id, criterion_id, avg_score, low_score_pct, is_demo) VALUES
(@DEMO_EXAM, 9000001008, 90003, 2.10, 0.62, 1),
(@DEMO_EXAM, 9000001009, 90003, 1.80, 0.71, 1),
(@DEMO_EXAM, 9000001004, 90001, 4.10, 0.35, 1)
ON DUPLICATE KEY UPDATE avg_score=VALUES(avg_score), low_score_pct=VALUES(low_score_pct), is_demo=1;

COMMIT;
