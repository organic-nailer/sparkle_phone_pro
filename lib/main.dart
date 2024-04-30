import 'package:flutter/material.dart';
import 'package:flutter_arduino_serial/light_controller.dart';
import 'package:flutter_arduino_serial/pages/ball_reflection_page.dart';
import 'package:flutter_arduino_serial/pages/check_page.dart';
import 'package:flutter_arduino_serial/pages/circle_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return LightControllerScope(
      controller: LightController(),
      child: MaterialApp(
        title: 'UsbSerial通信サンプル',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const HomePage(),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CheckPage()),
                );
              },
              child: const Text('Check Page'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CirclePage()),
                );
              },
              child: const Text('Circle Page'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const BallReflectionPage()),
                );
              }, 
              child: const Text('Ball Reflection Page'),
            )
          ],
        ),
      ),
    );
  }
}
