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
  int happinessLevel = 50;
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
        happinessLevel = (happinessLevel - 5)
            .clamp(0, 100); // Happiness decreases as hunger increases
        happinessLevel = (happinessLevel - 5).clamp(0, 100);
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

  Color getPetColor() {
    if (happinessLevel > 70) return Colors.green;
    if (happinessLevel >= 30) return Colors.yellow;
    return Colors.red;
  }

  String getMoodText() {
    if (happinessLevel > 70) return "Happy 😊";
    if (happinessLevel >= 30) return "Neutral 😐";
    return "Unhappy 😢";
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
            Text('Hunger Level: $hungerLevel',
                style: TextStyle(fontSize: 20.0)),
            Text('Happiness Level: $happinessLevel',
                style: TextStyle(fontSize: 20.0)),
            Text('Energy Level: $energyLevel',
                style: TextStyle(fontSize: 20.0)),
            Text('Hunger Level: $hungerLevel', style: TextStyle(fontSize: 20.0)),
            Text('Happiness Level: $happinessLevel', style: TextStyle(fontSize: 20.0)),
            Text('Mood: ${getMoodText()}', style: TextStyle(fontSize: 20.0)),
            Text('Energy Level: $energyLevel', style: TextStyle(fontSize: 20.0)),
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: getPetColor(),
                shape: BoxShape.circle,
              ),
            ),
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
