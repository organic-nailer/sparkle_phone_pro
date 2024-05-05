import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:sparkle_phone_pro/light_controller.dart';

class CheckPage extends StatefulWidget {
  const CheckPage({Key? key}) : super(key: key);

  @override
  _CheckPageState createState() => _CheckPageState();
}

class _CheckPageState extends State<CheckPage> {
  final List<bool> selectionList = List.generate(50, (index) => false);
  @override
  Widget build(BuildContext context) {
    final lightController = LightControllerScope.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Check Page"),
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
              Wrap(
                children: selectionList.asMap().entries.map((entry) {
                  return Checkbox(
                    value: entry.value,
                    onChanged: (bool? value) {
                      setState(() {
                        selectionList[entry.key] = value!;
                      });
                    },
                  );
                }).toList(),
              ),
              OutlinedButton(onPressed: () {
                final colors = <Color>[
                  for (int i = 0; i < selectionList.length; i++)
                    selectionList[i] ? Colors.blue : Colors.black
                ];
                lightController.sendColors(colors);
              }, child: const Text('Send')),
            ]
          )
      ),
    );
  }
}