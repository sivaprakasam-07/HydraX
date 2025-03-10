import 'package:flutter/material.dart';

class BatteryWaterLevel extends StatelessWidget {
  final double batteryLevel = 80; // Example battery level
  final double waterLevel = 60; // Example water level

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          children: [
            Icon(Icons.battery_charging_full, color: Colors.green, size: 40),
            Text("Battery: ${batteryLevel.toInt()}%",
                style: TextStyle(color: Colors.white)),
          ],
        ),
        Column(
          children: [
            Icon(Icons.water_drop, color: Colors.blueAccent, size: 40),
            Text("Water: ${waterLevel.toInt()}%",
                style: TextStyle(color: Colors.white)),
          ],
        ),
      ],
    );
  }
}
