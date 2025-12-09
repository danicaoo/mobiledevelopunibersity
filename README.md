# Отчет по практическому занятию №12: Разработка приложения для работы с камерой и галереей на Flutter

## Цели работы

- Изучить архитектуру и возможности аппаратной части мобильных устройств
- Ознакомиться с API камеры и галереи во Flutter
- Научиться создавать приложения, использующие камеру и хранилище устройства
- Разобраться с разрешениями, обработкой изображений и сохранением данных
## Ход выполнения

## 1. Создание проекта и установка зависимостей

### Создан новый Flutter проект:

```bash
flutter create camera_app
cd camera_app
```

### В файл pubspec.yaml добавлены необходимые зависимости:

```yaml
dependencies:
  flutter:
    sdk: flutter
  image_picker: ^1.1.1
  permission_handler: ^11.3.0
  path_provider: ^2.1.4
  image: ^4.1.4
```

### Установка зависимостей выполнена командой:

```bash
flutter pub get
```

## 2. Настройка разрешений

### Для Android (android/app/src/main/AndroidManifest.xml):

```xml
<uses-permission android:name="android.permission.CAMERA"/>
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
```

### Для iOS (ios/Runner/Info.plist):

```xml
<key>NSCameraUsageDescription</key>
<string>Для работы приложения требуется доступ к камере</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>Для выбора изображений из галереи требуется разрешение</string>
```

## 3. Реализация основного функционала

### Структура приложения:

CameraApp - корневой виджет приложения
CameraPage - основной экран с интерфейсом
_CameraPageState - состояние с логикой работы
Ключевые функции:

Проверка и запрос разрешений:

```dart
Future<void> _checkPermissions() async {
  await Permission.camera.request();
  await Permission.storage.request();
  await Permission.photos.request();
}
```
Получение изображения из камеры или галереи:
```dart
Future<void> _getImage(ImageSource source) async {
  await _checkPermissions();
  final XFile? pickedFile = await _picker.pickImage(
    source: source,
    maxWidth: 1920,
    maxHeight: 1080,
    imageQuality: 90,
  );
  
  if (pickedFile != null) {
    setState(() => _image = File(pickedFile.path));
  }
}
```
Применение фильтров к изображению:
```dart
Future<File?> _applyFilters(File imageFile) async {
  // Применение черно-белого фильтра
  if (_isGrayscale) {
    image = img.grayscale(image);
  }
  
  // Применение размытия
  if (_isBlurred) {
    image = img.gaussianBlur(image, radius: 5);
  }
  
  // Инверсия цветов
  if (_isInverted) {
    image = img.invert(image);
  }
}
```
Сохранение изображения:
```dart
Future<void> _saveImage() async {
  final directory = await getApplicationDocumentsDirectory();
  final fileName = 'photo_${DateTime.now().millisecondsSinceEpoch}.jpg';
  final newPath = '${directory.path}/$fileName';
  
  final savedFile = await _image!.copy(newPath);
}
```
## 4. Интерфейс приложения

Приложение содержит следующие элементы:

Область предпросмотра изображения
Кнопки "Сделать фото" и "Выбрать из галереи"
Фильтры изображения (черно-белый, размытие, инверсия)
Кнопка сохранения фото
Отображение статистики
Скриншоты

### Скриншот 1: Главный экран приложения

<img width="309" height="645" alt="Снимок экрана 2025-12-09 в 10 05 49" src="https://github.com/user-attachments/assets/a7efe5f3-9c5d-4f1d-80b1-b1e15015f1d3" />

Описание: Главный экран с кнопками управления и областью предпросмотра.

### Скриншот 2: Выбор изображения из галереи

<img width="533" height="823" alt="Снимок экрана 2025-12-09 в 10 17 38" src="https://github.com/user-attachments/assets/879b9e54-6227-47f8-a646-6eddf3c3d4fa" />

Описание: Диалоговое окно выбора изображения из галереи устройства.

### Скриншот 3: Отображение выбранного фото

<img width="318" height="643" alt="Снимок экрана 2025-12-09 в 10 05 54" src="https://github.com/user-attachments/assets/7aeb101d-2ad7-4ad2-90ce-2a5ade2e06b9" />

Описание: Выбранное изображение отображается в области предпросмотра.

### Скриншот 4: Уведомление о сохранении

<img width="306" height="659" alt="Снимок экрана 2025-12-09 в 10 05 59" src="https://github.com/user-attachments/assets/8a19abc4-9563-4540-9660-db57ddec497d" />

Описание: Snackbar-уведомление об успешном сохранении изображения.
