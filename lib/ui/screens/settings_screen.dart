import 'package:flutter/material.dart';
import '../widgets/temperature_control.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  double _selectedTemperature = 25.0;

  void _increaseTemperature() {
    setState(() {
      if (_selectedTemperature < 50) _selectedTemperature += 1;
    });
  }

  void _decreaseTemperature() {
    setState(() {
      if (_selectedTemperature > 10) _selectedTemperature -= 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Dark theme background
      appBar: AppBar(
        title: Text('Settings'),
        backgroundColor: Colors.greenAccent, // Themed color
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Adjust Temperature',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
            SizedBox(height: 10),
            TemperatureControl(
              temperature: _selectedTemperature,
              onIncrease: _increaseTemperature,
              onDecrease: _decreaseTemperature,
            ),
            SizedBox(height: 20),
            Divider(color: Colors.white54),
            SizedBox(height: 10),
            Text(
              'More Settings Coming Soon...',
              style: TextStyle(fontSize: 16, color: Colors.white54),
            ),
          ],
        ),
      ),
    );
  }
}
