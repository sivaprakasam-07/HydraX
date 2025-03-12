import 'package:flutter/material.dart';
import '../widgets/hydration_chart.dart';

class StatsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hydration Stats'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Water Intake History',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            SizedBox(height: 10),

            // 📊 Hydration Chart
            Expanded(
              child: HydrationChart(), // 🔥 Placeholder for chart
            ),

            Divider(),
            SizedBox(height: 10),

            Text(
              'Temperature Logs',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            SizedBox(height: 10),

            // 📜 Placeholder for temperature logs
            Expanded(
              child: ListView.builder(
                itemCount: 5, // 🔥 Sample data count
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      'Day ${index + 1}: 500ml - 25°C',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    leading: Icon(Icons.thermostat, color: Colors.blue),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
