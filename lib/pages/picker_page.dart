import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:sparkle_phone_pro/light_controller.dart';
import 'package:google_fonts/google_fonts.dart';
import "package:flutter_hsvcolor_picker/flutter_hsvcolor_picker.dart";

class PickerPage extends StatefulWidget {
  const PickerPage({Key? key}) : super(key: key);

  @override
  _PickerPageState createState() => _PickerPageState();
}

class _PickerPageState extends State<PickerPage> {
  Color color = Colors.white;
  bool ledEnabled = false;

  void clearLed() {
    final lc = LightControllerScope.of(context);
    Uint8List data = Uint8List(67);
    data[66] = 255;
    for (int i = 0; i < 66; i++) {
      data[i] = 0;
    }
    lc.sendRaw(data);
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
              child: ColorPicker(
                color: color,
                onChanged: (v) {
                  setState(() {
                    color = v;
                    if (ledEnabled) {
                      final lc = LightControllerScope.of(context);
                      lc.sendColors(List.generate(66, (index) => color));
                    }
                  });
                },
              ),
            ),
            Switch(
              value: ledEnabled, 
              onChanged: (v) {
                setState(() {
                  ledEnabled = v;
                  if (!v) {
                    clearLed();
                  }
                  else {
                    final lc = LightControllerScope.of(context);
                    lc.sendColors(List.generate(66, (index) => color));
                  }
                });
              }
            )
          ],
        ),
      )
    );
  }
}
