import 'package:flutter/material.dart';

class TemperatureControl extends StatefulWidget {
  @override
  _TemperatureControlState createState() => _TemperatureControlState();
}

class _TemperatureControlState extends State<TemperatureControl> {
  double _currentTemperature = 25.0; // Default temperature

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("Temperature: ${_currentTemperature.toInt()}°C",
            style: TextStyle(fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold)),
        Slider(
          min: 10,
          max: 50,
          value: _currentTemperature,
          divisions: 8,
          activeColor: Colors.blueAccent,
          onChanged: (value) {
            setState(() {
              _currentTemperature = value;
            });
          },
        ),
      ],
    );
  }
}
