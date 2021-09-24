import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:guitar_trainer/colours.dart';
import 'package:badges/badges.dart';
import 'constants.dart';
import 'engine.dart';
import 'note.dart';
import 'package:toggle_switch/toggle_switch.dart';

//singleton
var engine = Engine();

class HomePage extends StatefulWidget {
  final String title;
  final Note rootNote1 = Note.E;
  final Note rootNote2 = Note.B;
  final Note rootNote3 = Note.G;
  final Note rootNote4 = Note.D;
  final Note rootNote5 = Note.A;
  final Note rootNote6 = Note.E;

  const HomePage({Key? key, required this.title}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  int initialIndex = 0;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.white70,
        body: Column(
          children: [
            Expanded(
              flex: 6,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  Bridge(
                      rootNote1: widget.rootNote1,
                      rootNote2: widget.rootNote2,
                      rootNote3: widget.rootNote3,
                      rootNote4: widget.rootNote4,
                      rootNote5: widget.rootNote5,
                      rootNote6: widget.rootNote6),
                  Fret(fretPos: 1),
                  const FretWire(),
                  Fret(fretPos: 2),
                  const FretWire(),
                  Fret(fretPos: 3),
                  const FretWire(),
                  Fret(fretPos: 4),
                  const FretWire(),
                  Fret(fretPos: 5),
                  const FretWire(),
                  Fret(fretPos: 6),
                  const FretWire(),
                  Fret(fretPos: 7),
                  const FretWire(),
                  Fret(fretPos: 8),
                  const FretWire(),
                  Fret(fretPos: 9),
                  const FretWire(),
                  Fret(fretPos: 10),
                  const FretWire(),
                  Fret(fretPos: 11),
                  const FretWire(),
                  Fret(fretPos: 12),
                  const FretWire(),
                  Fret(fretPos: 13),
                  const FretWire(),
                  Fret(fretPos: 14),
                  const FretWire(),
                  Fret(fretPos: 15),
                  const FretWire(),
                ],
              ),
            ),
            Expanded(
                flex: 1,
                child: Container(
                  color: Colors.brown,
                  child: ButtonBar(
                    alignment: MainAxisAlignment.start,
                    children: <Widget>[
                      IconButton(
                          icon: const Icon(
                            Icons.menu,
                            color: Colors.white,
                          ),
                          tooltip: 'Open Menu',
                          onPressed: () {
                            setState(() {
                              scaffoldKey.currentState?.openDrawer();
                            });
                          }),
                      // Here, default theme colors are used for activeBgColor, activeFgColor, inactiveBgColor and inactiveFgColor
                      ToggleSwitch(
                        initialLabelIndex: initialIndex,
                        totalSwitches: 4,
                        activeBgColors: const [
                          [Colors.green],
                          [Colors.blue],
                          [Colors.red],
                          [Colors.black]
                        ],
                        labels: const ['All', 'Notes', 'Colours', 'None'],
                        onToggle: (index) {
                          setState(() {
                            initialIndex = index;
                            engine.setShowState(ShowState.values[index]);
                          });
                        },
                      ),
                      Visibility(
                        visible: true,
                        child: TextButton(
                          style: TextButton.styleFrom(
                              side: const BorderSide(color: Colors.white),
                              primary: Colors.white),
                          onPressed: () {
                            setState(() {
                              engine.showAllNotes();
                            });
                          },
                          child: const Text("Show"),
                        ),
                      ),
                      Visibility(
                        visible: true,
                        child: TextButton(
                          style: TextButton.styleFrom(
                              side: const BorderSide(color: Colors.white),
                              primary: Colors.white),
                          onPressed: () {
                            setState(() {
                              engine.hideAllNotes();
                            });
                          },
                          child: const Text("Hide"),
                        ),
                      ),
                      Visibility(
                        visible: true,
                        child: TextButton(
                          style: TextButton.styleFrom(
                              side: const BorderSide(color: Colors.white),
                              primary: Colors.white),
                          onPressed: () {
                            engine.reveal();
                          },
                          child: const Text("Reveal"),
                        ),
                      ),

                      Visibility(
                        visible: true,
                        child: TextButton(
                          style: TextButton.styleFrom(
                              side: const BorderSide(color: Colors.white),
                              primary: Colors.white),
                          onPressed: () {},
                          child: const Text("Train"),
                        ),
                      ),
                    ],
                  ),
                ))
          ],
        ),
        drawer: Drawer(
          // Add a ListView to the drawer. This ensures the user can scroll
          // through the options in the drawer if there isn't enough vertical
          // space to fit everything.
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.brown,
                ),
                child: Text('Learn'),
              ),
              ListTile(
                title: const Text('By Position'),
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Down the neck'),
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Fret extends StatefulWidget {
  final int fretPos;

  // ignore: prefer_const_constructors_in_immutables
  Fret({Key? key, required this.fretPos}) : super(key: key);

  @override
  _FretState createState() => _FretState();
}

class _FretState extends State<Fret> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160.0,
      child: Column(
        children: [
          FretIndex(fretPos: widget.fretPos),
          SingleFret(stringPos: 0, fretPos: widget.fretPos, rootNote: Note.E),
          SingleFret(stringPos: 1, fretPos: widget.fretPos, rootNote: Note.B),
          SingleFret(stringPos: 2, fretPos: widget.fretPos, rootNote: Note.G),
          SingleFret(stringPos: 3, fretPos: widget.fretPos, rootNote: Note.D),
          SingleFret(stringPos: 4, fretPos: widget.fretPos, rootNote: Note.A),
          SingleFret(stringPos: 5, fretPos: widget.fretPos, rootNote: Note.E),
        ],
      ),
    );
  }
}

class NoteBadge extends StatefulWidget {
  final Color colour;
  final String text;
  final FretData data;

  const NoteBadge(
      {Key? key, required this.colour, required this.text, required this.data})
      : super(key: key);

  @override
  _NoteBadgeState createState() => _NoteBadgeState();
}

class _NoteBadgeState extends State<NoteBadge> {
  Color getColor() {
    if (widget.data.showState == ShowState.All ||
        widget.data.showState == ShowState.Colours) {
      return widget.colour;
    } else {
      return Colors.white60;
    }
  }

  String getNoteText() {
    if (widget.data.showState == ShowState.All ||
        widget.data.showState == ShowState.Notes) {
      return widget.text;
    } else {
      return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Badge(
      badgeColor: getColor(),
      badgeContent: SizedBox(
          width: 24, height: 24, child: Center(child: Text(getNoteText()))),
      elevation: 4,
    ));
  }
}

class FretIndex extends StatefulWidget {
  final int fretPos;

  const FretIndex({Key? key, required this.fretPos}) : super(key: key);

  @override
  _FretIndexState createState() => _FretIndexState();
}

class _FretIndexState extends State<FretIndex> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: fretIndexHeight,
      child: Center(child: Text(widget.fretPos.toString())),
    );
  }
}

class SingleFret extends StatefulWidget {
  final int fretPos;
  final int stringPos;
  final Note rootNote;

  const SingleFret(
      {Key? key,
      required this.stringPos,
      required this.fretPos,
      required this.rootNote})
      : super(key: key);

  @override
  _SingleFretState createState() => _SingleFretState();
}

class _SingleFretState extends State<SingleFret> {
  Color getFretColour() {
    if (widget.stringPos == 0) {
      return Colors.brown.shade800;
    } else if (widget.stringPos == 1) {
      return Colors.brown.shade700;
    } else if (widget.stringPos == 2) {
      return Colors.brown.shade600;
    } else if (widget.stringPos == 3) {
      return Colors.brown.shade500;
    } else if (widget.stringPos == 4) {
      return Colors.brown.shade400;
    } else {
      return Colors.brown.shade300;
    }
  }

  Note getNote() {
    Note currentNote = widget.rootNote;
    for (int i = 0; i < widget.fretPos; i++) {
      currentNote = currentNote.nextNote();
    }
    return currentNote;
  }

  bool getVisibility() {
    var vis = engine.data[widget.stringPos][widget.fretPos].visibility;
    return vis;
  }

  Color getColour() {
    return NoteHelper.getColour(note: getNote());
  }

  String getNoteText() {
    return NoteHelper.noteText(note: getNote());
  }

  FretData getNoteData() {
    return engine.data[widget.stringPos][widget.fretPos];
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Stack(
        children: [
          Container(
            color: getFretColour(),
          ),
          Visibility(
              visible: getVisibility(),
              replacement: const SizedBox(width: 24, height: 24),
              child: NoteBadge(
                  colour: getColour(),
                  text: getNoteText(),
                  data: getNoteData()))
        ],
      ),
    );
  }
}

class FretWire extends StatelessWidget {
  const FretWire({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: fretIndexHeight),
      child: SizedBox(
        width: 10.0,
        child: Container(
          color: Colors.grey,
          child: Center(
            child: SizedBox(
              width: 4,
              child: Container(
                color: darkGrey,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Bridge extends StatefulWidget {
  final Note rootNote1;
  final Note rootNote2;
  final Note rootNote3;
  final Note rootNote4;
  final Note rootNote5;
  final Note rootNote6;

  const Bridge(
      {Key? key,
      required this.rootNote1,
      required this.rootNote2,
      required this.rootNote3,
      required this.rootNote4,
      required this.rootNote5,
      required this.rootNote6})
      : super(key: key);

  @override
  _BridgeState createState() => _BridgeState();
}

class _BridgeState extends State<Bridge> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: fretIndexHeight),
      child: SizedBox(
        width: 60.0,
        child: Stack(
          children: [
            Container(
              color: Colors.black,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: const [
                  BridgeGap(),
                  BridgeGap(),
                  BridgeGap(),
                  BridgeGap(),
                  BridgeGap(),
                  BridgeGap(),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Visibility(
                    visible: engine.data[0][0].visibility,
                    replacement: const SizedBox(width: 24, height: 24),
                    child: NoteBadge(
                        colour: NoteHelper.getColour(note: widget.rootNote1),
                        text: NoteHelper.noteText(note: widget.rootNote1),
                        data: engine.data[0][0])),
                Visibility(
                  visible: engine.data[1][0].visibility,
                  replacement: const SizedBox(width: 24, height: 24),
                  child: NoteBadge(
                      colour: NoteHelper.getColour(note: widget.rootNote2),
                      text: NoteHelper.noteText(note: widget.rootNote2),
                      data: engine.data[1][0]),
                ),
                Visibility(
                  visible: engine.data[2][0].visibility,
                  replacement: const SizedBox(width: 24, height: 24),
                  child: NoteBadge(
                      colour: NoteHelper.getColour(note: widget.rootNote3),
                      text: NoteHelper.noteText(note: widget.rootNote3),
                      data: engine.data[2][0]),
                ),
                Visibility(
                    visible: engine.data[3][0].visibility,
                    replacement: const SizedBox(width: 24, height: 24),
                    child: NoteBadge(
                        colour: NoteHelper.getColour(note: widget.rootNote4),
                        text: NoteHelper.noteText(note: widget.rootNote4),
                        data: engine.data[3][0])),
                Visibility(
                  visible: engine.data[4][0].visibility,
                  replacement: const SizedBox(width: 24, height: 24),
                  child: NoteBadge(
                      colour: NoteHelper.getColour(note: widget.rootNote5),
                      text: NoteHelper.noteText(note: widget.rootNote5),
                      data: engine.data[4][0]),
                ),
                Visibility(
                  visible: engine.data[5][0].visibility,
                  replacement: const SizedBox(width: 24, height: 24),
                  child: NoteBadge(
                      colour: NoteHelper.getColour(note: widget.rootNote6),
                      text: NoteHelper.noteText(note: widget.rootNote6),
                      data: engine.data[5][0]),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class BridgeGap extends StatelessWidget {
  const BridgeGap({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 10,
      child: Container(
        color: darkGrey,
      ),
    );
  }
}
