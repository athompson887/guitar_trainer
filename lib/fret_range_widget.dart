import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:flutter/foundation.dart';

import 'home.dart';

class FretRange extends StatefulWidget {
  const FretRange({Key? key}) : super(key: key);

  @override
  _FretRangeState createState() => _FretRangeState();
}

class _FretRangeState extends State<FretRange> {
  @override
  Widget build(BuildContext context) {
    return  ToggleSwitch(
      initialLabelIndex: engine.fretGroupIndex,
      totalSwitches: 4,
      inactiveBgColor: Colors.white,
      activeBgColors: const [
        [Colors.green],
        [Colors.green],
        [Colors.green],
        [Colors.green]
      ],
      labels: const [
        '0',
        '5',
        '7',
        '11'
      ],
      onToggle: (index) {
        setState(() {
          engine.fretGroupIndex = index;
        });
      },
    );
  }
}
