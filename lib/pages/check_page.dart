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
                Uint8List data = Uint8List(selectionList.length + 1);
                for (int i = 0; i < selectionList.length; i++) {
                  data[i] = selectionList[i] ? 63 : 0;
                }
                data[selectionList.length] = 255; // [255] is the end of the data
                lightController.sendRaw(data);
                // lightController.sendRaw(Uint8List.fromList(selectionList.map((e) => e ? 100 : 0).toList()..add(255)));
              }, child: const Text('Send')),
            ]
          )
      ),
    );
  }
}