import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Basic arithmetic test', () {
    expect(1 + 1, 2);
    expect(2 * 2, 4);
  });

  test('List operations test', () {
    final numbers = [1, 2, 3, 4, 5];
    expect(numbers.length, 5);
    expect(numbers.first, 1);
    expect(numbers.last, 5);
  });

  test('String operations test', () {
    const title = 'API Notes Feed';
    expect(title, 'API Notes Feed');
    expect(title.contains('Notes'), true);
    expect(title.length, greaterThan(5));
  });

  test('Map operations test', () {
    final noteData = {
      'id': 1,
      'title': 'Test Note',
      'body': 'Test Content',
      'userId': 1
    };
    
    expect(noteData['id'], 1);
    expect(noteData['title'], 'Test Note');
    expect(noteData.containsKey('body'), true);
  });
}