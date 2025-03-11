import 'package:flutter/material.dart';

class BatteryStatus extends StatelessWidget {
  final double batteryLevel; // Battery percentage

  BatteryStatus({required this.batteryLevel});

  @override
  Widget build(BuildContext context) {
    Color batteryColor = batteryLevel <= 20 ? Colors.redAccent : Colors.greenAccent;

    return Column(
      children: [
        Text(
          'Battery',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 10),
        Stack(
          alignment: Alignment.center,
          children: [
            // Battery Outline
            Container(
              width: 80,
              height: 30,
              decoration: BoxDecoration(
                border: Border.all(color: batteryColor, width: 2),
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            // Battery Fill Level
            FractionallySizedBox(
              widthFactor: batteryLevel / 100,
              child: Container(
                height: 28,
                decoration: BoxDecoration(
                  color: batteryColor,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
            // Battery Percentage Text
            Text(
              '${batteryLevel.toInt()}%',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
