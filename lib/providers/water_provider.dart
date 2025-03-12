import 'package:flutter/material.dart';
import '../models/water_model.dart';

class WaterProvider with ChangeNotifier {
  int _currentIntake = 0; // Stores current daily water intake in ml
  List<WaterLog> _waterLogs = []; // Stores historical water logs

  int get currentIntake => _currentIntake;
  List<WaterLog> get waterLogs => _waterLogs;

  // 🥤 Add water intake
  void addWater(int amount) {
    _currentIntake += amount;
    _waterLogs.add(WaterLog(amount: amount, timestamp: DateTime.now()));
    notifyListeners(); // Notifies UI to update
  }

  // 🔄 Reset daily water intake (called at midnight)
  void resetDailyIntake() {
    _currentIntake = 0;
    notifyListeners();
  }
}
