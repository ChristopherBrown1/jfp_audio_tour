

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jfp_audio_tour/screens/startScreen.dart';
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
  bool isLoading = false;
  bool showHostList = true;
  final ipController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<SocketProvider>().closeSocket();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      context.read<SocketProvider>().findHosts();
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Select the host device")),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                isLoading = true;
              });
              Provider.of<SocketProvider>(context, listen: false).findHosts().then((value) {
                setState(() {
                  isLoading = false;
                });
              });
              },
          )
        ],
      ),
      body: Column(
        children: [
          Center(child: ElevatedButton(onPressed: () {
            setState(() {
              showHostList = !showHostList;
            });
          }, child: showHostList ? const Text("Type an IP") : const Text("Show host list")),),
          Expanded(
            child: showHostList ? hostList() : showTypeIP()
          )
        ],
      ),
    );
  }

  Widget hostList() {
    hosts = context.watch<SocketProvider>().hosts;
    return Container(
      // child: isLoading ? loadingIndicator(context) : Container(
      child: Container(
        child: hosts.isNotEmpty ? ListView.builder(
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
                  startSession(context, host.ip);
                },
              );
            })
            :
        const Center(
          child: Text(
              "   No Hosts Found. Click refresh to try again. \n"
                  "You must have python to reaper running to start."),
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

  Widget showTypeIP() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 450,
          child: TextFormField(
            controller: ipController,
            decoration: const InputDecoration(labelText: "Type IP Address. Example: 192.168.5.23"),
          ),
        ),
        ElevatedButton(onPressed: () {

          startSession(context, ipController.text);

        }, child: const Text("Start")),
      ],
    );
  }

  void startSession(BuildContext context, String ip) {
    context.read<SocketProvider>().connectAndListen(ip).then((value) {
      if(value.runtimeType != SocketException) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const StartScreen(),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text('No connection made. Double check the IP address.\nAlso, ensure reaper and the python script are both running.'),
          duration: const Duration(seconds: 3),
          action: SnackBarAction(
            label: 'Connection not established',
            onPressed: () { },
          ),
        ));
      }
    });
  }

}

//TODO: Iterate through every found device on subnet and send it a message. Connect to the first device that responds and save that IP as a user preference.
