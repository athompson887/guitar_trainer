import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:flutter/foundation.dart';

import 'engine.dart';
import 'home.dart';

class DisplayChoice extends StatefulWidget {
  const DisplayChoice({Key? key}) : super(key: key);

  @override
  _DisplayChoiceState createState() => _DisplayChoiceState();
}

class _DisplayChoiceState extends State<DisplayChoice> {
  @override
  Widget build(BuildContext context) {
    return ToggleSwitch(
      initialLabelIndex: engine.initialIndex,
      totalSwitches: 4,
      inactiveBgColor: Colors.white,
      activeBgColors: const [
        [Colors.green],
        [Colors.blue],
        [Colors.red],
        [Colors.black]
      ],
      labels: const [
        'All',
        'Notes',
        'Colours',
        'None'
      ],
      onToggle: (index) {
        setState(() {
          engine.initialIndex = index;
          engine
              .setShowState(ShowState.values[index]);
        });
      },
    );
  }
}
