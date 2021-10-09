import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'constants.dart';
import 'package:flutter_midi/flutter_midi.dart';
import 'package:tonic/tonic.dart';
import 'home.dart';
import 'note.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class FretData{
   bool visibility = engine.visibility;
   bool reveal = false;
   ShowState showState = ShowState.all;
   late NoteData noteData;

   FretData(){
     noteData = NoteData();
   }
}

class NoteData{
  Note note = Note.C;
  String text = "";
  int midi = -1;
  Color color = Colors.white;
  ResultState resultState = ResultState.none;//this will change to green or red

  NoteData({
    this.note = Note.E,
    this.text = "E",
    this.midi = -1,
    this.color = Colors.white,
    this.resultState = ResultState.none
  });
}

enum ResultState {
  correct,
  incorrect,
  none
}
enum ShowState {
  all,
  notes,
  colours,
  none
}
enum FretGroups {
  zero,
  five,
  seven,
  eleven,
}
enum GameState {
  learn,
  remember,
  aural
}
enum EngineState {
  notStarted,
  started,
  showNote,
  none,
  paused,
  unpause
}

class Engine {
  double screenWidth = 0;
  double safePaddingLeft = 0;
  double safePaddingRight = 0;

  int fretGroupIndex = 0;
  bool showFretRange = true;
  bool correct = false;

  int initialIndex = 0;
  var random = Random();

  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();

  final NoteData rootNote1 = NoteData(note:Note.E, text: NoteHelper.noteText(note:Note.E),midi:Pitch.parse('E5').midiNumber,color:NoteHelper.noteColour(note:Note.E));
  final NoteData rootNote2 = NoteData(note:Note.B, text: NoteHelper.noteText(note:Note.B),midi:Pitch.parse('B4').midiNumber,color:NoteHelper.noteColour(note:Note.B));
  final NoteData rootNote3 = NoteData(note:Note.G, text: NoteHelper.noteText(note:Note.G),midi:Pitch.parse('G4').midiNumber,color:NoteHelper.noteColour(note:Note.G));
  final NoteData rootNote4 = NoteData(note:Note.D, text: NoteHelper.noteText(note:Note.D),midi:Pitch.parse('D4').midiNumber,color:NoteHelper.noteColour(note:Note.D));
  final NoteData rootNote5 = NoteData(note:Note.A, text: NoteHelper.noteText(note:Note.A),midi:Pitch.parse('A3').midiNumber,color:NoteHelper.noteColour(note:Note.A));
  final NoteData rootNote6 = NoteData(note:Note.E, text: NoteHelper.noteText(note:Note.E),midi:Pitch.parse('E3').midiNumber,color:NoteHelper.noteColour(note:Note.E));

  static final Engine theOne = Engine._internal();
  factory Engine() => theOne;
  bool visibility = true;
  GameState currentGameState = GameState.learn;
  EngineState engineState = EngineState.notStarted;
  EngineState showNoteState = EngineState.none;
  // private, named constructor
  Engine._internal();

  NoteData currentTestNote = NoteData(note:Note.E, text: NoteHelper.noteText(note:Note.E),midi:Pitch.parse('E5').midiNumber,color:NoteHelper.noteColour(note:Note.E));

  var eString = [];
  var bString = [];
  var gString = [];
  var dString = [];
  var aString = [];
  var eStringLow = [];
  int currentNeckPosition = 0;
  int currentString = 0;
  bool canVibrate = false;
  var data = [];
  List<bool> selections = List.generate(2,(_) => false);

  List<bool> fretRanges = List.generate(5,(_) => false);

  final flutterMidi = FlutterMidi();
  int startMS =0;
  int endMS = 0;
  int answerTimeMS = -1;//default

  bool noSound()
  {
    return selections[0];
  }

  bool noHaptic()
  {
    return selections[1];
  }

  void nextTestNote()
  {
      int nFrets = numVisibleFrets.toInt();
      int rnd = random.nextInt(nFrets* 6);
      FretData? fretData;
      if(rnd <= nFrets)
      {
        fretData = engine.data[0][rnd];
        currentString = 1;
      }
      else if(rnd <= nFrets*2)
      {
        fretData = engine.data[1][rnd-nFrets];
        currentString = 2;
      }
      else if(rnd <= nFrets*3)
      {
        fretData = engine.data[2][rnd-(nFrets*2)];
        currentString = 3;
      }
      else if(rnd <= nFrets*4)
      {
        fretData = engine.data[3][rnd-(nFrets*3)];
        currentString = 4;
      }
      else if(rnd <= nFrets*5)
      {
        fretData = engine.data[4][rnd-(nFrets*4)];
        currentString = 5;
      }
      else if(rnd <= nFrets*6)
      {
        fretData = engine.data[5][rnd-(nFrets*5)];
        currentString = 6;
      }

      if(fretData!=null)
      {
          engine.currentTestNote = fretData.noteData;
          engine.showNoteState = EngineState.showNote;
      }
  }

  startGame()
  {
    engine.engineState = EngineState.started;

    showTestNote();
  }

  showTestNote()
  {
    nextTestNote();
    engine.showNoteState = EngineState.showNote;
  }

  hideTestNote()
  {
    engine.showNoteState = EngineState.none;
  }

  stopGame()
  {
    engine.engineState = EngineState.notStarted;
  }

  pauseGame()
  {
    engine.engineState = EngineState.paused;
  }

  unpauseGame()
  {
    engine.engineState = EngineState.unpause;
  }


  initData()
  async {
    data.clear();
    initString(eString, rootNote1);
    initString(bString, rootNote2);
    initString(gString, rootNote3);
    initString(dString, rootNote4);
    initString(aString, rootNote5);
    initString(eStringLow, rootNote6);

    canVibrate = await Vibrate.canVibrate;
  }

  initString(List frets, NoteData root )
  {
      FretData fretData = FretData();
      fretData.noteData = root;
      frets.add(fretData);
      Note note = root.note;
      int midi = root.midi;
      for (var i = 1; i < numFrets;i++)
      {
         note = NoteHelper.nextNote(note: note);
         midi+=1;
         String text = NoteHelper.noteText(note:note);
         Color color = NoteHelper.noteColour(note: note);
         NoteData newNote = NoteData(note:note,text:text,midi:midi,color: color);
         FretData fretData = FretData();
         fretData.noteData = newNote;
         frets.add(fretData);
      }
      data.add(frets);
  }

  void playSoundIfAllowed(int midi) {
    if(noSound()) {
      return;
    }
    flutterMidi.playMidiNote(midi: midi);
  }

  void vibrateIfAllowed() {
    if(noHaptic()) {
      return;
    }
    if (canVibrate) {
      Vibrate.vibrate();
    }
  }

  jumpToPosition(int fretIndex)
  {
     currentNeckPosition = fretIndex;
     engine.itemScrollController.jumpTo(index: currentNeckPosition, alignment: 0);
  }

  hideAllNotes()
  {
    visibility = false;
      for (var element in data) {
        for (var e in element) {
          e.visibility = visibility;
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
    visibility = true;
    for (var element in data) {
      for (var e in element) {
        e.visibility = visibility;
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

  void resetResultState(NoteData noteData)
  {
      noteData.resultState = ResultState.none;
  }

  void checkAnswer(NoteData noteData)
  {
    engine.endMS =  DateTime.now().millisecondsSinceEpoch;
    engine.answerTimeMS = engine.endMS - engine.startMS;
    if(noteData==currentTestNote)
    {
      engine.correct = true;
      noteData.resultState = ResultState.correct;
    }
    else
    {
      engine.correct = false;
      noteData.resultState =  ResultState.incorrect;
    }
  }
}
