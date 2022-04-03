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
                  }, child: Text("Play"),
                ),
                ElevatedButton(
                  onPressed: () {
                    socketProvider.write('stop');
                  }, child: Text("Stop"),
                ),
                ElevatedButton(
                  onPressed: () {
                    // TODO: PUT YOUR CODE HERE TO MAKE REAPER EXECUTE FUNCTIONS
                    // Put a ":" between the name that python expects and the parameter
                    // socketProvider.write('Your message to python goes here');
                    socketProvider.write("rewind:40084"); // rewind
                  }, child: Text("Rewind"),
                ),
                ElevatedButton(
                  onPressed: () {
                    socketProvider.write("reaper hello:'Hello from flutter'");
                  }, child: Text("Hello"),
                ),
                ElevatedButton(
                  onPressed: () {
                    // TODO: Test a function here
                  }, child: Text("Put new function here"),
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