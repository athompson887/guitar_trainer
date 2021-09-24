import 'dart:ui';

import 'package:flutter/material.dart';

import 'constants.dart';

enum Note {
  E,
  F,
  FSharp,
  G,
  GSharp,
  A,
  ASharp,
  B,
  C,
  CSharp,
  D,
  DSharp
}

extension NoteExtension on Note {
  Note nextNote() {
    switch (this) {
      case Note.E:
        return Note.F;
      case Note.F:
        return Note.FSharp;
      case Note.FSharp:
        return Note.G;
      case Note.G:
        return Note.GSharp;
      case Note.GSharp:
        return Note.A;
      case Note.A:
        return Note.ASharp;
      case Note.ASharp:
        return Note.B;
      case Note.B:
        return Note.C;
      case Note.C:
        return Note.CSharp;
      case Note.CSharp:
        return Note.D;
      case Note.D:
        return Note.DSharp;
      case Note.DSharp:
        return Note.E;
    }
  }
}

class NoteHelper{

  static Color getColour({note=Note})
  {
    switch(note)
    {
      case Note.E:
        return Colors.amber;
      case Note.F:
        return Colors.green;
      case Note.FSharp:
        return Colors.blue;
      case Note.G:
        return Colors.indigoAccent;
      case Note.GSharp:
        return Colors.white;
      case Note.A:
        return Colors.pink;
      case Note.ASharp:
        return Colors.cyan;
      case Note.B:
        return Colors.purple;
      case Note.C:
        return Colors.lightBlue;
      case Note.CSharp:
        return Colors.blueGrey;
      case Note.D:
        return Colors.orange;
      case Note.DSharp:
        return Colors.red;
    }
    return Colors.black;
  }

  static Note nextNote({note=Note}) {
    switch (note) {
      case Note.E:
        note = Note.F;
        break;
      case Note.F:
        note = Note.FSharp;
        break;
      case Note.FSharp:
        note = Note.G;
        break;
      case Note.G:
        note = Note.GSharp;
        break;
      case Note.GSharp:
        note = Note.A;
        break;
      case Note.A:
        note = Note.ASharp;
        break;
      case Note.ASharp:
        note = Note.B;
        break;
      case Note.B:
        note = Note.C;
        break;
      case Note.C:
        note = Note.CSharp;
        break;
      case Note.CSharp:
        note = Note.D;
        break;
      case Note.D:
        note = Note.DSharp;
        break;
      case Note.DSharp:
        note = Note.E;
        break;
    }
    return note;
  }

  static String noteText({note=Note}) {
    
    switch (note) {
      case Note.E:
        return "E";
      case Note.F:
        return "F";
      case Note.FSharp:
        return "F#";
      case Note.G:
        return "G";
      case Note.GSharp:
        return "G#";
      case Note.A:
        return "A";
      case Note.ASharp:
        return "A#";
      case Note.B:
        return "B";
      case Note.C:
        return "C";
      case Note.CSharp:
        return "C#";
      case Note.D:
        return "D";
      case Note.DSharp:
        return "D#";
    }
    return "";
  }
}