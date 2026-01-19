UAMS (PHP + MySQL) — демо-панель под OpenServer

1) Положи папку uams в OpenServer\domains\uams.loc\ (или любое имя домена)
2) В OpenServer добавь домен uams.loc -> путь к этой папке
3) Запусти модули: Apache + PHP 8.4 + MySQL 8.4
4) Открой в браузере: http://uams.loc/

Подключение к БД настраивается в db.php
По твоей диагностике рабочее:
  host: mysql-8.4.local
  port: 3306
  user: root
  pass: (пусто)
  db: exam_quality

Страницы:
  /index.php         Dashboard (KPI + графики)
  /questions.php      Список вопросов (JOIN disciplines + question_stats)
  /question.php?id=.. Детали вопроса (RU/KZ/EN + статистика + критерии)
  /import_csv.php     Импорт CSV в disciplines/questions/question_stats

Язык интерфейса:
  переключатель вверху (ru/kz/en), сохраняется в сессии
