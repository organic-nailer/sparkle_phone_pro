import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:sparkle_phone_pro/light_controller.dart';

class RainbowPage extends StatefulWidget {
  const RainbowPage({Key? key}) : super(key: key);

  @override
  _RainbowPageState createState() => _RainbowPageState();
}

class _RainbowPageState extends State<RainbowPage>
    with SingleTickerProviderStateMixin {
  late final Ticker _ticker;

  double speed = 1.0;

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
    final lc = LightControllerScope.of(context);
    final colors = <Color>[];
    for (int i = 0; i < 66; i++) {
      final angle = (i * 360 / 66 + d.inMilliseconds * speed) % 360;
      final color = HSVColor.fromAHSV(1.0, angle, 1.0, 1.0).toColor();
      colors.add(color);
    }
    lc.sendColors(colors);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Rainbow Page"),
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text("Speed", style: TextStyle(fontSize: 24)),
              Slider(
                value: speed,
                onChanged: (value) {
                  setState(() {
                    speed = value;
                  });
                },
                min: 0,
                max: 2.0,
              ),
            ],
          ),
        ));
  }
}
