import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jfp_audio_tour/screens/scenePlayingScreen.dart';

class LanguageSelectionScreen extends StatefulWidget {
  const LanguageSelectionScreen({Key? key}) : super(key: key);

  @override
  State<LanguageSelectionScreen> createState() => _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  List languages = ["Russian", "Spanish", "English", "Chinese", "French"];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(50),
      color: Colors.white,
      child: GridView.builder(
        itemCount:languages.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: MediaQuery.of(context).orientation ==
              Orientation.landscape ? 2: 1,
          crossAxisSpacing: 10,
          mainAxisSpacing: 20,
          childAspectRatio: (5 / 1),
        ),
        itemBuilder: (context,index,) {
          return ElevatedButton(
            onPressed: () {
              // TODO: Unmute track in reaper and go to next section.

              //TODO: Go to Screen with audio mixing buttons and skip button.
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ScenePlayingScreen(
                  ),
                ),
              );
            },
            child: Text(languages[index], style: const TextStyle(fontSize: 18)),
          );
        },
      )
    );
  }
}
