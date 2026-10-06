
import 'package:flutter/material.dart';
import 'StudentInfo.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.home, size: 64, color: Colors.blue),
            const SizedBox(height: 16),
            const Text(
              'Selamat Datang di Beranda!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Mahasiswa: $studentName ($studentId)', 
              style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}