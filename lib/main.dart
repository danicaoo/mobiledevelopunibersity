 import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as img;

void main() => runApp(const CameraApp());

class CameraApp extends StatelessWidget {
  const CameraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Camera Demo',
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const CameraPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  File? _image;
  String? _savedImagePath;
  final ImagePicker _picker = ImagePicker();
  final List<File> _savedImages = [];

  // Состояния фильтров
  bool _isGrayscale = false;
  bool _isBlurred = false;
  bool _isInverted = false;

  // Проверка и запрос разрешений
  Future<void> _checkPermissions() async {
    final Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
      Permission.storage,
      Permission.photos,
    ].request();

    if (statuses[Permission.camera] != PermissionStatus.granted ||
        statuses[Permission.storage] != PermissionStatus.granted) {
      _showPermissionDialog();
    }
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Требуются разрешения'),
          content: const Text(
            'Для полной работы приложения необходимы разрешения на доступ к камере и хранилищу.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Отмена'),
            ),
            TextButton(
              onPressed: () => openAppSettings(),
              child: const Text('Настройки'),
            ),
          ],
        );
      },
    );
  }

  // Получение изображения
  Future<void> _getImage(ImageSource source) async {
    await _checkPermissions();

    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 90,
      );

      if (pickedFile != null) {
        final File imageFile = File(pickedFile.path);
        File? processedImage = await _applyFilters(imageFile);
        
        setState(() {
          _image = processedImage ?? imageFile;
          _savedImagePath = null;
        });
      }
    } catch (e) {
      _showErrorSnackBar('Ошибка: $e');
    }
  }

  // Применение фильтров (ИСПРАВЛЕННАЯ ЧАСТЬ)
  Future<File?> _applyFilters(File imageFile) async {
    if (!_isGrayscale && !_isBlurred && !_isInverted) {
      return null;
    }

    try {
      final bytes = await imageFile.readAsBytes();
      img.Image? image = img.decodeImage(bytes);
      
      if (image == null) return null;

      // Применяем фильтры
      if (_isGrayscale) {
        image = img.grayscale(image);
      }
      
      if (_isBlurred) {
        // ИСПРАВЛЕНО: правильное использование gaussianBlur
        image = img.gaussianBlur(image, radius: 5);
      }
      
      if (_isInverted) {
        image = img.invert(image);
      }

      // Сохраняем обработанное изображение
      final dir = await getTemporaryDirectory();
      final newPath = '${dir.path}/processed_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final newFile = File(newPath);
      await newFile.writeAsBytes(img.encodeJpg(image));
      
      return newFile;
    } catch (e) {
      _showErrorSnackBar('Ошибка обработки: $e');
      return null;
    }
  }

  // Сохранение изображения
  Future<void> _saveImage() async {
    if (_image == null) {
      _showErrorSnackBar('Нет изображения для сохранения');
      return;
    }

    try {
      final directory = await getApplicationDocumentsDirectory();
      final fileName = 'photo_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final newPath = '${directory.path}/$fileName';
      
      final savedFile = await _image!.copy(newPath);
      
      setState(() {
        _savedImagePath = savedFile.path;
        _savedImages.add(savedFile);
      });
      
      _showSuccessSnackBar('Изображение сохранено');
    } catch (e) {
      _showErrorSnackBar('Ошибка сохранения: $e');
    }
  }

  // Показать все сохраненные изображения
  void _showSavedImages() {
    if (_savedImages.isEmpty) {
      _showErrorSnackBar('Нет сохраненных изображений');
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            padding: const EdgeInsets.all(16),
            width: 300,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Сохраненные изображения',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 200,
                  child: ListView.builder(
                    itemCount: _savedImages.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: Image.file(
                          _savedImages[index],
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                        title: Text('Изображение ${index + 1}'),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Закрыть'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Уведомления
  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Работа с камерой'),
        actions: [
          IconButton(
            icon: const Icon(Icons.photo_library),
            onPressed: _showSavedImages,
            tooltip: 'Сохраненные',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Отображение изображения
            Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: _image == null
                  ? const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.photo_camera, size: 50, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          'Фото не выбрано',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        _image!,
                        width: 300,
                        height: 300,
                        fit: BoxFit.cover,
                      ),
                    ),
            ),

            const SizedBox(height: 24),

            // Информация о сохранении
            if (_savedImagePath != null)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green[100]!),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.green),
                    const SizedBox(width: 8),
                    const Text(
                      'Изображение сохранено',
                      style: TextStyle(color: Colors.green),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 24),

            // Фильтры
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Фильтры изображения',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        FilterChip(
                          label: const Text('Черно-белый'),
                          selected: _isGrayscale,
                          onSelected: (value) {
                            setState(() {
                              _isGrayscale = value;
                            });
                          },
                        ),
                        FilterChip(
                          label: const Text('Размытие'),
                          selected: _isBlurred,
                          onSelected: (value) {
                            setState(() {
                              _isBlurred = value;
                            });
                          },
                        ),
                        FilterChip(
                          label: const Text('Инверсия'),
                          selected: _isInverted,
                          onSelected: (value) {
                            setState(() {
                              _isInverted = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Кнопки управления
            Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _getImage(ImageSource.camera),
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Сделать фото'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _getImage(ImageSource.gallery),
                    icon: const Icon(Icons.photo_library),
                    label: const Text('Выбрать из галереи'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.blueGrey,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                if (_image != null)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _saveImage,
                      icon: const Icon(Icons.save),
                      label: const Text('Сохранить фото'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.green,
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 24),

            // Статистика
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  const Text(
                    'Статистика',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          const Text('Сохранено'),
                          Text(
                            '${_savedImages.length}',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          const Text('Фильтры'),
                          Text(
                            _isGrayscale || _isBlurred || _isInverted ? 'Вкл' : 'Выкл',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}