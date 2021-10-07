import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:guitar_trainer/colours.dart';
import 'package:badges/badges.dart';
import 'package:guitar_trainer/helper.dart';
import 'constants.dart';
import 'display_choice_widget.dart';
import 'engine.dart';
import 'fret_range_widget.dart';
import 'note.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'options_widget.dart';

var engine = Engine();
var scaffoldKey = GlobalKey<ScaffoldState>();
_HomePageState? homeState;

class HomePage extends StatefulWidget {
  final String title;

  const HomePage({Key? key, required this.title}) : super(key: key);

  @override
  _HomePageState createState() =>  _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //String fileName = 'Piano.sf2';
  String fileName = 'guitar_accoustic.sf2';
  String path = "assets/sounds/";

  @override
  void initState() {
    homeState = this;
    engine.flutterMidi.unmute();
    rootBundle.load(path + fileName).then((sf2) {
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
          body: Stack(
            children: [
              Row(
                children: [
                  Fret(
                    fretPos: engine.currentNeckPosition,
                    isNut: true,
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Expanded(
                          child: ScrollablePositionedList.builder(
                            itemScrollController: engine.itemScrollController,
                            itemPositionsListener: engine.itemPositionsListener,
                            physics: const NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            itemCount: 15,
                            itemBuilder: (BuildContext context, int index) {
                              return Fret(fretPos: index + 1);
                            },
                          ),
                        ),
                        SizedBox(
                            height: bottomBarHeight,
                            width: displayWidth(context),
                            child: Container(
                              color: Colors.brown,
                              child: ButtonBar(
                                alignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  const OptionsButtons(),
                                  Visibility(
                                    visible: engine.currentGameState ==
                                                GameState.learn ||
                                            engine.currentGameState ==
                                                GameState.aural
                                        ? true
                                        : false,
                                    child: TextButton(
                                      style: TextButton.styleFrom(
                                          side: const BorderSide(
                                              color: Colors.white),
                                          primary: Colors.white),
                                      onPressed: () {
                                        setState(() {
                                          if (engine.currentNeckPosition == 0) {
                                            engine.jumpToPosition(6);
                                          } else {
                                            engine.jumpToPosition(0);
                                          }
                                        });
                                      },
                                      child: const Text("Train"),
                                    ),
                                  ),
                                  Visibility(
                                    visible: engine.engineState !=
                                        EngineState.notStarted,
                                    child: TextButton(
                                      style: TextButton.styleFrom(
                                          side: const BorderSide(
                                              color: Colors.white),
                                          primary: Colors.white),
                                      onPressed: () {
                                        setState(() {
                                          engine.stopGame();
                                        });
                                      },
                                      child: const Text("Stop Game"),
                                    ),
                                  ),
                                  Visibility(
                                    visible: engine.engineState !=
                                        EngineState.notStarted,
                                    child: TextButton(
                                      style: TextButton.styleFrom(
                                          side: const BorderSide(
                                              color: Colors.white),
                                          primary: Colors.white),
                                      onPressed: () {
                                        setState(() {
                                          engine.pauseGame();
                                        });
                                      },
                                      child: const Text("Pause Game"),
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
              //Start HUD
              Visibility(
                visible: engine.engineState == EngineState.notStarted,
                child: Container(
                  color: Colors.black87,
                  child: Center(
                    child: Container(
                      height: 300,
                      width: 400,
                      color: Colors.black,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Visibility(
                              visible: engine.showFretRange,
                              child: const Padding(
                                padding: EdgeInsets.only(left: 40),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Fret Range",
                                    style: TextStyle(
                                        fontFamily: fontRegular,
                                        fontSize: fontSizeMedium,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: engine.showFretRange,
                              child: const FretRange(),
                            ),
                            Visibility(
                              visible: engine.currentGameState ==
                                          GameState.learn ||
                                      engine.currentGameState == GameState.aural
                                  ? true
                                  : false,
                              child: const Padding(
                                padding: EdgeInsets.only(left: 40),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "View Options",
                                    style: TextStyle(
                                        fontFamily: fontRegular,
                                        fontSize: fontSizeMedium,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: engine.currentGameState ==
                                          GameState.learn ||
                                      engine.currentGameState == GameState.aural
                                  ? true
                                  : false,
                              child: const DisplayChoice(),
                            ),
                            TextButton(
                              style: TextButton.styleFrom(
                                  side: const BorderSide(color: Colors.white),
                                  primary: Colors.white),
                              onPressed: () {
                                setState(() {
                                  engine.startGame();
                                });
                              },
                              child: const Text(
                                "Start",
                                style: TextStyle(
                                    fontFamily: fontRegular,
                                    fontSize: fontSizeLargeXX,
                                    color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              //Pause HUD
              Visibility(
                  visible: engine.engineState == EngineState.paused,
                  child: Container(
                      color: Colors.black87,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextButton(
                            style: TextButton.styleFrom(
                                side: const BorderSide(color: Colors.white),
                                primary: Colors.white),
                            onPressed: () {
                              setState(() {
                                engine.startGame();
                              });
                            },
                            child: const Text(
                              "Paused",
                              style: TextStyle(
                                  fontFamily: fontRegular,
                                  fontSize: fontSizeLargeXX,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ))),
              //Show Note
              Visibility(
                  visible: engine.showNoteState == EngineState.showNote && engine.engineState ==EngineState.started,
                  child: Center(
                    child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.white,
                            ),
                            color: Colors.black87,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20))),
                        width: 150,
                        height: 150,
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                const Text(
                                  "Play",
                                  style: TextStyle(
                                      fontFamily: fontRegular,
                                      fontSize: fontSizeLarge,
                                      color: Colors.white),
                                ),
                                Text(
                                  engine.currentTestNote.text,
                                  style: const TextStyle(
                                      fontFamily: fontRegular,
                                      fontSize: fontSizeLargeXXX,
                                      color: Colors.white),
                                ),
                                Text(
                                  "String " + engine.currentString.toString(),
                                  style: const TextStyle(
                                      fontFamily: fontRegular,
                                      fontSize: fontSizeLarge,
                                      color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        )),
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
                const SizedBox(
                  height: 100,
                  child: DrawerHeader(
                    decoration: BoxDecoration(
                      color: Colors.brown,
                    ),
                    child: Text("DON'T FRET",
                        style: TextStyle(
                            fontFamily: fontRegular,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: fontSizeLargeXXX),
                        textAlign: TextAlign.left),
                  ),
                ),
                ListTile(
                  title: const Text('Learn the fretboard'),
                  subtitle: const Text(
                      'Memorize note positions using our positive reinforcing learning system.'),
                  leading: const FaIcon(FontAwesomeIcons.magic),
                  onTap: () {
                    setState(() {
                      engine.currentGameState = GameState.learn;
                    });
                    scaffoldKey.currentState?.openEndDrawer();
                  },
                ),
                ListTile(
                  title: const Text('Remember Me'),
                  subtitle: const Text(
                      'Follow the sequence of the notes and see how many you can remember.'),
                  leading: const FaIcon(FontAwesomeIcons.gamepad),
                  onTap: () {
                    setState(() {
                      engine.currentGameState = GameState.remember;
                    });
                    scaffoldKey.currentState?.openEndDrawer();
                  },
                ),
                ListTile(
                  title: const Text('Aural Practice'),
                  subtitle: const Text(
                      'Listen to the notes and repeat, to improve your musical awareness.'),
                  leading:
                      const FaIcon(FontAwesomeIcons.assistiveListeningSystems),
                  onTap: () {
                    setState(() {
                      engine.currentGameState = GameState.aural;
                    });
                    scaffoldKey.currentState?.openEndDrawer();
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
  final bool isNut;

  const Fret({Key? key, required this.fretPos, this.isNut = false})
      : super(key: key);

  @override
  _FretState createState() => _FretState();
}

class _FretState extends State<Fret> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.isNut
          ? bridgeWidth
          : (displayWidth(context) - bridgeWidth) / numVisibleFrets,
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Column(
              children: [
                FretIndex(
                    fretPos: widget.isNut
                        ? engine.currentNeckPosition
                        : widget.fretPos),
                SingleFret(
                  stringPos: 0,
                  fretPos: widget.fretPos,
                  isNut: widget.isNut,
                ),
                SingleFret(
                  stringPos: 1,
                  fretPos: widget.fretPos,
                  isNut: widget.isNut,
                ),
                SingleFret(
                  stringPos: 2,
                  fretPos: widget.fretPos,
                  isNut: widget.isNut,
                ),
                SingleFret(
                  stringPos: 3,
                  fretPos: widget.fretPos,
                  isNut: widget.isNut,
                ),
                SingleFret(
                  stringPos: 4,
                  fretPos: widget.fretPos,
                  isNut: widget.isNut,
                ),
                SingleFret(
                  stringPos: 5,
                  fretPos: widget.fretPos,
                  isNut: widget.isNut,
                ),
                Visibility(
                    visible: widget.isNut, child: const MenuDrawButton()),
              ],
            ),
          ),
          const FretWire(),
        ],
      ),
    );
  }
}

class MenuDrawButton extends StatefulWidget {
  const MenuDrawButton({Key? key}) : super(key: key);

  @override
  _MenuDrawButtonState createState() => _MenuDrawButtonState();
}

class _MenuDrawButtonState extends State<MenuDrawButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: bottomBarHeight,
        width: bridgeWidth,
        child: Container(
          color: Colors.brown,
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
        ));
  }
}

class NoteBadge extends StatefulWidget {
  final FretData data;

  const NoteBadge({Key? key, required this.data}) : super(key: key);

  @override
  _NoteBadgeState createState() => _NoteBadgeState();
}

class _NoteBadgeState extends State<NoteBadge> {
  Color getColor() {
    if (widget.data.showState == ShowState.all ||
        widget.data.showState == ShowState.colours) {
      return widget.data.noteData.color;
    } else {
      return Colors.white;
    }
  }

  String getNoteText() {
    if (widget.data.showState == ShowState.all ||
        widget.data.showState == ShowState.notes) {
      return widget.data.noteData.text;
    } else {
      return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: IgnorePointer(
        child: Badge(
          badgeColor: getColor(),
          toAnimate: false,
          badgeContent: SizedBox(
              width: 24, height: 24, child: Center(child: Text(getNoteText()))),
          elevation: 4,
        ),
      ),
    );
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
  final bool isNut;

  const SingleFret(
      {Key? key,
      required this.stringPos,
      required this.fretPos,
      this.isNut = false})
      : super(key: key);

  @override
  _SingleFretState createState() => _SingleFretState();
}

class _SingleFretState extends State<SingleFret> {
  bool _canVibrate = true;

  init() async {
    bool canVibrate = await Vibrate.canVibrate;
    setState(() {
      _canVibrate = canVibrate;
    });
  }

  Color getFretColour() {
    if (getResultState() == ResultState.incorrect) {
      resetAfterDelay();
      return Colors.red.shade400;
    }
    if (getResultState() == ResultState.correct) {
      resetAfterDelay();
      return Colors.green.shade400;
    }
    if (!widget.isNut) {
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
    if (engine.currentNeckPosition == 0) {
      if (widget.stringPos == 0) {
        return Colors.grey.shade600;
      } else if (widget.stringPos == 1) {
        return Colors.grey.shade500;
      } else if (widget.stringPos == 2) {
        return Colors.grey.shade400;
      } else if (widget.stringPos == 3) {
        return Colors.grey.shade300;
      } else if (widget.stringPos == 4) {
        return Colors.grey.shade200;
      } else {
        return Colors.grey.shade100;
      }
    } else {
      if (widget.stringPos == 0) {
        return Colors.yellow.shade600;
      } else if (widget.stringPos == 1) {
        return Colors.yellow.shade500;
      } else if (widget.stringPos == 2) {
        return Colors.yellow.shade400;
      } else if (widget.stringPos == 3) {
        return Colors.yellow.shade300;
      } else if (widget.stringPos == 4) {
        return Colors.yellow.shade200;
      } else {
        return Colors.yellow.shade100;
      }
    }
  }

  getNextNoteAfterDelay() {
     Future.delayed(const Duration(milliseconds: 500), () {
        homeState?.setState(() {

    engine.nextTestNote();
       });
      });
  }

  resetAfterDelay() {
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        engine.resetResultState(getNoteData());
      });
    });
  }

  ResultState getResultState() {
    return engine.data[widget.stringPos][widget.fretPos].noteData.resultState;
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

  NoteData getNoteData() {
    return engine.data[widget.stringPos][widget.fretPos].noteData;
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Stack(
        children: [
          GestureDetector(
            onTapDown: (TapDownDetails details) {
              if (_canVibrate && !engine.noHaptic()) {
                Vibrate.vibrate();
              }
              engine.play(getNoteData().midi);

              setState(() {
                engine.checkAnswer(getNoteData());

                homeState?.setState(() {
                  engine.hideTestNote();
                  getNextNoteAfterDelay();
                });
              });




            },
            child: Container(
              color: getFretColour(),
            ),
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
  const FretWire({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: fretIndexHeight),
      child: SizedBox(
        width: fretWireWidth,
        child: Container(
          color: Colors.grey,
          child: Center(
            child: SizedBox(
              width: fretWireCentreWidth,
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
