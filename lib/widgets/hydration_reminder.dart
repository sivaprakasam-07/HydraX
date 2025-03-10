import 'package:flutter/material.dart';

class HydrationReminder extends StatefulWidget {
  @override
  _HydrationReminderState createState() => _HydrationReminderState();
}

class _HydrationReminderState extends State<HydrationReminder> {
  bool reminderOn = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("Hydration Reminder",
            style: TextStyle(color: Colors.white, fontSize: 18)),
        Switch(
          value: reminderOn,
          onChanged: (value) {
            setState(() {
              reminderOn = value;
            });
          },
          activeColor: Colors.blueAccent,
        ),
      ],
    );
  }
}
