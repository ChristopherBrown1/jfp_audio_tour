import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'languageSelectionScreen.dart';

class IntroVideoScreen extends StatefulWidget {
  const IntroVideoScreen({Key? key}) : super(key: key);

  @override
  State<IntroVideoScreen> createState() => _IntroVideoScreenState();
}

class _IntroVideoScreenState extends State<IntroVideoScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Column(
        children: [
          Expanded(flex: 3, child: Container()),
          Row(
            children: [
              Expanded(flex: 3, child: Container()),
              Container(
                height: 100,
                width: 400,
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
                    child: const Text("Skip", style: TextStyle(fontSize: 40),),
                    style: ButtonStyle(
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                            )
                        )
                    )
                ),
              ),
              // Expanded(flex: 1, child: Container()),

            ],
          ),
          Expanded(flex: 1, child: Container()),
        ],
      ),
    );
  }
}
