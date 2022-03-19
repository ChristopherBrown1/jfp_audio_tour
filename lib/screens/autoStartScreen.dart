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

  @override void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      // try to connect to last ip
      findHost();
    });
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
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HostDeviceSelectionScreen(),
                ),
              );
            }, child: Text("Select Manually"))
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

  void findHost() {
    String ip = UserPreferences.getIP();
    if(ip != "") {
      context.read<SocketProvider>().connectAndListen(ip).then((value) {
        if(ip != "") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const StartScreen(),
            ),
          );
        } else {
          // if it cant connect start loop of findHosts()
          repeatFindHosts();
        }
      });
    } else {
      repeatFindHosts();
    }
  }

  void repeatFindHosts() {
    setState(() {
      isLoading = true;
    });

    context.read<SocketProvider>().findHosts().then((value) {
      setState(() {
        isLoading = false;
      });
      hosts = context.read<SocketProvider>().hosts;
      if(context.read<SocketProvider>().hosts.isEmpty) {
        // wait 10 seconds and then try again
        Future.delayed(const Duration(seconds: 30), () {
          // if host isnt found run the loop again in 30 seconds.
          repeatFindHosts();
        });

      } else {
        ActiveHost host = hosts.first;
        context.read<SocketProvider>().connectAndListen(host.ip).whenComplete(() {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const StartScreen(),
            ),
          );
        });
        return;
      }
    });
  }

}
