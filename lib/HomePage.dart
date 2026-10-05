import 'package:flutter/material.dart';

import 'DetailPage.dart';

const String studentName = 'Jaysen Natanael Kartiko';
const String studentId = '2415051028';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('First Route')),
      body: Center(
        child: Column(
          children: [
            Text('$studentId - $studentName'),
            ElevatedButton(
              child: const Text('Open route'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (context) => const DetailPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
