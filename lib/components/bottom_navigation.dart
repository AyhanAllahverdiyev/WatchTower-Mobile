import 'package:flutter/material.dart';
import '../pages/home.dart';

class BottomAppBarWidget extends StatelessWidget {
  const BottomAppBarWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      height: 50,
          color: Color.fromARGB(57, 108, 126, 241),
          child: Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: Icon(Icons.flashlight_on),
                  color: Colors.white,
                  iconSize: 40,
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => HomePage()));
                  },
                ),
                IconButton(
                  icon: Icon(Icons.add_alert_sharp),
                  color: Colors.white,
                  iconSize: 40,
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => HomePage()));
                  },
                ),
                IconButton(
                  icon: Icon(Icons.home),
                  color: Colors.white,
                  iconSize: 40,
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => HomePage()));
                  },
                ),
                IconButton(
                  icon: Icon(Icons.location_on),
                  color: Colors.white,
                  iconSize: 40,
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => HomePage()));
                  },
                ),
                IconButton(
                  icon: Icon(Icons.person),
                  color: Colors.white,
                  iconSize: 40,
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => HomePage()));
                  },
                ),
              ],
            ),
          ),
    );
  }
}

