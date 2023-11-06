import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';

class AlertScreen extends StatefulWidget {
  final String data;
  const AlertScreen({Key? key, required this.data}) : super(key: key);

  @override
  State<AlertScreen> createState() => _AlertScreenState();
}

class _AlertScreenState extends State<AlertScreen> {
  final assetsAudioPlayer = AssetsAudioPlayer.newPlayer();
  static const route = '/alert-screen';
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

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(57, 108, 126, 241),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Text(
                message,
                style: TextStyle(color: Colors.red, fontSize: 20),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
              FloatingActionButton(
                  onPressed: () {
                    assetsAudioPlayer.dispose();
                  },
                  child: Icon(Icons.volume_mute))
            ],
          ),
        ),
      ),
    );
  }
}
