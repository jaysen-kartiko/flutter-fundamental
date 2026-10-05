import 'package:flutter/material.dart';

const String studentName = 'Jaysen Natanael Kartiko';
const String studentId = '2415051028';

class ScrollableCard extends StatelessWidget {
  const ScrollableCard({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. KARTU SEDERHANA
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Text(
                    'Informasi Mahasiswa',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text('Nama: $studentName'),
                  Text('NIM: $studentId'),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 20),

          // 2. FORM SEDERHANA
          const Text(
            'Formulir',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),

          // Kotak Teks 1
          const TextField(
            decoration: InputDecoration(
              labelText: 'Masukkan Nama Panggilan',
              border: OutlineInputBorder(),
            ),
          ),
          
          const SizedBox(height: 12),
          
          const TextField(
            decoration: InputDecoration(
              labelText: 'Masukkan Nama Panggilan',
              border: OutlineInputBorder(),
            ),
          ),
          
          const SizedBox(height: 12),

          // Kotak Teks 2
          const TextField(
            decoration: InputDecoration(
              labelText: 'Masukkan Cita-cita',
              border: OutlineInputBorder(),
            ),
          ),
          
          const SizedBox(height: 16),

          // Tombol Kirim
          ElevatedButton(
            onPressed: () {},
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }
}