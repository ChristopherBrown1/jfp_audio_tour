import 'package:jfp_audio_tour/socketProvider.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:network_tools/network_tools.dart';
import 'package:provider/provider.dart';
import 'package:wakelock/wakelock.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'components/screens/startScreen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Wakelock.enable();

  runApp(
      MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => SocketProvider()),
          ],
      child: const JFAudioTour()
      )
  );
}

class JFAudioTour extends StatelessWidget {
  const JFAudioTour({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const title = 'WebSocket Demo';
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      title: title,
      home: const FirstRoute(
        title: title,
      ),
    );
  }
}

class FirstRoute extends StatefulWidget {
  const FirstRoute({Key? key, required String title}) : super(key: key);

  @override
  State<FirstRoute> createState() => _FirstRouteState();
}

class _FirstRouteState extends State<FirstRoute> {
  String title = 'WebSocket Demo';
  late SocketProvider socketProvider;
  bool isSocketConnected = false;

  @override void initState() {
    socketProvider = Provider.of<SocketProvider>(context, listen: false);
    // socketProvider.connectAndListen();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    isSocketConnected = Provider.of<SocketProvider>(context, listen: true).isSocketConnected;
    // TODO:FindHosts
    // findHosts();

    return Scaffold(
      appBar: AppBar(
        title: const Text('First Route'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: const Text('Start'),
              onPressed: () {
                startIfConnected(context); // This goes to startScreen if the connection is established to python.
                // start(context);
              },
            ),
            ElevatedButton(
              child: const Text('Connect'),
              onPressed: () {
                var snackBar = const SnackBar(content: Text(
                    'Attempting connection.'),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                socketProvider.connectAndListen();
              },
            ),
          ],
        ),
      ),
    );
  }

  void startIfConnected(context) {
    if(isSocketConnected) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => StartScreen(
            title: title,
          ),
        ),
      );
    } else {
      var snackBar = const SnackBar(content: Text(
          'Socket not connected. Please ensure that\n'
              'correct IP is used, Reaper is open,\n'
              'and Python script is running.'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      socketProvider.connectAndListen();
    }
  }

  void start(context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StartScreen(
          title: title,
        ),
      ),
    );
  }

}

