import 'package:flutter/material.dart';
import 'dart:io';

class SocketProvider extends ChangeNotifier {
  String ip = '192.168.0.111';
  String port = '4545';
  late Socket socket;
  List data = [];
  bool isSocketConnected = false;


  void connectAndListen() async { // TODO: Pass in IP and port for a device the user selects from a list.
    await Socket.connect(ip, int.parse(port)).then((sock) async {
      socket = sock;
      print('Connected to: ${sock.remoteAddress.address}:${socket.remotePort}');
      isSocketConnected = true;
      socket.write("Socket connected!");
      _listen();
      notifyListeners();
    });
  }

  void _listen() {
    socket.listen((event) {
      String result = String.fromCharCodes(event);
      print('Socket message $result');
      data = event;
      if (data.isEmpty) data.add(0);
      notifyListeners();
    }, onDone: () {
      isSocketConnected = false;
      debugPrint('ws channel closed');
      notifyListeners();
    }, onError: (error, stacktrace) {
      debugPrint('ws error $error');
    });
  }

  void write(var msg) {
    if(isSocketConnected) {
      socket.write(msg);
      notifyListeners();
    }
  }

  void closeSocket() {
    socket.write('exit');
    socket.flush();
    socket.close();
    isSocketConnected = false;
    notifyListeners();
  }


}
