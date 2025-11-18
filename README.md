# notes_sqlite_app_kuznetsovdd_

<img width="1212" height="815" alt="Снимок экрана 2025-11-18 в 11 46 04" src="https://github.com/user-attachments/assets/1ed20f82-1096-4f8a-b81a-11f925c5db5f" />
<img width="1208" height="822" alt="Снимок экрана 2025-11-18 в 11 46 26" src="https://github.com/user-attachments/assets/557adf1a-4441-4956-bc90-2a695b8a5e01" />
<img width="1211" height="816" alt="Снимок экрана 2025-11-18 в 11 46 33" src="https://github.com/user-attachments/assets/18e33d39-f0e3-465c-97d2-5a06226b08d3" />
<img width="1208" height="819" alt="Снимок экрана 2025-11-18 в 11 46 44" src="https://github.com/user-attachments/assets/7084c59c-9a44-49fe-af03-5186bcfb8be7" />
<img width="1212" height="823" alt="Снимок экрана 2025-11-18 в 11 46 39" src="https://github.com/user-attachments/assets/d8b3bef2-a05a-4f95-94cc-3685418e8e39" />
<img width="1266" height="800" alt="Снимок экрана 2025-11-18 в 11 46 48" src="https://github.com/user-attachments/assets/7005089c-9e94-4e85-a2b3-a9d7b2548d6e" />

### Файл БД SQLite хранится в песочнице приложения: на Android по пути /data/data/[package_name]/databases/app.db, на iOS в папке Documents/app.db. Для веб-реализации используется эмуляция хранения в памяти.

### Таблица notes содержит поля: id (первичный ключ), title, body, created_at, updated_at (в Unix-миллисекундах) и is_favorite. Созданы индексы idx_notes_created_at для сортировки и idx_notes_favorite для фильтрации.

### CRUD реализован через класс DBHelper: создание через insert(), чтение через query() с сортировкой по дате, обновление через update() по ID, удаление через delete(). Все операции используют преобразование модели Note в Map через toMap()/fromMap() для совместимости с SQLite.

### Выводы и решения проблем:

- Решение проблемы MissingPluginException для веб-режима
- Реализация платформо-зависимой логики хранения данных
- Важность отделения бизнес-логики от UI слоя
