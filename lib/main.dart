import 'package:flutter/material.dart';

const String studentName = 'Jaysen Natanael Kartiko';
const String studentId = '2415051028';

void main() {
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Widget buildStatCard(String value, String label, IconData icon) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Icon(icon),
              const SizedBox(height: 6),
              Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(label),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text('Flutter UI Fundamentals')),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 42,
                backgroundImage: const AssetImage('assets/images/profile.jpg'),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Text('$studentId - $studentName'),
                        const SizedBox(height: 8),
                        const Text('Flutter UI Fundamentals'),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 8),
              const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.phone_android),
                  SizedBox(width: 8),
                  Text('Mobile programming Student'),
                ],
              ),
              Row(
                children: [
                  buildStatCard('8', 'Widget', Icons.widgets),
                  buildStatCard('4', 'Layout', Icons.view_quilt),
                  buildStatCard('1', 'State', Icons.sync),
                ],
              ),
            GreetingCard(),
            ],
          ),
        ),
      ),
    );
  }
}
class GreetingCard extends StatefulWidget {
  const GreetingCard({super.key});

  @override
  State<GreetingCard> createState() => _GreetingCardState();
}

class _GreetingCardState extends State<GreetingCard> {
  final TextEditingController controller = TextEditingController();
  String message = 'Belum ada pesan';

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('$studentId - $studentName'),
        TextField(controller: controller,),
        ElevatedButton(
          onPressed: () {
            setState(() {
              message = controller.text.trim().isEmpty
                  ? 'Input masih kosong'
                  : controller.text.trim();
            });
          },
          child: const Text('Tampilkan'),
        ),
        Text(message),
      ],
    );
  }
}
