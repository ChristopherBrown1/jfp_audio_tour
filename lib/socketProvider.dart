import 'package:flutter/material.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'dart:io';

import 'package:network_tools/network_tools.dart';

class SocketProvider extends ChangeNotifier {
  String ip = '192.168.0.80'; // TODO: Change this to your ip
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





  Future<void> findHosts() async {

    // TODO: Make an option to automatically select first open device found or select a device from the list.
    // TODO: I can save the last used device as a user preference and try to pull it up when connecting.
    // TODO: If it device isn't available then show the list.

    final String? networkIP = await NetworkInfo().getWifiIP();
    final String? subnet = networkIP?.substring(0, networkIP.lastIndexOf('.'));
    // final String? subnet = networkIP?.substring(0, 9); // Must be on Cru Business network 10.12.___.___
    //TODO: if subnet is null - tell the user to connect to wifi and try again.
    final stream = HostScanner.discover(subnet!, firstSubnet: 1, lastSubnet: 254,
        progressCallback: (progress) {
          print('Progress for host discovery : $progress');
        });

    stream.listen((host) async {
      //Same host can be emitted multiple times
      //Use Set<ActiveHost> instead of List<ActiveHost>
      print('Found device: ${host}');
      bool isOpen = await isPortOpen(host.ip);
      if(isOpen) {
        print("Host is open on ip ${host.ip}");
      }

    }, onDone: () {
      print('Scan completed');
    });
  }




  Future<bool> isPortOpen(String ip) async {
    //1. Range
    PortScanner.discover(ip, startPort: 1, endPort: 1024,
        progressCallback: (progress) {
          print('Progress for port discovery : $progress');
        }).listen((event) {
      if (event.isOpen) {
        print('Found open port : $event');
      }
    }, onDone: () {
      print('Scan completed');
    });
    //2. Single
    Future<OpenPort> isOpenFuture = PortScanner.isOpen(ip,4545);
    return await isOpenFuture.then((value) => value.isOpen);
  }


}
