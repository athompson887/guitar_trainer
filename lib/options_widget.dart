import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'home.dart';

class OptionsButtons extends StatefulWidget {
  const OptionsButtons({Key? key}) : super(key: key);

  @override
  _OptionsButtonsState createState() => _OptionsButtonsState();
}

class _OptionsButtonsState extends State<OptionsButtons> {
  @override
  Widget build(BuildContext context) {
    return ToggleButtons(
      children: const <Widget>[
        Icon(Icons.volume_mute_sharp),
        Icon(Icons.vibration)
      ],
      onPressed: (int index) {
        setState(() {
          engine.selections[index] =
          !engine.selections[index];
        });
      },
      isSelected: engine.selections,
    );
  }
}
