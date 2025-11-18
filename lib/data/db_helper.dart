import 'dart:async';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';
import '../utils/platform_utils.dart';
import '../models/note.dart';

class DBHelper {
  static const _dbName = 'app.db';
  static const _dbVersion = 2;
  static Database? _db;
  static const notesTable = 'notes';

  // Для веб-режима храним данные в памяти
  static final List<Note> _webNotes = [];
  static int _webNextId = 1;

  DBHelper._privateConstructor();
  static final DBHelper instance = DBHelper._privateConstructor();

  Future<Database> get database async {
    if (PlatformUtils.isWeb) {
      throw UnsupportedError('SQLite не поддерживается в веб-версии. Используйте веб-режим методы.');
    }
    
    _db ??= await _initDatabase();
    return _db!;
  }

  Future<Database> _initDatabase() async {
    final docsPath = await PlatformUtils.getApplicationDocumentsDirectory();
    final dbPath = p.join(docsPath, _dbName);
    
    return await openDatabase(
      dbPath,
      version: _dbVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $notesTable(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        body TEXT NOT NULL,
        created_at INTEGER NOT NULL,
        updated_at INTEGER NOT NULL,
        is_favorite INTEGER NOT NULL DEFAULT 0
      );
    ''');
    
    await db.execute('''
      CREATE INDEX idx_notes_created_at ON $notesTable(created_at DESC);
    ''');
    
    await db.execute('''
      CREATE INDEX idx_notes_favorite ON $notesTable(is_favorite);
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
        ALTER TABLE $notesTable ADD COLUMN is_favorite INTEGER NOT NULL DEFAULT 0;
      ''');
      
      await db.execute('''
        CREATE INDEX idx_notes_favorite ON $notesTable(is_favorite);
      ''');
    }
  }

  // ========== МЕТОДЫ ДЛЯ SQLite (мобильные/десктоп) ==========

  // CREATE
  Future<int> insertNote(Note note) async {
    if (PlatformUtils.isWeb) {
      return await _insertNoteWeb(note);
    }
    
    final db = await database;
    return await db.insert(notesTable, note.toMap());
  }

  // READ all
  Future<List<Note>> fetchNotes() async {
    if (PlatformUtils.isWeb) {
      return await _fetchNotesWeb();
    }
    
    final db = await database;
    final rows = await db.query(notesTable, orderBy: 'created_at DESC');
    return rows.map((m) => Note.fromMap(m)).toList();
  }

  // READ by id
  Future<Note?> getNoteById(int id) async {
    if (PlatformUtils.isWeb) {
      return await _getNoteByIdWeb(id);
    }
    
    final db = await database;
    final rows = await db.query(
      notesTable,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (rows.isNotEmpty) {
      return Note.fromMap(rows.first);
    }
    return null;
  }

  // SEARCH
  Future<List<Note>> searchNotes(String query) async {
    if (PlatformUtils.isWeb) {
      return await _searchNotesWeb(query);
    }
    
    final db = await database;
    final rows = await db.query(
      notesTable,
      where: 'title LIKE ? OR body LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
      orderBy: 'created_at DESC',
    );
    return rows.map((m) => Note.fromMap(m)).toList();
  }

  // UPDATE
  Future<int> updateNote(Note note) async {
    if (PlatformUtils.isWeb) {
      return await _updateNoteWeb(note);
    }
    
    final db = await database;
    return await db.update(
      notesTable,
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  // DELETE
  Future<int> deleteNote(int id) async {
    if (PlatformUtils.isWeb) {
      return await _deleteNoteWeb(id);
    }
    
    final db = await database;
    return await db.delete(
      notesTable,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // TOGGLE FAVORITE
  Future<int> toggleFavorite(int id, int isFavorite) async {
    if (PlatformUtils.isWeb) {
      return await _toggleFavoriteWeb(id, isFavorite);
    }
    
    final db = await database;
    return await db.update(
      notesTable,
      {'is_favorite': isFavorite},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Close database
  Future<void> close() async {
    if (!PlatformUtils.isWeb) {
      final db = await database;
      await db.close();
    }
  }

  // ========== МЕТОДЫ ДЛЯ ВЕБ-РЕЖИМА ==========

  Future<int> _insertNoteWeb(Note note) async {
    await Future.delayed(const Duration(milliseconds: 100)); // Имитация задержки БД
    
    final newNote = Note(
      id: _webNextId++,
      title: note.title,
      body: note.body,
      createdAt: note.createdAt,
      updatedAt: note.updatedAt,
      isFavorite: note.isFavorite,
    );
    
    _webNotes.insert(0, newNote);
    return newNote.id!;
  }

  Future<List<Note>> _fetchNotesWeb() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return List<Note>.from(_webNotes);
  }

  Future<Note?> _getNoteByIdWeb(int id) async {
    await Future.delayed(const Duration(milliseconds: 100));
    try {
      return _webNotes.firstWhere((note) => note.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<List<Note>> _searchNotesWeb(String query) async {
    await Future.delayed(const Duration(milliseconds: 150));
    if (query.isEmpty) {
      return List<Note>.from(_webNotes);
    }
    
    return _webNotes.where((note) =>
      note.title.toLowerCase().contains(query.toLowerCase()) ||
      note.body.toLowerCase().contains(query.toLowerCase())
    ).toList();
  }

  Future<int> _updateNoteWeb(Note note) async {
    await Future.delayed(const Duration(milliseconds: 100));
    
    final index = _webNotes.indexWhere((n) => n.id == note.id);
    if (index != -1) {
      _webNotes[index] = note;
      return 1;
    }
    return 0;
  }

  Future<int> _deleteNoteWeb(int id) async {
    await Future.delayed(const Duration(milliseconds: 100));
    
    final initialLength = _webNotes.length;
    _webNotes.removeWhere((note) => note.id == id);
    return initialLength - _webNotes.length;
  }

  Future<int> _toggleFavoriteWeb(int id, int isFavorite) async {
    await Future.delayed(const Duration(milliseconds: 100));
    
    final index = _webNotes.indexWhere((note) => note.id == id);
    if (index != -1) {
      final note = _webNotes[index];
      _webNotes[index] = note.copyWith(isFavorite: isFavorite);
      return 1;
    }
    return 0;
  }

  // Метод для инициализации тестовых данных в веб-режиме
  void initializeWebWithSampleData() {
    if (PlatformUtils.isWeb && _webNotes.isEmpty) {
      final now = DateTime.now();
      _webNotes.addAll([
        Note(
          id: _webNextId++,
          title: 'Добро пожаловать в Notes SQLite!',
          body: 'Это демонстрационная заметка для веб-режима.',
          createdAt: now.subtract(const Duration(hours: 2)),
          updatedAt: now.subtract(const Duration(hours: 2)),
          isFavorite: 1,
        ),
        Note(
          id: _webNextId++,
          title: 'Важные задачи',
          body: '1. Изучить Flutter\n2. Освоить SQLite\n3. Создать приложение',
          createdAt: now.subtract(const Duration(hours: 1)),
          updatedAt: now.subtract(const Duration(minutes: 30)),
          isFavorite: 0,
        ),
        Note(
          id: _webNextId++,
          title: 'Покупки',
          body: 'Молоко, хлеб, яйца, фрукты',
          createdAt: now.subtract(const Duration(minutes: 15)),
          updatedAt: now.subtract(const Duration(minutes: 15)),
          isFavorite: 0,
        ),
      ]);
    }
  }
}