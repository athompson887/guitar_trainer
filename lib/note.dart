import 'dart:ui';

import 'package:flutter/material.dart';


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

class NoteHelper{

  static Color noteColour({note=Note})
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
    Note res = Note.E;
    switch (note) {
      case Note.E:
        res = Note.F;
        break;
      case Note.F:
        res = Note.FSharp;
        break;
      case Note.FSharp:
        res = Note.G;
        break;
      case Note.G:
        res = Note.GSharp;
        break;
      case Note.GSharp:
        res = Note.A;
        break;
      case Note.A:
        res = Note.ASharp;
        break;
      case Note.ASharp:
        res = Note.B;
        break;
      case Note.B:
        res = Note.C;
        break;
      case Note.C:
        res = Note.CSharp;
        break;
      case Note.CSharp:
        res = Note.D;
        break;
      case Note.D:
        res = Note.DSharp;
        break;
      case Note.DSharp:
        res = Note.E;
        break;
    }
    return res;
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