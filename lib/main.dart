import 'package:flutter/material.dart';

const String studentName = 'Jaysen Natanael Kartiko';
const String studentId = '2415051028';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter UI Fundamentals'),
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(radius: 42,
              backgroundImage: const AssetImage('assets/images/profile.jpg'),
              // backgroundColor: .fromARGB(0, 109, 255, 255),

              ),
              const SizedBox(height: 12,),
              Text(studentName, style: const TextStyle(fontSize: 22, 
              fontWeight: FontWeight.bold),),
              Text(studentId),
              const SizedBox(height: 8,),
              const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.phone_android),
                  SizedBox(width: 8,),
                  Text('Mobile programming Student')
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [
                  Column(children: [Text('8'), Text('Widget')]),
                  Column(children: [Text('4'), Text('Layout')]),
                  Column(children: [Text('1'), Text('State')]),
               ],
              ),
            ],
          )
        ),
      ),
    );
  }
}
