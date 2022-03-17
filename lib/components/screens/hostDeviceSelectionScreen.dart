

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jfp_audio_tour/components/screens/startScreen.dart';
import 'package:network_tools/network_tools.dart';
import 'package:provider/provider.dart';

import '../../socketProvider.dart';

class HostDeviceSelectionScreen extends StatefulWidget {
  const HostDeviceSelectionScreen({Key? key}) : super(key: key);

  @override
  State<HostDeviceSelectionScreen> createState() => _HostDeviceSelectionScreenState();
}

class _HostDeviceSelectionScreenState extends State<HostDeviceSelectionScreen> {
  Set<ActiveHost> hosts = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      context.read<SocketProvider>().findHosts();
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Center(child: const Text("Select the host device")),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              Provider.of<SocketProvider>(context, listen: false).findHosts();
              },
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: hostList()
          )
        ],
      ),
    );
  }

  Widget hostList() {
    hosts = context.watch<SocketProvider>().hosts;
    return hosts.isNotEmpty ? ListView.builder(
        itemCount: hosts.length,
        itemBuilder: (BuildContext context,int index) {
          ActiveHost host = hosts.elementAt(index);
          return GestureDetector(
            child: Card(
              child: ListTile(
                leading: const Icon(Icons.devices),
                title: Text(host.ip),
                trailing: Text(host.make),
              ),
            ),
            onTap: () {
              context.read<SocketProvider>().connectAndListen(host.ip).whenComplete(() {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const StartScreen(),
                  ),
                );
              });
              // TODO: when connected go to first page.
            },
          );
        })
        :
    const Center(
      child: Text(
          "   No Hosts Found. Click refresh to try again. \n"
              "You must have python to reaper running to start."),
    );
  }

}

//TODO: Iterate through every found device on subnet and send it a message. Connect to the first device that responds and save that IP as a user preference.
