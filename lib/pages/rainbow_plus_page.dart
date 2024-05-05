import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:sparkle_phone_pro/light_controller.dart';
import 'package:google_fonts/google_fonts.dart';

class RainbowPlusPage extends StatefulWidget {
  const RainbowPlusPage({Key? key}) : super(key: key);

  @override
  _RainbowPlusPageState createState() => _RainbowPlusPageState();
}

class _RainbowPlusPageState extends State<RainbowPlusPage>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late final Ticker _ticker;
  bool move = false;

  double speed = 0.5;
  double phase = 0.0;
  double phaseSlow = 0.0;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_onTick);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    _ticker.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   if (state == AppLifecycleState.hidden) {
  //     final lc = LightControllerScope.of(context);
  //     Uint8List data = Uint8List(67);
  //     data[66] = 255;
  //     lc.sendRaw(data);
  //   }
  //   super.didChangeAppLifecycleState(state);
  // }

  void clearLed() {
    final lc = LightControllerScope.of(context);
    Timer(const Duration(milliseconds: 100), 
      () => lc.sendColors(List.generate(66, (index) => Colors.black)));
  }

  void _onTick(Duration d) {
    final lc = LightControllerScope.of(context);
    final colors = <Color>[];
    phase = (d.inMilliseconds * speed) % 360;
    phaseSlow = (d.inMilliseconds * speed / 10) % 360;
    for (int i = 0; i < 66; i++) {
      final angle = (i * 360 / 66 + phase) % 360;
      final color = HSVColor.fromAHSV(1.0, angle, 1.0, 1.0).toColor();
      colors.add(color);
    }
    lc.sendColors(colors);
    setState(() { });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: SweepGradient(
                  colors: [
                    HSVColor.fromAHSV(1.0, (0.0 - phase) % 360, 0.5, 1.0).toColor(),
                    HSVColor.fromAHSV(1.0, (60.0 - phase) % 360, 0.5, 1.0).toColor(),
                    HSVColor.fromAHSV(1.0, (120.0 - phase) % 360, 0.5, 1.0).toColor(),
                    HSVColor.fromAHSV(1.0, (180.0 - phase) % 360, 0.5, 1.0).toColor(),
                    HSVColor.fromAHSV(1.0, (240.0 - phase) % 360, 0.5, 1.0).toColor(),
                    HSVColor.fromAHSV(1.0, (300.0 - phase) % 360, 0.5, 1.0).toColor(),
                    HSVColor.fromAHSV(1.0, (360.0 - phase) % 360, 0.5, 1.0).toColor(),
                  ],
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                color: Colors.black.withOpacity(0.0),
              ),
            ),
          ),
          Positioned(
            top: 200,
            left: 400 - phaseSlow * 7,
            child: ShaderMask(
              shaderCallback: (bounds) {
                return LinearGradient(
                  colors: [
                    HSVColor.fromAHSV(1.0, (0.0 + phase) % 360, 1.0, 1.0).toColor(),
                    HSVColor.fromAHSV(1.0, (60.0 + phase) % 360, 1.0, 1.0).toColor(),
                    HSVColor.fromAHSV(1.0, (120.0 + phase) % 360, 1.0, 1.0).toColor(),
                    HSVColor.fromAHSV(1.0, (180.0 + phase) % 360, 1.0, 1.0).toColor(),
                    HSVColor.fromAHSV(1.0, (240.0 + phase) % 360, 1.0, 1.0).toColor(),
                    HSVColor.fromAHSV(1.0, (300.0 + phase) % 360, 1.0, 1.0).toColor(),
                    HSVColor.fromAHSV(1.0, (360.0 + phase) % 360, 1.0, 1.0).toColor(),
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height));
              },
              child: Text(
                "ゲーミングスマホ",
                style: GoogleFonts.cherryBombOne(
                  textStyle: const TextStyle(
                  fontSize: 400,
                  color: Colors.white,
                ),
                )
              ),
            ),
          ),
          const Positioned(
            bottom: 10,
            left: 10,
            child: Row(
              children: [
                Image(
                  image: AssetImage('asset/partyparrot.gif'),
                  width: 100,
                ),
                Image(
                  image: AssetImage('asset/partyparrot.gif'),
                  width: 100,
                ),
                Image(
                  image: AssetImage('asset/partyparrot.gif'),
                  width: 100,
                ),
                Image(
                  image: AssetImage('asset/partyparrot.gif'),
                  width: 100,
                ),
              ],
            ),
          ),
          Positioned(
            top: 30,
            left: 10,
            child: Row(
              children: [
                const Image(
                  image: AssetImage('asset/partyparrot.gif'),
                  width: 100,
                ),
                const Image(
                  image: AssetImage('asset/partyparrot.gif'),
                  width: 100,
                ),
                const Image(
                  image: AssetImage('asset/partyparrot.gif'),
                  width: 100,
                ),
                GestureDetector(
                  onTap: () {
                    if (move) {
                      _ticker.stop();
                      clearLed();
                    } else {
                      _ticker.start();
                    }
                    move = !move;
                  },
                  child: const Image(
                    image: AssetImage('asset/partyparrot.gif'),
                    width: 100,
                  ),
                ),
              ],
            ),
          ),
        ],
      )
    );
  }
}
