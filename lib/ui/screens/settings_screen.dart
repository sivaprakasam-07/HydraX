import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart';
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
    var themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Settings',
          style: Theme.of(context).textTheme.headlineSmall, // Ensure text color adapts to theme
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Adjust Temperature',
              style: Theme.of(context).textTheme.titleLarge, // Ensure text color adapts to theme
            ),
            SizedBox(height: 10),
            TemperatureControl(
              temperature: _selectedTemperature,
              onIncrease: _increaseTemperature,
              onDecrease: _decreaseTemperature,
            ),
            SizedBox(height: 20),
            Divider(color: Colors.grey),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.wb_sunny, color: Colors.yellow),
                Switch(
                  value: themeProvider.isDarkMode,
                  onChanged: (value) {
                    themeProvider.toggleTheme();
                  },
                ),
                Icon(Icons.nightlight_round, color: Colors.blue),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
