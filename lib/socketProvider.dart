import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jfp_audio_tour/models/userPreferences.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'dart:io';

import 'package:network_tools/network_tools.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class SocketProvider extends ChangeNotifier {
  String ip = "";
  String port = '4545';
  late Socket socket;
  List data = [];
  bool isSocketConnected = false;
  int advertiserPort = 3595;
  Set<ActiveHost> hosts = {};
  double findHostsProgress = 0;


  Future<dynamic> connectAndListen(String ip) async { // TODO: Pass in IP and port for a device the user selects from a list.
    if(ip == "discoverIP") {
      await findHosts();
      if(ip != "") {
        ip = this.ip;
      }
    }
    try {
      Future<Socket> socketFuture = Socket.connect(ip, int.parse(port));
      await socketFuture.then((sock) async {
        socket = sock;
        print('Connected to: ${sock.remoteAddress.address}:${socket.remotePort}');
        isSocketConnected = true;
        socket.write("Socket connected!");
        UserPreferences.setIP(ip);
        _listen();
        notifyListeners();
      });
      return socket;
    } on SocketException catch (e) {
      print(e.toString());
      return e;
    }
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




  // TODO: Make an option to automatically select first open device found or select a device from the list.
  // TODO: I can save the last used device as a user preference and try to pull it up when connecting.
  // TODO: If it device isn't available then show the list.
  Future<void> findHosts() async {
    hosts = {};
    notifyListeners();
    final String? networkIP = await NetworkInfo().getWifiIP();
    final String? subnet = networkIP?.substring(0, networkIP.lastIndexOf('.'));
    // final String? subnet = networkIP?.substring(0, 9); // Must be on Cru Business network 10.12.___.___
    //TODO: if subnet is null - tell the user to connect to wifi and try again.

    final stream = HostScanner.discover(subnet!, firstSubnet: 1, lastSubnet: 254,
        progressCallback: (progress) {
      findHostsProgress = progress;
      notifyListeners();
        });

    await stream.listen((host) async {
      // add these hosts all to a list
      print("H $host");

      await isPortOpen(host.ip, host);
    }).asFuture().then((value) {
      print('Scan completed $ip');
      return;
    });
  }


  Future<void> isPortOpen(String ip, ActiveHost host) async {
    print("is port open started for $ip");
    // wait for stream to finish

    await PortScanner.discover(ip, startPort: advertiserPort, endPort: advertiserPort,
        progressCallback: (progress) {
        }).listen((event) {
      if (event.isOpen) {
        print('Found open port : ${event.ip}:${event.port}');
        Future<OpenPort> isOpenFuture = PortScanner.isOpen(ip, advertiserPort);
        isOpenFuture.then((value) {
          if(value.isOpen) {
            print(value.ip);
            hosts.add(host);
            this.ip = value.ip;
            notifyListeners();
          }
        });
      }
    }).asFuture().then((value) {
      print('Is Port Open Scan Completed');
      return;
    });
  }

  // TODO: alternative approach to automatic - use stream to discover all host ip's and immediately try to connect to them when found.


}
