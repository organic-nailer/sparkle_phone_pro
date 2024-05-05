import 'package:flutter/material.dart';
import 'package:sparkle_phone_pro/light_controller.dart';
import 'package:sparkle_phone_pro/pages/ball_reflection_page.dart';
import 'package:sparkle_phone_pro/pages/check_page.dart';
import 'package:sparkle_phone_pro/pages/circle_page.dart';
import 'package:sparkle_phone_pro/pages/clock_page.dart';
import 'package:sparkle_phone_pro/pages/picker_page.dart';
import 'package:sparkle_phone_pro/pages/rainbow_page.dart';
import 'package:sparkle_phone_pro/pages/rainbow_plus_page.dart';

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
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ClockPage()),
                );
              }, 
              child: const Text('Clock Page'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RainbowPage()),
                );
              }, 
              child: const Text('Rainbow Page'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RainbowPlusPage()),
                );
              }, 
              child: const Text('Rainbow Plus Page'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PickerPage()),
                );
              }, 
              child: const Text('Picker Page'),
            ),
          ],
        ),
      ),
    );
  }
}
