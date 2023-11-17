import 'package:flutter/material.dart';
import 'package:level_map/level_map.dart';

class LevelMapPage extends StatefulWidget {
  @override
  LevelMapPageState createState() => LevelMapPageState();
}

class LevelMapPageState extends State<LevelMapPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: LevelMap(
          backgroundColor: Colors.yellow,
          levelMapParams: LevelMapParams(
            levelCount: 7,
            currentLevel: 1,
            pathColor: Colors.black,
            currentLevelImage: ImageParams(
              path: "assets/images/current.png",
              size: Size(150, 150),
            ),
            lockedLevelImage: ImageParams(
              path: "assets/images/locked.png",
              size: Size(150, 150),
            ),
            completedLevelImage: ImageParams(
              path: "assets/images/check.png",
              size: Size(150, 150),
            ),
            // startLevelImage: ImageParams(
            //   path: "assets/images/start.png",
            //   size: Size(150, 150),
            // ),
            pathEndImage: ImageParams(
              path: "assets/images/finish.png",
              size: Size(150, 150),
            ),
            bgImagesToBePaintedRandomly: [
              // ImageParams(
              //     path: "assets/images/nfc.png",
              //     size: Size(80, 80),
              //     repeatCountPerLevel: 0.5),
              // ImageParams(
              //     path: "assets/images/Astronomy.png",
              //     size: Size(80, 80),
              //     repeatCountPerLevel: 0.25),
              // ImageParams(
              //     path: "assets/images/Atom.png",
              //     size: Size(80, 80),
              //     repeatCountPerLevel: 0.25),
              // ImageParams(
              //     path: "assets/images/Certificate.png",
              //     size: Size(80, 80),
              //     repeatCountPerLevel: 0.25),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black,
          child: Icon(
            Icons.bolt,
            color: Colors.white,
          ),
          onPressed: () {
            setState(() {
              //Just to visually see the change of path's curve.
            });
          },
        ),
      ),
    );
  }
}
