# 📱 Приложение: API Notes Feed

Мини-приложение для работы с заметками через внешний API с поддержкой полного CRUD, пагинацией и обработкой ошибок.

## 📋 Содержание отчёта

### 1. Цели занятия

Понять базовые понятия HTTP/REST: методы, эндпоинты, коды ответов
Освоить интеграцию Flutter-приложения с внешним API
Научиться выстраивать слой данных с репозиторием
Реализовать список сущностей из публичного API + экран деталей + форму создания/редактирования
Разобраться с пагинацией, фильтрацией и обработкой ошибок

###2. Ход работы

### 2.1 Выбор API

Вариант A: Только чтение
Использован публичный API: https://jsonplaceholder.typicode.com

Базовый URL: https://jsonplaceholder.typicode.com

Эндпоинты:

GET /posts - получение списка постов
GET /posts/{id} - получение конкретного поста
POST /posts - создание поста (демо)
PATCH /posts/{id} - обновление поста (демо)
DELETE /posts/{id} - удаление поста (демо)
2.2 Структура проекта

```text
lib/
├── main.dart                    # Точка входа приложения
├── data/
│   ├── api_client.dart         # HTTP клиент на основе Dio
│   └── notes_repository.dart   # Репозиторий для работы с данными
├── models/
│   └── note.dart              # Модель данных Note
└── pages/
    ├── notes_page.dart        # Экран списка с пагинацией
    └── note_details_page.dart # Экран деталей записи
```


### 2.3 Ключевые фрагменты кода

Модель данных (lib/models/note.dart):

```dart
class Note {
  final int id;
  final String title;
  final String body;
  final int userId;

  Note({required this.id, required this.title, required this.body, required this.userId});

  factory Note.fromJson(Map<String, dynamic> json) => Note(
    id: json['id'] ?? 0,
    title: json['title'] ?? '',
    body: json['body'] ?? json['content'] ?? '',
    userId: json['userId'] ?? 0,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'body': body,
    'userId': userId,
  };
}
API клиент (lib/data/api_client.dart):
```


```dart
class ApiClient {
  final Dio dio;

  ApiClient({required String baseUrl})
      : dio = Dio(
          BaseOptions(
            baseUrl: baseUrl,
            connectTimeout: const Duration(seconds: 30),
            receiveTimeout: const Duration(seconds: 30),
            headers: {'Content-Type': 'application/json'},
          ),
        ) {
    dio.interceptors.add(LogInterceptor(responseBody: true, error: true));
  }
}
Репозиторий (lib/data/notes_repository.dart):
```


```dart
class NotesRepository {
  final ApiClient _client;
  bool _useMockData = false;

  Future<List<Note>> list({int page = 1, int limit = 10}) async {
    if (_useMockData) return _getMockNotes(page: page, limit: limit);
    
    try {
      final response = await _client.dio.get(
        '/posts',
        queryParameters: {'_page': page, '_limit': limit},
      );
      return (response.data as List).map((e) => Note.fromJson(e)).toList();
    } on DioException {
      _useMockData = true;
      return _getMockNotes(page: page, limit: limit);
    }
  }
}
Главный экран с пагинацией (lib/pages/notes_page.dart):
```

```dart
Future<void> _loadMore() async {
  if (!_canLoadMore || _loading) return;
  setState(() => _loading = true);
  
  try {
    final batch = await repo.list(page: _page, limit: 10);
    setState(() {
      _items.addAll(batch);
      _canLoadMore = batch.isNotEmpty;
      _page++;
    });
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Ошибка: $e'), action: SnackBarAction(label: 'Повторить', onPressed: _loadInitialData)),
    );
  } finally {
    setState(() => _loading = false);
  }
}
```

## 2.4 Реализованные функции

Пагинация

Подгрузка по 10 записей за раз
Кнопка "Загрузить еще" внизу списка
Автоматическая подгрузка при прокрутке
Флаг _canLoadMore для контроля доступности данных
Обработка ошибок и таймауты

Таймауты подключения: 30 секунд
Перехват сетевых ошибок через Dio interceptors
Автоматический переход на мок-данные при недоступности API
SnackBar с информацией об ошибке и кнопкой "Повторить"
UX состояния

Loading: индикатор загрузки при первоначальной загрузке
Empty: сообщение при отсутствии данных
Error: экран с ошибкой и кнопкой повтора
Data: отображение списка с данными
Дополнительные функции

Pull-to-refresh для обновления списка
Undo на удаление (SnackBar с отменой)
Индикатор использования мок-данных
Валидация полей при создании записи

## 3. Результаты (скриншоты)

Скриншот 1: Экран списка (данные получены)

<img width="1212" height="820" alt="Снимок экрана 2025-12-02 в 11 35 24" src="https://github.com/user-attachments/assets/4b06ac1c-5ce7-4aa3-884c-e9f228b1ee0d" />

Скриншот 2: Диалог создания и результат

<img width="1206" height="814" alt="Снимок экрана 2025-12-02 в 11 35 45" src="https://github.com/user-attachments/assets/dd5ae767-8324-47fc-8f21-31c99f1ee4df" />

<img width="1209" height="828" alt="Снимок экрана 2025-12-02 в 11 35 53" src="https://github.com/user-attachments/assets/839927d4-7f7c-410c-a87c-3e8061647c10" />

<img width="1219" height="821" alt="Снимок экрана 2025-12-02 в 11 36 01" src="https://github.com/user-attachments/assets/e70e532f-9fb5-4347-a6ab-b689ec18649a" />

## 4. Трудности и решения

### Проблема 1: Таймауты подключения к API

Симптом: Приложение падало с ошибкой DioExceptionType.connectionTimeout
Решение:

Увеличение таймаутов до 30 секунд
Добавление fallback на мок-данные
Индикация пользователю о проблемах с сетью
### Проблема 2: Обработка ошибок при недоступности API

Симптом: При отсутствии интернета приложение показывало пустой экран
Решение:

Реализация автоматического переключения на мок-данные
Понятные сообщения об ошибках
Кнопка "Использовать демо-данные"
Проблема 3: Пагинация с JSONPlaceholder

Симптом: API не поддерживает реальную пагинацию с общим количеством записей
Решение:

Использование параметров _page и _limit
Определение конца данных по пустому ответу
Индикация "Демо-данные" при использовании моков
Проблема 4: Состояния загрузки

Симптом: Плохой UX при переходе между экранами
Решение:

Реализация всех состояний: loading, empty, error, data
Скелетоны при загрузке
Плавные переходы между состояниями
