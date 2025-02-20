import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(MaterialApp(
    home: DigitalPetApp(),
  ));
}

class DigitalPetApp extends StatefulWidget {
  @override
  _DigitalPetAppState createState() => _DigitalPetAppState();
}

class _DigitalPetAppState extends State<DigitalPetApp> {
  String petName = "Your Pet";
  int hungerLevel = 50;
  int energyLevel = 100;
  Timer? hungerTimer;
  Timer? restTimer;

  @override
  void initState() {
    super.initState();
    startHungerTimer();
  }

  void startHungerTimer() {
    hungerTimer = Timer.periodic(Duration(seconds: 30), (timer) {
      setState(() {
        hungerLevel = (hungerLevel + 5).clamp(0, 100);
      });
    });
  }

  void startRestTimer() {
    restTimer?.cancel();
    restTimer = Timer.periodic(Duration(seconds: 30), (timer) {
      setState(() {
        energyLevel = (energyLevel + 5).clamp(0, 100);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Digital Pet'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Name: $petName', style: TextStyle(fontSize: 20.0)),
            Text('Hunger Level: $hungerLevel', style: TextStyle(fontSize: 20.0)),
            Text('Energy Level: $energyLevel', style: TextStyle(fontSize: 20.0)),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    hungerTimer?.cancel();
    restTimer?.cancel();
    super.dispose();
  }
}