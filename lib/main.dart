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
  int happinessLevel = 50;
  int hungerLevel = 50;
  int energyLevel = 100;
  Timer? hungerTimer;
  Timer? restTimer;
  String selectedActivity = "Play";

  @override
  void initState() {
    super.initState();
    startHungerTimer();
  }

  void startHungerTimer() {
    hungerTimer = Timer.periodic(Duration(seconds: 30), (timer) {
      setState(() {
        hungerLevel = (hungerLevel + 5).clamp(0, 100);
        happinessLevel = (happinessLevel - 5).clamp(0, 100);
        if (hungerLevel >= 100 && happinessLevel <= 10) {
          showGameOverDialog();
        }
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

  void _selectActivity(String activity) {
    setState(() {
      selectedActivity = activity;
    });
  }

  void _performActivity() {
    setState(() {
      if (selectedActivity == "Play") {
        happinessLevel = (happinessLevel + 10).clamp(0, 100);
        energyLevel = (energyLevel - 10).clamp(0, 100);
      } else if (selectedActivity == "Rest") {
        startRestTimer();
      }
    });
  }

  void _playWithPet() {
    setState(() {
      happinessLevel = (happinessLevel + 10).clamp(0, 100);
      hungerLevel = (hungerLevel + 5).clamp(0, 100);
      energyLevel = (energyLevel - 10).clamp(0, 100);
    });
  }

  void _feedPet() {
    setState(() {
      hungerLevel = (hungerLevel - 10).clamp(0, 100);
      happinessLevel = (happinessLevel + 5).clamp(0, 100);
    });
  }

  void _setPetName(String name) {
    setState(() {
      petName = name;
    });
  }

  void showGameOverDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Game Over"),
        content: Text("Your pet has become too hungry and sad!"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                happinessLevel = 50;
                hungerLevel = 50;
              });
            },
            child: Text("Restart"),
          )
        ],
      ),
    );
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
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Name: $petName', style: TextStyle(fontSize: 20.0)),
              SizedBox(height: 16.0),
              ColorFiltered(
                colorFilter: ColorFilter.mode(
                    getPetColor().withOpacity(0.5), BlendMode.srcATop),
                child: Image.asset('assets/dog.jpg', width: 150, height: 150),
              ),
              SizedBox(height: 16.0),
              Text(getMoodText(), style: TextStyle(fontSize: 20.0)),
              SizedBox(height: 16.0),
              Text('Happiness Level: $happinessLevel',
                  style: TextStyle(fontSize: 20.0)),
              Text('Hunger Level: $hungerLevel',
                  style: TextStyle(fontSize: 20.0)),
              Text('Energy Level: $energyLevel',
                  style: TextStyle(fontSize: 20.0)),
              SizedBox(height: 16.0),
              LinearProgressIndicator(
                value: energyLevel / 100,
                backgroundColor: Colors.grey[300],
                color: Colors.blue,
              ),
              SizedBox(height: 16.0),
              DropdownButton<String>(
                value: selectedActivity,
                items: ["Play", "Rest"].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) _selectActivity(newValue);
                },
              ),
              ElevatedButton(
                onPressed: _performActivity,
                child: Text('Perform Activity'),
              ),
              ElevatedButton(
                onPressed: _playWithPet,
                child: Text('Play with Your Pet'),
              ),
              ElevatedButton(
                onPressed: _feedPet,
                child: Text('Feed Your Pet'),
              ),
              SizedBox(height: 16.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Enter Pet Name',
                    border: OutlineInputBorder(),
                  ),
                  onSubmitted: _setPetName,
                ),
              ),
            ],
          ),
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
