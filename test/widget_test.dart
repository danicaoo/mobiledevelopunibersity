import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notes_sqlite_app/main.dart'; // Исправьте на ваше имя пакета

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const NotesApp()); // Исправьте на имя вашего главного виджета

    // Verify that our counter starts at 0.
    expect(find.text('Notes SQLite'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that the add dialog appears.
    expect(find.text('Новая заметка'), findsOneWidget);
  });
}