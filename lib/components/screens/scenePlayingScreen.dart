import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../socketProvider.dart';
import 'languageSelectionScreen.dart';

class ScenePlayingScreen extends StatefulWidget {
  const ScenePlayingScreen({Key? key}) : super(key: key);

  @override
  State<ScenePlayingScreen> createState() => _ScenePlayingScreenState();
}

class _ScenePlayingScreenState extends State<ScenePlayingScreen> {


  late SocketProvider socketProvider;

  @override void initState() {
    socketProvider = Provider.of<SocketProvider>(context, listen: false);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    socketProvider.write('play');
                  }, child: Text("Test Button 1"),
                ),
                ElevatedButton(
                  onPressed: () {
                    socketProvider.write('pause');
                  }, child: Text("Test Button 2"),
                ),
                ElevatedButton(
                  onPressed: () {
                    // TODO: PUT YOUR CODE HERE TO MAKE REAPER PLAY
                    // socketProvider.write('Your message to python goes here');
                    socketProvider.write('rewind');
                  }, child: Text("Test Button 3"),
                ),
                ElevatedButton(
                  onPressed: () {  }, child: Text("Test Button 4"),
                ),
                ElevatedButton(
                  onPressed: () {  }, child: Text("Test Button 5"),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Container(
                  height: 75,
                  width: 300,
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LanguageSelectionScreen(
                            ),
                          ),
                        );
                      },
                      child: const Text("Next", style: TextStyle(fontSize: 40),),
                      style: ButtonStyle(
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                              )
                          )
                      )
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}