import 'dart:async';

import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jfp_audio_tour/models/userPreferences.dart';
import 'package:jfp_audio_tour/screens/hostDeviceSelectionScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'autoStartScreen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late Timer _timer;
  int _totalTime = 10;
  bool editSettings = false;
  bool automaticDeviceDiscovery = UserPreferences.getAutomaticDetection();
  MaterialColor automaticDiscoveryColor = Colors.green;
  MaterialColor manualDiscoveryColor = Colors.blue;

  @override void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      startTimer();
    });
  }

  @override
  Widget build(BuildContext context) {
    return editSettings ? settingsSelector() : countdownOptions();
  }

  Widget countdownOptions() {
    return GestureDetector(
      onTap: () {
        _timer.cancel();
        setState(() {
          editSettings = true;
        });
      },
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Tap Anywhere to edit Settings, or click skip to continue.',
              textAlign: TextAlign.center,
            ),
            Text(
              _totalTime.toString(),
              textAlign: TextAlign.center,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                    onPressed: () {
                      goToNextScreen();
                    }, child: const Text("Skip")
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget settingsSelector() {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: Column(
        children: [
          Expanded(child: Container()),
          const Center(
              child: Text("Choose Device Discovery Mode", style: TextStyle(fontSize: 22),)
          ),
          SizedBox(height: 30,),
          AnimatedToggleSwitch<bool>.dual(
            current: automaticDeviceDiscovery,
            first: true,
            second: false,
            height: 70,
            indicatorSize: Size(70, 70),
            dif: 120.0,
            borderColor: automaticDeviceDiscovery ? automaticDiscoveryColor : manualDiscoveryColor,
            onChanged: (b) {
              setState(() => automaticDeviceDiscovery = b);
            },
            colorBuilder: (b) => b ? automaticDiscoveryColor : manualDiscoveryColor,
            iconBuilder: (b, size, active) => b
                ? Icon(Icons.search)
                : Icon(Icons.search_off),
            textBuilder: (b, size, active) => b
                ? const Center(child: Text('Automatic', style: TextStyle(fontSize: 20),))
                : const Center(child: Text('Manual', style: TextStyle(fontSize: 20),)),
          ),
          SizedBox(height: 30,),
          ElevatedButton(
            style: ElevatedButton.styleFrom(primary: Colors.green),
              onPressed: () {
                UserPreferences.setAutomaticDetection(automaticDeviceDiscovery).then((value) => goToNextScreen());
              },
              child: const Text("Done", style: TextStyle(fontSize: 20),)
          ),
          Expanded(child: Container())
        ],
      ),
    );
  }

  Widget iconBuilder(int i, Size size, bool active) {
    IconData data = Icons.access_time_rounded;
    if (i.isEven) data = Icons.cancel;
    return Icon(
      data,
      size: size.shortestSide,
    );
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _totalTime--;
      });
      if (_totalTime == 0) {
        timer.cancel();
        setState(() {
          goToNextScreen();
        });
      }
    });
  }

  void goToNextScreen() {
    automaticDeviceDiscovery = UserPreferences.getAutomaticDetection();

    if(automaticDeviceDiscovery) {
      // if automatic selected go to automatic start screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const AutoStartScreen(),
        ),
      );
    } else {
      // if manual entry in user pref. go to device selection screen which also allows for manual entry.
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HostDeviceSelectionScreen(),
        ),
      );
    }
  }

}

