import 'package:wakelock/wakelock.dart';
import 'package:flutter/material.dart';
import 'dart:io';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Wakelock.enable();

  runApp(const JFAudioTour());
}

class JFAudioTour extends StatelessWidget {
  const JFAudioTour({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const title = 'WebSocket Demo';
    return const MaterialApp(
      title: title,
      home: MyHomePage(
        title: title,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _controller = TextEditingController();

  String ip = '192.168.0.111';
  String port = '4545';
  late Socket socket;

    @override
  void dispose() {
      socket.write('exit');
      socket.flush();
      socket.close();
      getDataFromServer(ip, port);
      _controller.dispose();
    super.dispose();
  }

  @override void initState() {
    // TODO: implement initState
    super.initState();
    getDataFromServer(ip, port);
  }

  void getDataFromServer(String ip, String port) async{
    await Socket.connect(ip, int.parse(port)).then((sock) async {
      socket = sock;
      print('Connected to: '
          '${sock.remoteAddress.address}:${sock.remotePort}');
      sock.listen((event) {
        String result = String.fromCharCodes(event);
        print(result);
        setState(() {
          // List data = [ ];
          // data = event;
          // if (data.isEmpty) data.add(0);
        });
      });
      sock.write("open");
    }).onError((error, stackTrace){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Error! $error"),
      ));
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
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
                    socket.write('play');
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
                    socket.write('pause');
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
                    socket.write('stop');
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
                    socket.write('reaper hello');
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
                    socket.write('mainOnCommand');
                  },
                  child: Text('Cursor Position')
              ),
            ),
            ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.red)
                ),
                onPressed: () {
                  socket.write('exit');
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

