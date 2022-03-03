import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../socketProvider.dart';
import '../blinkingbutton.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  final TextEditingController _controller = TextEditingController();
  late SocketProvider socketProvider;

  @override void initState() {
    socketProvider = Provider.of<SocketProvider>(context, listen: false);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: MyBlinkingButton(),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _sendMessage,
      //   tooltip: 'Send message',
      //   child: const Icon(Icons.send),
      // ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }


}