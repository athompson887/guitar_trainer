import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'constants.dart';
import 'display_choice_widget.dart';
import 'engine.dart';
import 'fret_range_widget.dart';
import 'home.dart';

class PauseHUD extends StatefulWidget {
  const PauseHUD({Key? key}) : super(key: key);

  @override
  _PauseHUDState createState() => _PauseHUDState();
}

class _PauseHUDState extends State<PauseHUD> {
  @override
  Widget build(BuildContext context) {
    return  Visibility(
      visible: engine.engineState == EngineState.paused,
      child: Container(
        color: Colors.black87,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(
              style: TextButton.styleFrom(
                  side: const BorderSide(color: Colors.white),
                  primary: Colors.white),
              onPressed: () {
                setState(() {
                  engine.startGame();
                });
              },
              child: const Text("Paused", style:  TextStyle(fontFamily: fontRegular,
                  fontSize: fontSizeLargeXX,
                  color: Colors.white),),
            ),
          ),
    )));
  }
}
