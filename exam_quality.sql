-- phpMyAdmin SQL Dump
-- version 5.2.3
-- https://www.phpmyadmin.net/
--
-- Хост: MySQL-8.4:3306
-- Время создания: Янв 18 2026 г., 22:32
-- Версия сервера: 8.4.6
-- Версия PHP: 8.4.13

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- База данных: `exam_quality`
--

-- --------------------------------------------------------

--
-- Структура таблицы `answers`
--

CREATE TABLE `answers` (
  `answer_id` bigint NOT NULL,
  `exam_id` bigint NOT NULL,
  `question_id` bigint NOT NULL,
  `student_id` bigint NOT NULL,
  `answer_text` mediumtext,
  `score_total` decimal(7,2) NOT NULL DEFAULT '0.00',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `answer_criteria_scores`
--

CREATE TABLE `answer_criteria_scores` (
  `answer_id` bigint NOT NULL,
  `criterion_id` int NOT NULL,
  `score` decimal(7,2) NOT NULL DEFAULT '0.00'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `departments`
--

CREATE TABLE `departments` (
  `department_id` int NOT NULL,
  `name` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `disciplines`
--

CREATE TABLE `disciplines` (
  `discipline_id` int NOT NULL,
  `department_id` int DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `exams`
--

CREATE TABLE `exams` (
  `exam_id` bigint NOT NULL,
  `discipline_id` int NOT NULL,
  `rubric_id` int NOT NULL,
  `exam_date` date NOT NULL,
  `note` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `exam_language_stats`
--

CREATE TABLE `exam_language_stats` (
  `exam_id` bigint NOT NULL,
  `language` enum('ru','kz','en') NOT NULL,
  `students_count` int NOT NULL DEFAULT '0',
  `avg_total_score` decimal(7,2) DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `exam_total_scores`
--

CREATE TABLE `exam_total_scores` (
  `exam_id` bigint NOT NULL,
  `student_id` bigint NOT NULL,
  `total_score` decimal(7,2) NOT NULL,
  `language` enum('ru','kz','en') DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `questions`
--

CREATE TABLE `questions` (
  `question_id` bigint NOT NULL,
  `discipline_id` int NOT NULL,
  `teacher_id` int DEFAULT NULL,
  `course_target` tinyint UNSIGNED DEFAULT NULL,
  `text_ru` text,
  `text_kz` text,
  `text_en` text,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `question_criterion_stats`
--

CREATE TABLE `question_criterion_stats` (
  `exam_id` bigint NOT NULL,
  `question_id` bigint NOT NULL,
  `criterion_id` int NOT NULL,
  `avg_score` decimal(7,2) DEFAULT NULL,
  `low_score_pct` decimal(6,3) DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `question_stats`
--

CREATE TABLE `question_stats` (
  `exam_id` bigint NOT NULL,
  `question_id` bigint NOT NULL,
  `attempts` int NOT NULL DEFAULT '0',
  `avg_score` decimal(7,2) DEFAULT NULL,
  `difficulty_pct` decimal(6,3) DEFAULT NULL,
  `corr_with_total` decimal(8,5) DEFAULT NULL,
  `flag` enum('green','yellow','red') NOT NULL DEFAULT 'yellow',
  `recommendation` text,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `question_validity`
--

CREATE TABLE `question_validity` (
  `question_id` bigint NOT NULL,
  `topic_id` int DEFAULT NULL,
  `validity_score` decimal(5,4) DEFAULT NULL,
  `recommended_course` tinyint UNSIGNED DEFAULT NULL,
  `translation_risk` enum('low','medium','high') DEFAULT NULL,
  `comment` text,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `rubrics`
--

CREATE TABLE `rubrics` (
  `rubric_id` int NOT NULL,
  `discipline_id` int NOT NULL,
  `name` varchar(255) NOT NULL,
  `version` varchar(32) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `rubric_criteria`
--

CREATE TABLE `rubric_criteria` (
  `criterion_id` int NOT NULL,
  `rubric_id` int NOT NULL,
  `title` varchar(255) NOT NULL,
  `max_score` tinyint UNSIGNED NOT NULL DEFAULT '10',
  `order_index` int NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `students`
--

CREATE TABLE `students` (
  `student_id` bigint NOT NULL,
  `group_id` int DEFAULT NULL,
  `language` enum('ru','kz','en') DEFAULT NULL,
  `region_type` enum('city','village','unknown') NOT NULL DEFAULT 'unknown',
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `student_groups`
--

CREATE TABLE `student_groups` (
  `group_id` int NOT NULL,
  `name` varchar(64) NOT NULL,
  `course` tinyint UNSIGNED NOT NULL,
  `language` enum('ru','kz','en') NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `syllabus_topics`
--

CREATE TABLE `syllabus_topics` (
  `topic_id` int NOT NULL,
  `discipline_id` int NOT NULL,
  `course` tinyint UNSIGNED NOT NULL,
  `title` varchar(255) NOT NULL,
  `keywords` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `teachers`
--

CREATE TABLE `teachers` (
  `teacher_id` int NOT NULL,
  `discipline_id` int DEFAULT NULL,
  `role` enum('admin','teacher','analyst') NOT NULL DEFAULT 'teacher',
  `login` varchar(64) DEFAULT NULL,
  `password_hash` varchar(255) DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Дублирующая структура для представления `v_question_exam_stats`
-- (См. Ниже фактическое представление)
--
CREATE TABLE `v_question_exam_stats` (
`exam_id` bigint
,`exam_date` date
,`discipline_id` int
,`discipline_name` varchar(255)
,`question_id` bigint
,`attempts` int
,`avg_score` decimal(7,2)
,`difficulty_pct` decimal(6,3)
,`corr_with_total` decimal(8,5)
,`flag` enum('green','yellow','red')
,`recommendation` text
,`updated_at` timestamp
);

-- --------------------------------------------------------

--
-- Дублирующая структура для представления `v_question_list`
-- (См. Ниже фактическое представление)
--
CREATE TABLE `v_question_list` (
`question_id` bigint
,`discipline_id` int
,`discipline_name` varchar(255)
,`teacher_id` int
,`course_target` tinyint unsigned
,`question_preview` varchar(120)
,`is_active` tinyint(1)
,`created_at` timestamp
);

--
-- Индексы сохранённых таблиц
--

--
-- Индексы таблицы `answers`
--
ALTER TABLE `answers`
  ADD PRIMARY KEY (`answer_id`),
  ADD UNIQUE KEY `uq_answer_one_per_question` (`exam_id`,`question_id`,`student_id`),
  ADD KEY `fk_answers_question` (`question_id`),
  ADD KEY `idx_answers_exam_question` (`exam_id`,`question_id`),
  ADD KEY `idx_answers_student_exam` (`student_id`,`exam_id`);

--
-- Индексы таблицы `answer_criteria_scores`
--
ALTER TABLE `answer_criteria_scores`
  ADD PRIMARY KEY (`answer_id`,`criterion_id`),
  ADD KEY `idx_acs_criterion` (`criterion_id`);

--
-- Индексы таблицы `departments`
--
ALTER TABLE `departments`
  ADD PRIMARY KEY (`department_id`);

--
-- Индексы таблицы `disciplines`
--
ALTER TABLE `disciplines`
  ADD PRIMARY KEY (`discipline_id`),
  ADD KEY `fk_disciplines_department` (`department_id`);

--
-- Индексы таблицы `exams`
--
ALTER TABLE `exams`
  ADD PRIMARY KEY (`exam_id`),
  ADD KEY `fk_exams_rubric` (`rubric_id`),
  ADD KEY `idx_exams_disc_date` (`discipline_id`,`exam_date`);

--
-- Индексы таблицы `exam_language_stats`
--
ALTER TABLE `exam_language_stats`
  ADD PRIMARY KEY (`exam_id`,`language`);

--
-- Индексы таблицы `exam_total_scores`
--
ALTER TABLE `exam_total_scores`
  ADD PRIMARY KEY (`exam_id`,`student_id`),
  ADD KEY `fk_totals_student` (`student_id`),
  ADD KEY `idx_totals_exam` (`exam_id`),
  ADD KEY `idx_totals_lang` (`exam_id`,`language`);

--
-- Индексы таблицы `questions`
--
ALTER TABLE `questions`
  ADD PRIMARY KEY (`question_id`),
  ADD KEY `idx_questions_disc` (`discipline_id`),
  ADD KEY `idx_questions_teacher` (`teacher_id`),
  ADD KEY `idx_questions_course` (`course_target`);

--
-- Индексы таблицы `question_criterion_stats`
--
ALTER TABLE `question_criterion_stats`
  ADD PRIMARY KEY (`exam_id`,`question_id`,`criterion_id`),
  ADD KEY `fk_qcs_question` (`question_id`),
  ADD KEY `fk_qcs_criterion` (`criterion_id`);

--
-- Индексы таблицы `question_stats`
--
ALTER TABLE `question_stats`
  ADD PRIMARY KEY (`exam_id`,`question_id`),
  ADD KEY `fk_qs_question` (`question_id`),
  ADD KEY `idx_qs_flag` (`exam_id`,`flag`),
  ADD KEY `idx_qs_corr` (`exam_id`,`corr_with_total`);

--
-- Индексы таблицы `question_validity`
--
ALTER TABLE `question_validity`
  ADD PRIMARY KEY (`question_id`),
  ADD KEY `fk_qv_topic` (`topic_id`);

--
-- Индексы таблицы `rubrics`
--
ALTER TABLE `rubrics`
  ADD PRIMARY KEY (`rubric_id`),
  ADD KEY `idx_rubrics_disc` (`discipline_id`);

--
-- Индексы таблицы `rubric_criteria`
--
ALTER TABLE `rubric_criteria`
  ADD PRIMARY KEY (`criterion_id`),
  ADD KEY `idx_criteria_rubric` (`rubric_id`),
  ADD KEY `idx_criteria_order` (`rubric_id`,`order_index`);

--
-- Индексы таблицы `students`
--
ALTER TABLE `students`
  ADD PRIMARY KEY (`student_id`),
  ADD KEY `fk_students_group` (`group_id`);

--
-- Индексы таблицы `student_groups`
--
ALTER TABLE `student_groups`
  ADD PRIMARY KEY (`group_id`),
  ADD UNIQUE KEY `uq_group_name_course` (`name`,`course`);

--
-- Индексы таблицы `syllabus_topics`
--
ALTER TABLE `syllabus_topics`
  ADD PRIMARY KEY (`topic_id`),
  ADD KEY `idx_topics_disc_course` (`discipline_id`,`course`);

--
-- Индексы таблицы `teachers`
--
ALTER TABLE `teachers`
  ADD PRIMARY KEY (`teacher_id`),
  ADD UNIQUE KEY `login` (`login`),
  ADD KEY `fk_teachers_discipline` (`discipline_id`);

--
-- AUTO_INCREMENT для сохранённых таблиц
--

--
-- AUTO_INCREMENT для таблицы `answers`
--
ALTER TABLE `answers`
  MODIFY `answer_id` bigint NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `departments`
--
ALTER TABLE `departments`
  MODIFY `department_id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `disciplines`
--
ALTER TABLE `disciplines`
  MODIFY `discipline_id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `exams`
--
ALTER TABLE `exams`
  MODIFY `exam_id` bigint NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `rubrics`
--
ALTER TABLE `rubrics`
  MODIFY `rubric_id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `rubric_criteria`
--
ALTER TABLE `rubric_criteria`
  MODIFY `criterion_id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `student_groups`
--
ALTER TABLE `student_groups`
  MODIFY `group_id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `syllabus_topics`
--
ALTER TABLE `syllabus_topics`
  MODIFY `topic_id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `teachers`
--
ALTER TABLE `teachers`
  MODIFY `teacher_id` int NOT NULL AUTO_INCREMENT;

-- --------------------------------------------------------

--
-- Структура для представления `v_question_exam_stats`
--
DROP TABLE IF EXISTS `v_question_exam_stats`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `v_question_exam_stats`  AS SELECT `qs`.`exam_id` AS `exam_id`, `e`.`exam_date` AS `exam_date`, `e`.`discipline_id` AS `discipline_id`, `d`.`name` AS `discipline_name`, `qs`.`question_id` AS `question_id`, `qs`.`attempts` AS `attempts`, `qs`.`avg_score` AS `avg_score`, `qs`.`difficulty_pct` AS `difficulty_pct`, `qs`.`corr_with_total` AS `corr_with_total`, `qs`.`flag` AS `flag`, `qs`.`recommendation` AS `recommendation`, `qs`.`updated_at` AS `updated_at` FROM ((`question_stats` `qs` join `exams` `e` on((`e`.`exam_id` = `qs`.`exam_id`))) join `disciplines` `d` on((`d`.`discipline_id` = `e`.`discipline_id`))) ;

-- --------------------------------------------------------

--
-- Структура для представления `v_question_list`
--
DROP TABLE IF EXISTS `v_question_list`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `v_question_list`  AS SELECT `q`.`question_id` AS `question_id`, `q`.`discipline_id` AS `discipline_id`, `d`.`name` AS `discipline_name`, `q`.`teacher_id` AS `teacher_id`, `q`.`course_target` AS `course_target`, left(coalesce(`q`.`text_ru`,`q`.`text_kz`,`q`.`text_en`,''),120) AS `question_preview`, `q`.`is_active` AS `is_active`, `q`.`created_at` AS `created_at` FROM (`questions` `q` join `disciplines` `d` on((`d`.`discipline_id` = `q`.`discipline_id`))) ;

--
-- Ограничения внешнего ключа сохраненных таблиц
--

--
-- Ограничения внешнего ключа таблицы `answers`
--
ALTER TABLE `answers`
  ADD CONSTRAINT `fk_answers_exam` FOREIGN KEY (`exam_id`) REFERENCES `exams` (`exam_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_answers_question` FOREIGN KEY (`question_id`) REFERENCES `questions` (`question_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_answers_student` FOREIGN KEY (`student_id`) REFERENCES `students` (`student_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ограничения внешнего ключа таблицы `answer_criteria_scores`
--
ALTER TABLE `answer_criteria_scores`
  ADD CONSTRAINT `fk_acs_answer` FOREIGN KEY (`answer_id`) REFERENCES `answers` (`answer_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_acs_criterion` FOREIGN KEY (`criterion_id`) REFERENCES `rubric_criteria` (`criterion_id`) ON DELETE RESTRICT ON UPDATE CASCADE;

--
-- Ограничения внешнего ключа таблицы `disciplines`
--
ALTER TABLE `disciplines`
  ADD CONSTRAINT `fk_disciplines_department` FOREIGN KEY (`department_id`) REFERENCES `departments` (`department_id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Ограничения внешнего ключа таблицы `exams`
--
ALTER TABLE `exams`
  ADD CONSTRAINT `fk_exams_discipline` FOREIGN KEY (`discipline_id`) REFERENCES `disciplines` (`discipline_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_exams_rubric` FOREIGN KEY (`rubric_id`) REFERENCES `rubrics` (`rubric_id`) ON DELETE RESTRICT ON UPDATE CASCADE;

--
-- Ограничения внешнего ключа таблицы `exam_language_stats`
--
ALTER TABLE `exam_language_stats`
  ADD CONSTRAINT `fk_els_exam` FOREIGN KEY (`exam_id`) REFERENCES `exams` (`exam_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ограничения внешнего ключа таблицы `exam_total_scores`
--
ALTER TABLE `exam_total_scores`
  ADD CONSTRAINT `fk_totals_exam` FOREIGN KEY (`exam_id`) REFERENCES `exams` (`exam_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_totals_student` FOREIGN KEY (`student_id`) REFERENCES `students` (`student_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ограничения внешнего ключа таблицы `questions`
--
ALTER TABLE `questions`
  ADD CONSTRAINT `fk_questions_discipline` FOREIGN KEY (`discipline_id`) REFERENCES `disciplines` (`discipline_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_questions_teacher` FOREIGN KEY (`teacher_id`) REFERENCES `teachers` (`teacher_id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Ограничения внешнего ключа таблицы `question_criterion_stats`
--
ALTER TABLE `question_criterion_stats`
  ADD CONSTRAINT `fk_qcs_criterion` FOREIGN KEY (`criterion_id`) REFERENCES `rubric_criteria` (`criterion_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_qcs_exam` FOREIGN KEY (`exam_id`) REFERENCES `exams` (`exam_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_qcs_question` FOREIGN KEY (`question_id`) REFERENCES `questions` (`question_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ограничения внешнего ключа таблицы `question_stats`
--
ALTER TABLE `question_stats`
  ADD CONSTRAINT `fk_qs_exam` FOREIGN KEY (`exam_id`) REFERENCES `exams` (`exam_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_qs_question` FOREIGN KEY (`question_id`) REFERENCES `questions` (`question_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ограничения внешнего ключа таблицы `question_validity`
--
ALTER TABLE `question_validity`
  ADD CONSTRAINT `fk_qv_question` FOREIGN KEY (`question_id`) REFERENCES `questions` (`question_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_qv_topic` FOREIGN KEY (`topic_id`) REFERENCES `syllabus_topics` (`topic_id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Ограничения внешнего ключа таблицы `rubrics`
--
ALTER TABLE `rubrics`
  ADD CONSTRAINT `fk_rubrics_discipline` FOREIGN KEY (`discipline_id`) REFERENCES `disciplines` (`discipline_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ограничения внешнего ключа таблицы `rubric_criteria`
--
ALTER TABLE `rubric_criteria`
  ADD CONSTRAINT `fk_criteria_rubric` FOREIGN KEY (`rubric_id`) REFERENCES `rubrics` (`rubric_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ограничения внешнего ключа таблицы `students`
--
ALTER TABLE `students`
  ADD CONSTRAINT `fk_students_group` FOREIGN KEY (`group_id`) REFERENCES `student_groups` (`group_id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Ограничения внешнего ключа таблицы `syllabus_topics`
--
ALTER TABLE `syllabus_topics`
  ADD CONSTRAINT `fk_topics_discipline` FOREIGN KEY (`discipline_id`) REFERENCES `disciplines` (`discipline_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ограничения внешнего ключа таблицы `teachers`
--
ALTER TABLE `teachers`
  ADD CONSTRAINT `fk_teachers_discipline` FOREIGN KEY (`discipline_id`) REFERENCES `disciplines` (`discipline_id`) ON DELETE SET NULL ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
