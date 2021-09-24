import 'constants.dart';

class FretData{
   bool visibility = false;
   bool reveal = false;
   ShowState showState = ShowState.All;
}

enum ShowState {
  All,
  Notes,
  Colours,
  None
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

  reveal()
  {
    for (var element in data) {
      for (var e in element) {
        e.reveal = true;
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

  setShowState(ShowState state)
  {
    for (var element in data) {
      for (var e in element) {
        e.showState = state;
      }
    }
  }
}
