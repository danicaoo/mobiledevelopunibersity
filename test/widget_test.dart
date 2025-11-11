// Этот файл предоставлен Flutter и используется для тестирования виджетов.
// Ты можешь его игнорировать или временно отключить тесты.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:firebase_notes_app/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const NotesApp()); // Измени MyApp на NotesApp

    // Verify that our counter starts at 0.
    expect(find.text('Firebase Notes'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that counter has incremented.
    expect(find.text('Создать заметку'), findsOneWidget); // Ищем текст из диалога
  });
}