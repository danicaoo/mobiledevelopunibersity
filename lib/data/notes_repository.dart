import 'package:dio/dio.dart';
import '../models/note.dart';
import 'api_client.dart';

class NotesRepository {
  final ApiClient _client;
  bool _useMockData = false;

  NotesRepository(this._client);

  Future<List<Note>> list({int page = 1, int limit = 10}) async {
    if (_useMockData) {
      return _getMockNotes(page: page, limit: limit);
    }

    try {
      final response = await _client.dio.get(
        '/posts',
        queryParameters: {
          '_page': page,
          '_limit': limit,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data as List<dynamic>;
        return data.map((e) => Note.fromJson(e as Map<String, dynamic>)).toList();
      } else {
        throw Exception('Ошибка загрузки: ${response.statusCode}');
      }
    } on DioException {
      // При первой ошибке переключаемся на мок-данные
      if (!_useMockData) {
        _useMockData = true;
        return _getMockNotes(page: page, limit: limit);
      }
      rethrow;
    }
  }

  Future<Note> get(int id) async {
    if (_useMockData) {
      return _getMockNote(id);
    }

    try {
      final response = await _client.dio.get('/posts/$id');
      
      if (response.statusCode == 200) {
        return Note.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw Exception('Ошибка загрузки записи: ${response.statusCode}');
      }
    } on DioException {
      if (!_useMockData) {
        _useMockData = true;
        return _getMockNote(id);
      }
      rethrow;
    }
  }

  // Мок-данные для демонстрации
  List<Note> _getMockNotes({int page = 1, int limit = 10}) {
    final startIndex = (page - 1) * limit;
    final mockNotes = <Note>[];
    
    for (int i = 0; i < limit; i++) {
      final id = startIndex + i + 1;
      mockNotes.add(Note(
        id: id,
        title: 'Мок-запись $id',
        body: 'Это демонстрационная запись №$id с мок-данными, так как API недоступно.',
        userId: 1,
      ));
    }
    
    return mockNotes;
  }

  Note _getMockNote(int id) {
    return Note(
      id: id,
      title: 'Мок-запись $id',
      body: 'Это демонстрационная запись №$id. API временно недоступно, поэтому показаны локальные данные.',
      userId: 1,
    );
  }

  Future<Note> create(String title, String body) async {
    // Для создания всегда используем мок, так как jsonplaceholder не сохраняет данные
    await Future.delayed(const Duration(seconds: 1)); // Имитация задержки сети
    
    final newNote = Note(
      id: DateTime.now().millisecondsSinceEpoch,
      title: title,
      body: body,
      userId: 1,
    );
    
    return newNote;
  }

  Future<Note> update(int id, String title, String body) async {
    await Future.delayed(const Duration(seconds: 1));
    
    return Note(
      id: id,
      title: title,
      body: body,
      userId: 1,
    );
  }

  Future<void> delete(int id) async {
    await Future.delayed(const Duration(milliseconds: 500));
  }
}