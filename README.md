## 📋 Практическая работа №5
**ФИО:** Кузнецов Д.Д.  
**Группа:** [Указать группу]

---

## 🎯 Цели практической работы

### Основные цели:
- **Освоить навигацию** между экранами в Flutter
- **Управлять состоянием** списка элементов
- **Реализовать CRUD операции** (Create, Read, Update, Delete)
- **Работать с жестами** (тап, свайп)
- **Реализовать поиск** и фильтрацию данных

### Технические задачи:
- Создать кастомный дизайн списка заметок
- Реализовать добавление, редактирование и удаление записей
- Обеспечить сохранение состояния приложения
- Создать интуитивно понятный пользовательский интерфейс

---

## 🛠 Ход работы

### Шаг 1: Модель данных и структура приложения

```dart
class Note {
  String id;
  String title;
  String content;
  DateTime createdAt;
  DateTime updatedAt;

  Note.create({required this.title, required this.content})
      : id = Uuid().v4(),
        createdAt = DateTime.now(),
        updatedAt = DateTime.now();
}
```
 Пояснение: Создана модель данных Note с уникальным идентификатором, временем создания и обновления. Используется пакет uuid для генерации уникальных ID.

### Шаг 2: Главный экран со списком заметок

```dart
Dismissible(
  key: Key(note.id),
  background: Container(
    color: Colors.red,
    alignment: Alignment.centerRight,
    child: Icon(Icons.delete, color: Colors.white),
  ),
  direction: DismissDirection.endToStart,
  confirmDismiss: (direction) async {
    _showDeleteConfirmation(note);
    return false;
  },
  child: Card(
    child: ListTile(
      leading: Icon(Icons.note, color: Colors.blue),
      title: Text(note.title),
      subtitle: Text(note.content),
      trailing: IconButton(
        icon: Icon(Icons.delete, color: Colors.red),
        onPressed: () => _showDeleteConfirmation(note),
      ),
      onTap: () => _editNote(note),
    ),
  ),
)
```

 Пояснение: Реализован Dismissible для свайп-удаления с красным фоном и иконкой. Карточка заметки содержит заголовок, содержание и кнопку удаления.

### Шаг 3: Система поиска и фильтрации

```dart
void _filterNotes(String query) {
  setState(() {
    if (query.isEmpty) {
      filteredNotes = List.from(notes);
    } else {
      filteredNotes = notes
          .where((note) => note.title.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  });
}
```

 Пояснение: Реализована фильтрация заметок по заголовку в реальном времени. Поиск работает без учета регистра.

### Шаг 4: Навигация и передача данных

```dart
// Открытие экрана редактирования
final updatedNote = await Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => NoteEditScreen(existingNote: note),
  ),
);

// Обработка возвращенных данных
if (updatedNote != null) {
  setState(() {
    final index = notes.indexWhere((n) => n.id == updatedNote.id);
    if (index != -1) {
      notes[index] = updatedNote;
    }
  });
}
```

 Пояснение: Использован Navigator.push с возвратом данных для передачи обновленной заметки между экранами.

### Шаг 5: Валидация и сохранение данных

```dart
void _saveNote() {
  final title = titleController.text.trim();
  final content = contentController.text.trim();

  if (title.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Введите заголовок заметки')),
    );
    return;
  }

  Note savedNote = widget.existingNote?.copyWith(
    title: title,
    content: content,
  ) ?? Note.create(title: title, content: content);

  Navigator.pop(context, savedNote);
}
```

 Пояснение: Реализована проверка на пустой заголовок с показом SnackBar. Использован паттерн copyWith для обновления существующих заметок.

### Скриншоты

<img width="1213" height="816" alt="Снимок экрана 2025-10-07 в 11 20 05" src="https://github.com/user-attachments/assets/4975511d-b52b-483e-b665-ddbef0903c48" />
<img width="1207" height="816" alt="Снимок экрана 2025-10-07 в 11 20 28" src="https://github.com/user-attachments/assets/4c5efd02-0bd1-4835-bc90-207252746d69" />
<img width="1212" height="813" alt="Снимок экрана 2025-10-07 в 11 20 57" src="https://github.com/user-attachments/assets/643b8864-813b-4561-a5b4-ca0803ea02cf" />
<img width="1206" height="820" alt="Снимок экрана 2025-10-07 в 11 20 38" src="https://github.com/user-attachments/assets/dd7bafae-ec67-47a3-a606-8f394b36018e" />
<img width="1220" height="817" alt="Снимок экрана 2025-10-07 в 11 19 33" src="https://github.com/user-attachments/assets/5ee57503-9dd6-4ee9-b0f2-9b51442b4f3d" />


