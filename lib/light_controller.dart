import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:usb_serial/transaction.dart';
import 'package:usb_serial/usb_serial.dart';

class LightControllerScope extends InheritedNotifier<LightController> {
  const LightControllerScope({
    Key? key,
    required LightController controller,
    required Widget child,
  }) : super(key: key, notifier: controller, child: child);

  static LightController of(BuildContext context) {
    final LightControllerScope? scope =
        context.dependOnInheritedWidgetOfExactType<LightControllerScope>();
    if (scope == null) {
      throw Exception("No LightControllerScope found in context");
    }
    return scope.notifier!;
  }
}

enum LightStatus {
  idle,
  searching,
  connected,
  disconnected,
  connectionError,
}

class LightController extends ChangeNotifier {
  StreamSubscription<String>? _subscription;
  Transaction<String>? _transaction;
  UsbPort? _port;
  UsbDevice? _device;
  LightStatus status = LightStatus.idle;
  late StreamSubscription<UsbEvent> _usbEventSubscription;

  LightController() {
    _usbEventSubscription = UsbSerial.usbEventStream!.listen((UsbEvent event) {
      if (event.event == UsbEvent.ACTION_USB_ATTACHED) {
        connect();
      } else if (event.event == UsbEvent.ACTION_USB_DETACHED) {
        disconnect();
      }
    });
    connect();
  }

  String get portInfo => _port?.toString() ?? "No Device";

  @override
  void dispose() {
    disconnect();
    _usbEventSubscription.cancel();
    super.dispose();
  }

  void connect() {
    if (status == LightStatus.idle || status == LightStatus.disconnected || status == LightStatus.connectionError) {
      status = LightStatus.searching;
      notifyListeners();
      _getPorts();
    }
  }

  void _getPorts() async {
    List<UsbDevice> devices = await UsbSerial.listDevices();

    if (devices.isEmpty) {
      status = LightStatus.disconnected;
    } else {
      status = LightStatus.searching;
    }
    notifyListeners();

    Iterator<UsbDevice>? deviceIterator = devices.iterator;
    UsbDevice? searchDevice;
    bool searchRet = false;

    while (deviceIterator.moveNext()) {
      searchDevice = deviceIterator.current;

      // ArduinoのVendorIdだよ。
      if (searchDevice.vid == 9025) {
        searchRet = true;
        break;
      }
    }
    

    if (!searchRet) {
      disconnect();
    } else {
      await _connectTo(searchDevice!);
    }

    notifyListeners();
  }

  void disconnect() {
    if (_subscription != null) {
      _subscription!.cancel();
      _subscription = null;
    }
    if (_transaction != null) {
      _transaction!.dispose();
      _transaction = null;
    }
    if (_port != null) {
      _port!.close();
      _port = null;
    }
    _device = null;
    status = LightStatus.disconnected;

    notifyListeners();
  }

  Future<bool> _connectTo(UsbDevice device) async {
    if (_device != null) {
      disconnect();
    }

    _port = await device.create();
    if (await (_port!.open()) != true) {
      status = LightStatus.connectionError;
      return false;
    }
    _device = device;

    await _port!.setDTR(true);
    await _port!.setRTS(true);
    await _port!.setPortParameters(
        56700, UsbPort.DATABITS_8, UsbPort.STOPBITS_1, UsbPort.PARITY_NONE);

    _transaction = Transaction.stringTerminated(
        _port!.inputStream as Stream<Uint8List>, Uint8List.fromList([13, 10]));

    _subscription = _transaction!.stream.listen(onReceived);

    status = LightStatus.connected;
    return true;
  }

  void onReceived(String line) {
    if (kDebugMode) {
      print("Received: $line");
    }
  }

  void sendRaw(Uint8List data) {
    if (_port != null) {
      _port!.write(data);
    } else {
      if (kDebugMode) {
        print("Port is null");
      }
    }
  }
}