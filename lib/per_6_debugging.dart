import 'package:flutter/material.dart';
import 'StudentInfo.dart';

class KasusAScreen extends StatelessWidget {
  const KasusAScreen({super.key});

  @override
  Widget build(BuildContext context) {
    

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kasus A - Row Overflow Solusi'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [            
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade400),
              ),
              child: Row(
                children: [
                  
                  Expanded(
                    child: Text(
                      '$studentId - $studentName - Teks sangat panjang yang tadinya menyebabkan error RenderFlex overflow pada sisi kanan layar jika tidak dibungkus menggunakan Expanded.',
                      style: const TextStyle(fontSize: 14),

                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class KasusBScreen extends StatelessWidget {
  const KasusBScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kasus B - ListView dalam Column')),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            color: Colors.amber.shade100,
            child: const Text(
              'Informasi Kursus',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 15,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const Icon(Icons.book),
                  title: Text('Kursus Pemrograman ke-${index + 1}'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class KasusCScreen extends StatelessWidget {
  const KasusCScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kasus C - Keyboard Overflow')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const SizedBox(height: 250),
              const Text(
                'Form Feedback di Bagian Bawah',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const TextField(
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Tulis komentar Anda di sini...',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text('Kirim Komentar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class KasusDScreen extends StatefulWidget {
  const KasusDScreen({super.key});

  @override
  State<KasusDScreen> createState() => _KasusDScreenState();
}

class _KasusDScreenState extends State<KasusDScreen> {
  bool _isNavigating = false;

  void _handleNavigation() async {
    if (_isNavigating) return;

    setState(() {
      _isNavigating = true;
    });

    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const DetailScreen()),
    );

    if (mounted) {
      setState(() {
        _isNavigating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kasus D - Mencegah Navigasi Ganda')),
      body: Center(
        child: ElevatedButton.icon(
          onPressed: _isNavigating ? null : _handleNavigation,
          icon: _isNavigating
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.grey),
                )
              : const Icon(Icons.arrow_forward),
          label: Text(_isNavigating ? 'Sedang Membuka...' : 'Buka Halaman Detail'),
        ),
      ),
    );
  }
}

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Halaman Detail')),
      body: const Center(
        child: Text(
          'Selamat datang di Halaman Detail!',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}