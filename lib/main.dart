import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UI Practice Кузнецов',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Практика 3'),
          backgroundColor: Colors.blue, 
        ),
        
        body: Column(
          children: [
            const Text(
              'Приветствие',
              style: TextStyle(
                fontSize: 24,   
                fontWeight: FontWeight.bold, 
                color: Color(0xFF2E7D32), 
              ),
            ),
            
            const SizedBox(height: 20), 
            
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green, 
              ),
              child: const Text('Кнопка'),
            ),
            
            const SizedBox(height: 20), 
            
            Container(
              width: 200,
              height: 100,
              color: const Color(0xFFFF9800), 
              child: const Center(
                child: Text('Контейнер'),
              ),
            ),
            
            const SizedBox(height: 20), 
            
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.circle, color: Colors.red),
                const SizedBox(width: 20),
                const Icon(Icons.change_history, color: Colors.purple),
              ],
            ),
          ],
        ),
      ),
    );
  }
}