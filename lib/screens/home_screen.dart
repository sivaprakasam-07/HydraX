import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/temperature_control.dart';
import '../widgets/battery_water_level.dart';
import '../widgets/hydration_reminder.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Dark theme for modern UI
      appBar: AppBar(
        title: Text("Smart Water Bottle",
            style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            BatteryWaterLevel(), // Battery & Water Level UI
            SizedBox(height: 20),
            TemperatureControl(), // Temperature Controls
            SizedBox(height: 20),
            HydrationReminder(), // Hydration Reminder Section
          ],
        ),
      ),
    );
  }
}
