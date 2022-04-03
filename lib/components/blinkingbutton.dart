import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jfp_audio_tour/screens/introVideoScreen.dart';
import 'package:jfp_audio_tour/main.dart';

class MyBlinkingButton extends StatefulWidget {
  MyBlinkingButton();

  @override
  _MyBlinkingButtonState createState() => _MyBlinkingButtonState();
}

class _MyBlinkingButtonState extends State<MyBlinkingButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  _MyBlinkingButtonState();

  @override
  void initState() {
    _animationController =
    AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _animationController.repeat(reverse: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animationController,
      child: MaterialButton(
        height: MediaQuery.of(context).size.height / 2,
        minWidth: MediaQuery.of(context).size.width / 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(200), // <-- Radius
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const IntroVideoScreen(
              ),
            ),
          );
        },
        child: const Text(
          "Tap to Start",
          style: TextStyle(
            color: Colors.white,
            fontSize: 40,
            fontWeight: FontWeight.bold
          ),
        ),
        color: Colors.green,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}