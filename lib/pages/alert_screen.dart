// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';

class AlertScreen extends StatefulWidget {
  final String data;
  const AlertScreen({Key? key, required this.data}) : super(key: key);

  @override
  State<AlertScreen> createState() => AlertScreenState();
}

class AlertScreenState extends State<AlertScreen> {
  final assetsAudioPlayer = AssetsAudioPlayer.newPlayer();
  @override
  void initState() {
    super.initState();
    assetsAudioPlayer.open(Audio('assets/sounds/alert.mp3'));
  }

  @override
  void dispose() {
    // Pause and release the audio player when the screen is exited
    assetsAudioPlayer.pause();
    assetsAudioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String message = widget.data;
    bool isMute = false;
    double sliderValue = 100.0;
    double _currentSliderValue = 100.0;

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: 50,
              ),
              Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  side: BorderSide(color: Colors.red, width: 2),
                ),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width - 40,
                  height: MediaQuery.of(context).size.width - 100,
                  child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "Alert!",
                            style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Colors.red),
                          ),
                          Text(
                            "$message",
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          Image.asset(
                            "assets/gifs/alarm.gif",
                            height: MediaQuery.of(context).size.width / 2 - 30,
                            width: MediaQuery.of(context).size.width / 2 - 30,
                          ),
                        ],
                      )),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: MediaQuery.of(context).size.width - 40,
                height: 50,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Close",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold)),
                        SizedBox(width: 10),
                        Icon(Icons.close, color: Colors.white, size: 30.0),
                      ],
                    )),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: MediaQuery.of(context).size.width - 40,
                height: 50,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    onPressed: () {
                
                      assetsAudioPlayer.dispose();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Mute",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold)),
                        SizedBox(width: 10),
                        Icon(Icons.volume_off, color: Colors.white, size: 30.0),
                      ],
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
