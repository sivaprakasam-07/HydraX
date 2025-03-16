import 'package:flutter/material.dart';
import '../widgets/temperature_chart.dart';

class TemperatureScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Temperature Logs")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Temperature Usage", 
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
            ),
            SizedBox(height: 10),
            Expanded(
              child: TemperatureChart(
                temperatureValues: [], // Add appropriate values
                maxTemperatureValues: [], // Add appropriate values
              ), // ✅ Display Temperature Chart
            ),
          ],
        ),
      ),
    );
  }
}
