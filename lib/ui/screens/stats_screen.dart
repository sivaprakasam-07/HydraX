// import 'package:flutter/material.dart';
// import '../widgets/hydration_chart.dart';

// class StatsScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Hydration Stats'),
//         backgroundColor: Theme.of(context).primaryColor,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Water Intake History',
//               style: Theme.of(context).textTheme.headlineSmall,
//             ),
//             SizedBox(height: 10),

//             // 📊 Hydration Chart
//             Expanded(
//               child: HydrationChart(), // 🔥 Placeholder for chart
//             ),

//             Divider(),
//             SizedBox(height: 10),

//             Text(
//               'Temperature Logs',
//               style: Theme.of(context).textTheme.headlineSmall,
//             ),
//             SizedBox(height: 10),

//             // 📜 Placeholder for temperature logs
//             Expanded(
//               child: ListView.builder(
//                 itemCount: 5, // 🔥 Sample data count
//                 itemBuilder: (context, index) {
//                   return ListTile(
//                     title: Text(
//                       'Day ${index + 1}: 500ml - 25°C',
//                       style: Theme.of(context).textTheme.bodyLarge,
//                     ),
//                     leading: Icon(Icons.thermostat, color: Colors.blue),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 📊 Hydration Chart Section
            _buildSectionTitle(context, 'Water Intake History'),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: HydrationChart(),
            ),
            
            SizedBox(height: 20),
            Divider(),

            // 🌡️ Temperature Logs Section
            _buildSectionTitle(context, 'Temperature Logs'),
            SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true, // Prevent unnecessary scrolling issues
              physics: NeverScrollableScrollPhysics(), // Uses parent scroll
              itemCount: 5, // 🔥 Sample Data
              itemBuilder: (context, index) {
                return Card(
                  elevation: 3,
                  margin: EdgeInsets.symmetric(vertical: 6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    title: Text(
                      'Day ${index + 1}: 500ml - 25°C',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    leading: Icon(Icons.thermostat, color: Colors.blue),
                    trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // 🔹 Section Title Widget
  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
          ),
    );
  }
}
