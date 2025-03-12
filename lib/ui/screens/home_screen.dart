import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart'; // For Bluetooth
import '../widgets/battery_status.dart';
import 'settings_screen.dart';
import 'bluetooth_screen.dart'; // Import Bluetooth screen
import 'dart:async'; // Needed for auto battery charging

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  double _batteryLevel = 15.0; // Battery Level
  double _currentTemperature = 25.0;
  bool _isCharging = false; // Charging state
  bool _isBluetoothConnected = false; // Bluetooth connection status
  late AnimationController _waveController;
  Timer? _chargingTimer; // Timer to handle battery increase

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _waveController.dispose();
    _chargingTimer?.cancel(); // Stop charging when screen is closed
    super.dispose();
  }

  void _increaseTemperature() {
    setState(() {
      if (_currentTemperature < 50) _currentTemperature += 1;
    });
  }

  void _decreaseTemperature() {
    setState(() {
      if (_currentTemperature > 10) _currentTemperature -= 1;
    });
  }

  void _toggleCharging() {
    setState(() {
      _isCharging = !_isCharging;
    });

    if (_isCharging) {
      _startCharging();
    } else {
      _stopCharging();
    }
  }

  void _startCharging() {
    _chargingTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_batteryLevel >= 100) {
        _stopCharging();
      } else {
        setState(() {
          _batteryLevel += 2; // Battery increases by 2% every second
          if (_batteryLevel > 100) _batteryLevel = 100; // Prevents overflow
        });
      }
    });
  }

  void _stopCharging() {
    _chargingTimer?.cancel();
    setState(() {
      _isCharging = false;
    });
  }

  Future<void> _connectBluetooth() async {
    final selectedDevice = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BluetoothScreen()),
    );

    if (selectedDevice != null) {
      setState(() {
        _isBluetoothConnected = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('HydraX'),
        backgroundColor: Colors.greenAccent,
        actions: [
          IconButton(
            icon: Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'HydraX',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 20),

            // 🔋 Battery Status Widget (With Charging Animation)
            BatteryStatus(
              batteryLevel: _batteryLevel,
              isCharging: _isCharging,
              waveController: _waveController,
            ),

            SizedBox(height: 10),

            // Toggle Charging Button
            ElevatedButton(
              onPressed: _toggleCharging,
              child: Text(_isCharging ? "Stop Charging" : "Start Charging"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
              ),
            ),

            SizedBox(height: 10),

            // 🔵 Bluetooth Connection Button
            ElevatedButton(
              onPressed: _connectBluetooth,
              child: Text(_isBluetoothConnected ? "Bluetooth: Connected" : "Connect Bluetooth"),
              style: ElevatedButton.styleFrom(
                backgroundColor: _isBluetoothConnected ? Colors.green : Colors.blueAccent,
                foregroundColor: Colors.white,
              ),
            ),

            SizedBox(height: 20),
            Text(
              'Temperature: ${_currentTemperature.toStringAsFixed(1)}°C',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.remove, size: 30, color: Colors.white),
                  onPressed: _decreaseTemperature,
                ),
                IconButton(
                  icon: Icon(Icons.add, size: 30, color: Colors.white),
                  onPressed: _increaseTemperature,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
