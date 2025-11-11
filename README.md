# 📝 Supabase Notes App

**Полнофункциональное приложение для управления заметками с синхронизацией в реальном времени через Supabase PostgreSQL**
---

## 🎯 О проекте

**Supabase Notes App** - это кроссплатформенное приложение, разработанное в рамках практического занятия №9 по дисциплине "Программирование корпоративных систем". Приложение демонстрирует полную интеграцию Flutter с Supabase, реализуя все CRUD-операции с real-time обновлениями и enterprise-уровнем безопасности через Row Level Security.

### 📚 Учебные цели:
- Освоить подключение Flutter-приложения к Supabase (PostgreSQL + Auth + Realtime)
- Реализовать базовый CRUD с реактивным списком
- Настроить Row Level Security и безопасные политики доступа
- Отработать работу с аутентификацией и потоковыми данными

---

## 🚀 Функциональность

### ✅ Реализованные возможности:

| Функция | Статус | Описание |
|---------|--------|-----------|
| 🔐 Аутентификация | ✅ | Регистрация и вход по email/password |
| 📝 Создание заметок | ✅ | Диалоговое окно с валидацией |
| 👁️ Просмотр списка | ✅ | Real-time обновления через StreamBuilder |
| ✏️ Редактирование | ✅ | Тап по карточке для изменения |
| 🗑️ Удаление | ✅ | Кнопка удаления с подтверждением |
| 🔄 Real-time синхронизация | ✅ | Мгновенные обновления через Supabase Realtime |
| 🛡️ Безопасность RLS | ✅ | Доступ только к своим заметкам |

---

## 🛠 Технологии

### 📱 Frontend:
```yaml
Flutter: 3.19.0
Dart: 3.3.0
Material Design 3: ✅
supabase_flutter: ^2.1.1
```

### ☁️ Backend:

```yaml
Supabase: ✅
PostgreSQL: ✅
Row Level Security: ✅
JWT Authentication: ✅
Realtime Subscriptions: ✅
```

## 📸 Демонстрация работы

<img width="1219" height="830" alt="Снимок экрана 2025-11-11 в 13 41 09" src="https://github.com/user-attachments/assets/61d5097c-1db9-4e20-b471-f94ddb8e7bb9" />

<img width="1212" height="817" alt="Снимок экрана 2025-11-11 в 13 41 51" src="https://github.com/user-attachments/assets/0b28caef-20b2-4899-b6d0-76ff639bc727" />

<img width="1216" height="818" alt="Снимок экрана 2025-11-11 в 13 42 12" src="https://github.com/user-attachments/assets/585bee91-f915-4b45-b2e2-4a5dea0976d1" />

<img width="1219" height="820" alt="Снимок экрана 2025-11-11 в 13 42 17" src="https://github.com/user-attachments/assets/a31c2714-4e01-44ad-82b3-9a5862099378" />

<img width="1213" height="823" alt="Снимок экрана 2025-11-11 в 13 42 34" src="https://github.com/user-attachments/assets/603b19e7-d61f-4e4f-a576-0afcbbdba266" />

<img width="1220" height="826" alt="Снимок экрана 2025-11-11 в 13 42 53" src="https://github.com/user-attachments/assets/8ae385c5-b5a7-4b5c-a6e4-9258b85e3263" />

<img width="1510" height="946" alt="image" src="https://github.com/user-attachments/assets/8339f2e7-4d38-410e-a73b-01f17a312871" />

## 🐛 Решенные проблемы

### Проблемa Решение
- Permission denied	Настройка RLS политик и проверка auth.uid()
- Real-time не работает	Добавление primaryKey в stream() и проверка фильтров
- Ошибки контекста	Добавление проверок mounted в асинхронных операциях
- Web asset loading	Отказ от flutter_dotenv в пользу констант
