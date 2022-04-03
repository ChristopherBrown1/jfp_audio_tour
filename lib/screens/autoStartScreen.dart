import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jfp_audio_tour/models/userPreferences.dart';
import 'package:jfp_audio_tour/screens/hostDeviceSelectionScreen.dart';
import 'package:jfp_audio_tour/screens/startScreen.dart';
import 'package:network_tools/network_tools.dart';
import 'package:provider/provider.dart';

import '../socketProvider.dart';

class AutoStartScreen extends StatefulWidget {
  const AutoStartScreen({Key? key}) : super(key: key);

  @override
  State<AutoStartScreen> createState() => _AutoStartScreenState();
}

class _AutoStartScreenState extends State<AutoStartScreen> {
  Set<ActiveHost> hosts = {};
  bool isLoading = false;
  int waitTime = 15; // time to wait before trying again to find hosts

  @override
  void initState() {
    super.initState();
    context.read<SocketProvider>().closeSocket();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      // try to connect to last ip
      startSession(context);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // child: isLoading ? loadingIndicator(context) : null,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Center(child: Text("Attempting to find a host...", style: TextStyle(fontSize: 20),)),
            ElevatedButton(onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const HostDeviceSelectionScreen(),
                ),
              );
            }, child: const Text("Select Manually"))
          ],
        ),
      ),
    );
  }

  Widget loadingIndicator(context) {
    return SizedBox(
      width: 100,
      height: 100,
      child: CircularProgressIndicator(
        value: context.watch<SocketProvider>().findHostsProgress,
        backgroundColor: Colors.grey,
      ),
    );
  }



  void startSession(BuildContext context) {
    String ip = UserPreferences.getIP();
    if(ip != "") {
      context.read<SocketProvider>().connectAndListen(ip).then((value) {
        if (value.runtimeType != SocketException) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const StartScreen(),
            ),
          );
        } else {
          String msg = 'Can not connect to previous session ip.';
          showSnackBar(context, msg);
          repeatFindHosts();
        }
      });
    } else {
      String msg = 'Previous session ip not discovered.';
      showSnackBar(context, msg);
      repeatFindHosts();
    }
  }

  Future<void> repeatFindHosts() async {
    print("REPEAT FIND HOSTS");
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }
    // start finding host ip addresses on the subnet
    await context.read<SocketProvider>().findHosts().then((value) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
      hosts = context.read<SocketProvider>().hosts;
      if(context.read<SocketProvider>().hosts.isEmpty) {
        String msg = 'No hosts found.';
        showSnackBar(context, msg);
        Future.delayed(Duration(seconds: waitTime), () {
          // if host isnt found run the loop again in set amount of seconds.
          if (mounted) {
            startSession(context);
          }
        });
      } else {
        ActiveHost host = hosts.first;
        context.read<SocketProvider>().connectAndListen(host.ip).then((value) {
          if(value.runtimeType != SocketException) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const StartScreen(),
              ),
            );
          } else {
            String msg = 'Host found but there was a problem connecting.';
            showSnackBar(context, msg);
          }
          if (mounted) {
            startSession(context);
          }
        });
        return;
      }
    });
  }

  void showSnackBar(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      duration: const Duration(seconds: 3),
      action: SnackBarAction(
        label: 'Trying to find host service...',
        onPressed: () {},
      ),
    ));
  }

}
