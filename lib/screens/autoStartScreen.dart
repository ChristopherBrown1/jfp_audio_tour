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

  @override
  void initState() {
    super.initState();
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
        print(value.runtimeType);
        if (value.runtimeType != SocketException) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const StartScreen(),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: const Text('Can not connect to previous session ip.'),
            duration: const Duration(seconds: 3),
            action: SnackBarAction(
              label: 'Trying to find host service...',
              onPressed: () {},
            ),
          ));
          // if it cant connect start loop of findHosts()
          repeatFindHosts();
        }
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Previous session ip not discovered.'),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'Trying to find host service...',
          onPressed: () {},
        ),
      ));

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

    print("start finding hosts...");
    await context.read<SocketProvider>().findHosts().then((value) {
      print("finished finding hosts");
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
      hosts = context.read<SocketProvider>().hosts;
      if(context.read<SocketProvider>().hosts.isEmpty) {

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text('No hosts found.'),
          duration: const Duration(seconds: 3),
          action: SnackBarAction(
            label: 'Trying again...',
            onPressed: () {},
          ),
        ));

        Future.delayed(const Duration(seconds: 15), () {
          // if host isnt found run the loop again in 15 seconds.
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
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: const Text('Host found but there was a problem connecting.'),
              duration: const Duration(seconds: 3),
              action: SnackBarAction(
                label: 'Connection not established',
                onPressed: () { },
              ),
            ));
          }
          if (mounted) {
            startSession(context);
          }
        });
        return;
      }
    });
  }

}
