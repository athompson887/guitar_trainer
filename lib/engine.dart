import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'constants.dart';
import 'home.dart';

class FretData{
   bool visibility = false;
}


class Engine {

  static final Engine theOne = Engine._internal();
  factory Engine() => theOne;
  // private, named constructor
  Engine._internal();

  var data = List.generate(numStrings, (_) => List.filled(numFrets, FretData(), growable: false));

  hideAllNotes()
  {
      for (var element in data) {
        for (var e in element) {
          e.visibility = false;
        }
      }
  }

  showAllNotes()
  {
    for (var element in data) {
      for (var e in element) {
        e.visibility = true;
      }
    }
  }

}
