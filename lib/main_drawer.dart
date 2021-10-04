import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'constants.dart';
import 'engine.dart';
import 'home.dart';

class MainDrawer extends StatefulWidget {
  const MainDrawer({Key? key}) : super(key: key);

  @override
  _MainDrawerState createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  @override
  Widget build(BuildContext context) {
    return  Drawer(
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
    );
  }
}
