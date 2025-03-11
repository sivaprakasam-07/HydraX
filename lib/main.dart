import 'package:flutter/material.dart';
import 'ui/screens/home_screen.dart';

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
