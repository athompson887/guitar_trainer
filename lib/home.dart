import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:guitar_trainer/colours.dart';
import 'package:badges/badges.dart';
import 'constants.dart';
import 'engine.dart';
import 'note.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';

var engine = Engine();
var scaffoldKey = GlobalKey<ScaffoldState>();
int mainFlex = 6;
class HomePage extends StatefulWidget {
  final String title;

  const HomePage({Key? key, required this.title}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //String fileName = 'Piano.sf2';
  String fileName = 'guitar_accoustic.sf2';
  String path = "assets/sounds/";
  int initialIndex = 0;



  @override
  void initState() {

    engine.flutterMidi.unmute();
    rootBundle.load(path+fileName).then((sf2) {
      engine.flutterMidi.prepare(sf2: sf2, name: fileName);
    });
    engine.initData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          key: scaffoldKey,
          backgroundColor: Colors.white,
          body: Row(
            children: [
              Bridge(),
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      flex: mainFlex,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children:  <Widget>[
                          Fret(fretPos: 1),
                          FretWire(),
                          Fret(fretPos: 2),
                          FretWire(),
                          Fret(fretPos: 3),
                          FretWire(),
                          Fret(fretPos: 4),
                          FretWire(),
                          Fret(fretPos: 5),
                          FretWire(),
                          Fret(fretPos: 6),
                          FretWire(),
                          Fret(fretPos: 7),
                          FretWire(),
                          Fret(fretPos: 8),
                          FretWire(),
                          Fret(fretPos: 9),
                          FretWire(),
                          Fret(fretPos: 10),
                          FretWire(),
                          Fret(fretPos: 11),
                          FretWire(),
                          Fret(fretPos: 12),
                          FretWire(),
                          Fret(fretPos: 13),
                          FretWire(),
                          Fret(fretPos: 14),
                          FretWire(),
                          Fret(fretPos: 15),
                          FretWire(),
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
                              ToggleButtons(
                                children: const <Widget>[
                                  Icon(Icons.volume_mute_sharp),
                                  Icon(Icons.vibration)
                                ],
                                onPressed: (int index) {
                                  setState(() {
                                    engine.selections[index] = !engine.selections[index];
                                  });
                                },
                                isSelected: engine.selections,
                              ),
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
                                      if(engine.visibility==false) {
                                        engine.showAllNotes();
                                      }
                                      else {
                                          engine.hideAllNotes();
                                      }
                                    });
                                  },
                                  child: Text(engine.visibility ? "Hide" : "Show"),
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
              ),
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
      ),
    );
  }
}

class Fret extends StatefulWidget {
  final int fretPos;

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
          SingleFret(stringPos: 0, fretPos: widget.fretPos),
          SingleFret(stringPos: 1, fretPos: widget.fretPos),
          SingleFret(stringPos: 2, fretPos: widget.fretPos),
          SingleFret(stringPos: 3, fretPos: widget.fretPos),
          SingleFret(stringPos: 4, fretPos: widget.fretPos),
          SingleFret(stringPos: 5, fretPos: widget.fretPos),
        ],
      ),
    );
  }
}

class NoteBadge extends StatefulWidget {
  final FretData data;

  const NoteBadge(
      {Key? key, required this.data})
      : super(key: key);

  @override
  _NoteBadgeState createState() => _NoteBadgeState();
}

class _NoteBadgeState extends State<NoteBadge> with
    SingleTickerProviderStateMixin {
  late double _scale;
  late AnimationController _controller;

  bool _canVibrate = true;

  init() async {
    bool canVibrate = await Vibrate.canVibrate;
    setState(() {
      _canVibrate = canVibrate;
      _canVibrate
          ? print("This device can vibrate")
          : print("This device cannot vibrate");
    });
  }

  @override
  void initState() {
    super.initState();
    init();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 250,
      ),
      lowerBound: 0.0,
      upperBound: 0.5,
    )..addListener(() {
      setState(() {

      });
    });
  }

  Color getColor() {
    if (widget.data.showState == ShowState.All ||
        widget.data.showState == ShowState.Colours) {
      return widget.data.noteData.color;
    } else {
      return Colors.white;
    }
  }


  String getNoteText() {
    if (widget.data.showState == ShowState.All ||
        widget.data.showState == ShowState.Notes) {
      return widget.data.noteData.text;
    } else {
      return "";
    }
  }


  @override
  Widget build(BuildContext context) {
    _scale = 1.0 - _controller.value;
    return Center(
        child: GestureDetector(
          onTapUp: (TapUpDetails details) {
            _controller.reverse();
          },
          onTapDown: (TapDownDetails details) {
            if(_canVibrate && !engine.noHaptic()) {
              Vibrate.vibrate();
            }
            engine.play(widget.data.noteData.midi);
            _controller.forward();
          },
          child: Transform.scale(
            scale: _scale,
            child: Badge(badgeColor: getColor(),
              toAnimate: true,
              animationType: BadgeAnimationType.scale,
              badgeContent: SizedBox(width: 24, height: 24, child: Center(child: Text(getNoteText()))), elevation: 4,),
          ),
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

  const SingleFret(
      {Key? key,
      required this.stringPos,
      required this.fretPos})
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
    return engine.data[widget.stringPos][widget.fretPos].noteData.note;
  }

  bool getVisibility() {
    return engine.data[widget.stringPos][widget.fretPos].visibility;
  }

  Color getColour() {
    return engine.data[widget.stringPos][widget.fretPos].noteData.color;
  }

  String getNoteText() {
    return engine.data[widget.stringPos][widget.fretPos].noteData.text;
  }

  FretData getFretData() {
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
              child: NoteBadge(data: getFretData()))
        ],
      ),
    );
  }
}

class FretWire extends StatelessWidget {
  FretWire({
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

  Bridge(
      {Key? key})
      : super(key: key);

  @override
  _BridgeState createState() => _BridgeState();
}

class _BridgeState extends State<Bridge> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 60,
      child: Column(
          children: [
            SizedBox(
              child: Container(color: Colors.brown),
              height: fretIndexHeight),
          Expanded(
          flex: mainFlex,
          child:Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children:  const [
                  BridgeGap(),
                  BridgeGap(),
                  BridgeGap(),
                  BridgeGap(),
                  BridgeGap(),
                  BridgeGap(),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Visibility(
                      visible: engine.data[0][0].visibility,
                      replacement: const SizedBox(width: 24, height: 24),
                      child: NoteBadge(data: engine.data[0][0])),
                  Visibility(
                    visible: engine.data[1][0].visibility,
                    replacement: const SizedBox(width: 24, height: 24),
                    child: NoteBadge(data: engine.data[1][0]),),
                  Visibility(
                    visible: engine.data[2][0].visibility,
                    replacement: const SizedBox(width: 24, height: 24),
                    child: NoteBadge(data: engine.data[2][0]),),
                  Visibility(
                      visible: engine.data[3][0].visibility,
                      replacement: const SizedBox(width: 24, height: 24),
                      child: NoteBadge(data: engine.data[3][0])),
                  Visibility(
                    visible: engine.data[4][0].visibility,
                    replacement: const SizedBox(width: 24, height: 24),
                    child: NoteBadge(data: engine.data[4][0]), ),
                  Visibility(
                    visible: engine.data[5][0].visibility,
                    replacement: const SizedBox(width: 24, height: 24),
                    child: NoteBadge(data: engine.data[5][0]),
                  ),
                ],
              ),
            ],
          ),
      ),
      Expanded(
        flex: 1,
        child: Container(color: Colors.brown,
        child: Row(
          children: [
                Center(
                  child: IconButton(
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
                ),
              ],
            ),
        ),),
      ]));
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
