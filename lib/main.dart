import 'package:flutter/material.dart';
import 'ui/screens/home_screen.dart';
import 'ui/screens/settings_screen.dart';
import './ui/widgets/temperature_control.dart';


void main() {
  runApp(HydraXApp());
}

class HydraXApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
