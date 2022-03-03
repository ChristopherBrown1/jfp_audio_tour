import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../socketProvider.dart';

class DemoScreen extends StatefulWidget {
  const DemoScreen({
    Key? key,
  }) : super(key: key);


  @override
  _DemoScreenState createState() => _DemoScreenState();
}

class _DemoScreenState extends State<DemoScreen> {
  final String title = "Demo";

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
        title: Text(title),
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.green)
                  ),
                  onPressed: () {
                    socketProvider.write('play');
                  },
                  child: Text('Play')
              ),
            ),
            Expanded(
              child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.yellow)
                  ),
                  onPressed: () {
                    socketProvider.write('pause');
                  },
                  child: Text('Pause')
              ),
            ),
            Expanded(
              child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.orange)
                  ),
                  onPressed: () {
                    socketProvider.write('stop');
                  },
                  child: Text('Stop')
              ),
            ),
            Expanded(
              child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.blue)
                  ),
                  onPressed: () {
                    socketProvider.write('reaper hello');
                  },
                  child: Text('Check 3')
              ),
            ),
            Expanded(
              child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.purple)
                  ),
                  onPressed: () {
                    socketProvider.write('mainOnCommand');
                  },
                  child: Text('Cursor Position')
              ),
            ),
            ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.red)
                ),
                onPressed: () {
                  socketProvider.write('exit');
                },
                child: Text('Exit')
            ),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _sendMessage,
      //   tooltip: 'Send message',
      //   child: const Icon(Icons.send),
      // ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

}