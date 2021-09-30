import 'dart:ui';
import 'package:flutter/material.dart';
import 'constants.dart';
import 'package:flutter_midi/flutter_midi.dart';
import 'package:tonic/tonic.dart';
import 'note.dart';

class FretData{
   bool visibility = false;
   bool reveal = false;
   ShowState showState = ShowState.All;
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

  NoteData({
    this.note = Note.E,
    this.text = "E",
    this.midi = -1,
    this.color = Colors.white,
  });
}

enum ShowState {
  All,
  Notes,
  Colours,
  None
}

class Engine {
  final NoteData rootNote1 = NoteData(note:Note.E, text: NoteHelper.noteText(note:Note.E),midi:Pitch.parse('E5').midiNumber,color:NoteHelper.noteColour(note:Note.E));
  final NoteData rootNote2 = NoteData(note:Note.B, text: NoteHelper.noteText(note:Note.B),midi:Pitch.parse('B4').midiNumber,color:NoteHelper.noteColour(note:Note.B));
  final NoteData rootNote3 = NoteData(note:Note.G, text: NoteHelper.noteText(note:Note.G),midi:Pitch.parse('G4').midiNumber,color:NoteHelper.noteColour(note:Note.G));
  final NoteData rootNote4 = NoteData(note:Note.D, text: NoteHelper.noteText(note:Note.D),midi:Pitch.parse('D4').midiNumber,color:NoteHelper.noteColour(note:Note.D));
  final NoteData rootNote5 = NoteData(note:Note.A, text: NoteHelper.noteText(note:Note.A),midi:Pitch.parse('A3').midiNumber,color:NoteHelper.noteColour(note:Note.A));
  final NoteData rootNote6 = NoteData(note:Note.E, text: NoteHelper.noteText(note:Note.E),midi:Pitch.parse('E3').midiNumber,color:NoteHelper.noteColour(note:Note.E));

  static final Engine theOne = Engine._internal();
  factory Engine() => theOne;
  bool visibility = false;
  // private, named constructor
  Engine._internal();

  var eString = [];
  var bString = [];
  var gString = [];
  var dString = [];
  var aString = [];
  var eStringLow = [];

  var data = [];
  List<bool> selections = List.generate(2,(_) => false);

  final flutterMidi = FlutterMidi();

  bool noSound()
  {
    return selections[0];
  }

  bool noHaptic()
  {
    return selections[1];
  }



  initData()
  {
    data.clear();
    initString(eString, rootNote1);
    initString(bString, rootNote2);
    initString(gString, rootNote3);
    initString(dString, rootNote4);
    initString(aString, rootNote5);
    initString(eStringLow, rootNote6);
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

  void play(int midi) {
    if(noSound()) {
      return;
    }
    flutterMidi.playMidiNote(midi: midi);
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
}
