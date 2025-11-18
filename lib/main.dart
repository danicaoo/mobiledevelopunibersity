import 'package:flutter/material.dart';
import 'package:notes_sqlite_app/data/db_helper.dart';
import 'pages/notes_page.dart';

void main() {
  // Инициализируем тестовые данные для веб-режима
  WidgetsFlutterBinding.ensureInitialized();
  DBHelper.instance.initializeWebWithSampleData();
  
  runApp(const NotesApp());
}

class NotesApp extends StatelessWidget {
  const NotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notes SQLite',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
      ),
      home: const NotesPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}