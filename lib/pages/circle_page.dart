import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:sparkle_phone_pro/light_controller.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class CirclePage extends StatelessWidget {
  const CirclePage({super.key});

  final int ledCount = 64;

  @override
  Widget build(BuildContext context) {
    final lightController = LightControllerScope.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Circle Page"),
      ),
      body: Center(
          child: Column(
            children: <Widget>[
              Text(
                  lightController.status == LightStatus.idle
                      ? "No serial devices available"
                      : "Available Serial Ports",
                  style: Theme.of(context).textTheme.titleLarge),
              Text('Status: ${lightController.status}\n'),
              Text('info: ${lightController.portInfo}\n'),
              SleekCircularSlider(
                initialValue: 0,
                max: ledCount.toDouble(),
                min: 0,
                onChange: (double value) {
                  if (lightController.status == LightStatus.connected) {
                    List<bool> selectionList = List.generate(ledCount, (index) => false);
                    for (int i = 0; i < ledCount; i++) {
                      selectionList[i] = i < value;
                    }
                    final data = Uint8List(ledCount + 1);
                    for (int i = 0; i < ledCount; i++) {
                      data[i] = selectionList[i] ? 63 : 0;
                    }
                    data[ledCount] = 255;
                    lightController.sendRaw(data);
                  }
                },
                appearance: CircularSliderAppearance(
                  size: 400,
                  customWidths: CustomSliderWidths(
                    progressBarWidth: 40,
                    trackWidth: 20,
                    handlerSize: 50,
                    shadowWidth: 0,
                  ),
                  customColors: CustomSliderColors(
                    progressBarColor: Colors.blue,
                    trackColor: Colors.grey,
                    dotColor: Colors.blue.shade800,
                  ),
                ),
              )
            ]
          )
      ),
    );
  }
}