
import 'package:flutter_test/flutter_test.dart';

import 'package:camera_app/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const CameraApp());

    expect(find.text('Работа с камерой'), findsOneWidget);
    expect(find.text('Сделать фото'), findsOneWidget);
    expect(find.text('Выбрать из галереи'), findsOneWidget);
  });
}