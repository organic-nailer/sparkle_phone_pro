import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:sparkle_phone_pro/light_controller.dart';

class ClockPage extends StatefulWidget {
  const ClockPage({Key? key}) : super(key: key);

  @override
  _ClockPageState createState() => _ClockPageState();
}

class _ClockPageState extends State<ClockPage> with SingleTickerProviderStateMixin {
  late final Ticker _ticker;
  DateTime _now = DateTime.now();

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_onTick)..start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  void _onTick(Duration d) {
    final newDate = DateTime.now();
    if (_now.second != newDate.second) {
      setState(() {
        _now = newDate;
      });
      final lc = LightControllerScope.of(context);
      final canvasSize = MediaQuery.of(context).size;
      final center = Offset(canvasSize.width / 2, canvasSize.height / 2);
      final colors = List.generate(66, (index) => Colors.black);
      final hourIndex = angleToLedIndex(canvasSize, center, (_now.hour % 12 + _now.minute / 60) * 30.0 - 90.0);
      colors[hourIndex] = colors[hourIndex].withRed(255);
      colors[(hourIndex + 1) % 66] = colors[(hourIndex + 1) % 66].withRed(255);
      colors[(hourIndex - 1) % 66] = colors[(hourIndex - 1) % 66].withRed(255);
      final minIndex = angleToLedIndex(canvasSize, center, _now.minute * 6.0 - 90.0);
      colors[minIndex] = colors[minIndex].withGreen(255);
      colors[(minIndex + 1) % 66] = colors[(minIndex + 1) % 66].withGreen(255);
      final secIndex = angleToLedIndex(canvasSize, center, _now.second * 6.0 - 90.0);
      colors[secIndex] = colors[secIndex].withBlue(255);
      lc.sendColors(colors);
      print("hour: $hourIndex, min: $minIndex, sec: $secIndex");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Clock Page"),
      ),
      body: Center(
        child: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: _now.hour.toString().padLeft(2, "0"), 
                style: const TextStyle(fontSize: 96.0, color: Colors.red),
              ),
              const TextSpan(text: ":", style: TextStyle(fontSize: 96.0, color: Colors.black)),
              TextSpan(
                text: _now.minute.toString().padLeft(2, "0"), 
                style: const TextStyle(fontSize: 96.0, color: Colors.green),
              ),
              const TextSpan(text: ":", style: TextStyle(fontSize: 96.0, color: Colors.black)),
              TextSpan(
                text: _now.second.toString().padLeft(2, "0"), 
                style: const TextStyle(fontSize: 96.0, color: Colors.blue),
              ),
            ]
          )
        )
      ),
    );
  }
}

int angleToLedIndex(Size canvasSize, Offset center, double angleDeg) {
  final leftTop = (const Offset(0,0)-center).direction % (2*pi);
  final rightTop = (Offset(canvasSize.width, 0)-center).direction % (2*pi);
  final rightBottom = (Offset(canvasSize.width, canvasSize.height)-center).direction % (2*pi);
  final leftBottom = (Offset(0, canvasSize.height)-center).direction % (2*pi);
  final angle = (angleDeg % 360) * pi / 180; // 0 <= angle < 360
  if (angle < rightBottom || angle >= rightTop) {
    // 右の場合
    final h = canvasSize.width - center.dx;
    final position = tan(angle) * h + center.dy;
    return (position / canvasSize.height * 21).floor() + 33;
  }
  else if (angle < leftBottom) {
    // 下の場合
    final h = canvasSize.height - center.dy;
    final position = - tan(angle - pi/2) * h + center.dx;
    return 12 - (position / canvasSize.width * 12).ceil() + 54;
  }
  else if (angle < leftTop) {
    // 左の場合
    final h = center.dx;
    final position = - tan(angle - pi) * h + center.dy;
    return 21 - (position / canvasSize.height * 21).ceil();
  }
  else {
    // 上の場合
    final h = center.dy;
    final position = tan(angle - pi/2*3) * h + center.dx;
    return (position / canvasSize.width * 12).floor() + 21;
  }
}
