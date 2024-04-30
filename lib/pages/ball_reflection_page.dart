import 'dart:typed_data';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:sparkle_phone_pro/light_controller.dart';

enum Side {
  top,
  right,
  bottom,
  left,
}

class BallReflectionPage extends StatefulWidget {
  const BallReflectionPage({Key? key}) : super(key: key);

  @override
  _BallReflectionPageState createState() => _BallReflectionPageState();
}

class _BallReflectionPageState extends State<BallReflectionPage> with SingleTickerProviderStateMixin {
  final List<Color> selectionList = List.generate(64, (index) => Colors.black);

  Offset ballPosition = const Offset(100, 100);
  Offset ballVelocity = const Offset(10, 10);
  final double ballSize = 50;
  final double ballSpeed = 1;
  late final Ticker _ticker;

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
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    final double ballRadius = ballSize / 2;
    final double ballSpeedX = ballSpeed * ballVelocity.dx;
    final double ballSpeedY = ballSpeed * ballVelocity.dy;
    final double ballLeft = ballPosition.dx - ballRadius;
    final double ballRight = ballPosition.dx + ballRadius;
    final double ballTop = ballPosition.dy - ballRadius;
    final double ballBottom = ballPosition.dy + ballRadius;
    final double ballNextLeft = ballLeft + ballSpeedX;
    final double ballNextRight = ballRight + ballSpeedX;
    final double ballNextTop = ballTop + ballSpeedY;
    final double ballNextBottom = ballBottom + ballSpeedY;
    if (ballNextLeft < 0 || ballNextRight > width) {
      ballVelocity = Offset(-ballVelocity.dx, ballVelocity.dy);
      if (ballNextLeft < 0) {
        _collision(Side.left, ballNextTop, Size(width, height));
      } else {
        _collision(Side.right, ballNextTop, Size(width, height));
      }
    }
    if (ballNextTop < 0 || ballNextBottom > height) {
      ballVelocity = Offset(ballVelocity.dx, -ballVelocity.dy);
      if (ballNextTop < 0) {
        _collision(Side.top, ballNextLeft, Size(width, height));
      } else {
        _collision(Side.bottom, ballNextLeft, Size(width, height));
      }
    }
    ballPosition += ballVelocity;
    setState(() {});
  }

  void _collision(Side side, double position, Size screenSize) {
    final int ledPos;
    switch (side) {
      case Side.top: {
        final localLedPos = (position / screenSize.width * 11).round();
        ledPos = localLedPos + 23;
        break;
      }
      case Side.right: {
        final localLedPos = (position / screenSize.height * 21).round();
        ledPos = localLedPos + 34;
        break;
      }
      case Side.bottom: {
        final localLedPos = ((1 - position / screenSize.width) * 10).round();
        ledPos = min(localLedPos + 55, 63);
        break;
      }
      case Side.left: {
        final localLedPos = ((1 - position / screenSize.height) * 23).round();
        ledPos = localLedPos;
        break;
      }
    }
    final currentColor = selectionList[ledPos];
    selectionList[ledPos] = 
          currentColor == Colors.black ? Colors.red 
        : currentColor == Colors.red ? Colors.green
        : currentColor == Colors.green ? Colors.blue
        : Colors.black;
    print("update: $ledPos ${selectionList[ledPos]}");
    _updateLight();
  }

  void _updateLight() {
    final lightController = LightControllerScope.of(context);
    final data = Uint8List(65);
    for (int i = 0; i < 64; i++) {
      final color = selectionList[i];
      data[i] = color2int(color);
    }
    print(data);
    data[64] = 255;
    lightController.sendRaw(data);
  }

  int color2int(Color color) {
    return (color.red / 85.0).round() << 4 | (color.green / 85.0).round() << 2 | (color.blue / 85.0).round();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            left: ballPosition.dx - ballSize / 2,
            top: ballPosition.dy - ballSize / 2,
            child: Container(
              width: ballSize,
              height: ballSize,
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}