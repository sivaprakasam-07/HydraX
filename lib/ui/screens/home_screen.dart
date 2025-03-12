import 'package:flutter/material.dart';
import '../widgets/battery_status.dart';
import 'settings_screen.dart';
import 'bluetooth_screen.dart';
import '../../services/bluetooth_service.dart';
import 'dart:async';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final MyBluetoothService _bluetoothService = MyBluetoothService();

  double _batteryLevel = 15.0;
  double _currentTemperature = 25.0;
  bool _isCharging = false;
  bool _isBluetoothConnected = false;
  late AnimationController _waveController;
  Timer? _chargingTimer;
  Timer? _bluetoothReconnectTimer; // 🔥 Auto-reconnect Timer

  int _selectedIndex = 0; // For bottom navigation

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..repeat(reverse: true);

    _connectAndMonitorBluetooth(); // 🔵 Start Bluetooth Connection
  }

  @override
  void dispose() {
    _waveController.dispose();
    _chargingTimer?.cancel();
    _bluetoothReconnectTimer?.cancel(); // Stop auto-reconnect timer
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
          _batteryLevel += 2;
          if (_batteryLevel > 100) _batteryLevel = 100;
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

  // ✅ Auto-connect & monitor Bluetooth stability
  Future<void> _connectAndMonitorBluetooth() async {
    var devices = await _bluetoothService.scanForDevices();
    if (devices.isNotEmpty) {
      bool isConnected = await _bluetoothService.connectToDevice(devices[0]);
      setState(() {
        _isBluetoothConnected = isConnected;
      });

      if (isConnected) {
        _updateBluetoothData(); // Start receiving data
      } else {
        _scheduleReconnect(); // 🔥 If not connected, schedule a retry
      }
    } else {
      _scheduleReconnect(); // 🔥 Retry if no devices found
    }
  }

  // ✅ Keep receiving temperature & battery data
  Future<void> _updateBluetoothData() async {
    while (_isBluetoothConnected) {
      double? temp = await _bluetoothService.readTemperature();
      int? battery = await _bluetoothService.readBatteryLevel();

      setState(() {
        if (temp != null) _currentTemperature = temp;
        if (battery != null) _batteryLevel = battery.toDouble();
      });

      await Future.delayed(Duration(seconds: 3)); // Fetch new data every 3 sec

      // 🔥 Check if still connected
      bool stillConnected = await _bluetoothService.isConnected();
      if (!stillConnected) {
        setState(() {
          _isBluetoothConnected = false;
        });
        _scheduleReconnect(); // 🔥 Auto-reconnect if lost
        break;
      }
    }
  }

  // 🔥 Auto-reconnect mechanism (tries every 5 sec)
  void _scheduleReconnect() {
    _bluetoothReconnectTimer?.cancel(); // Stop previous timer
    _bluetoothReconnectTimer = Timer(Duration(seconds: 5), () {
      if (!_isBluetoothConnected) {
        print("🔄 Reconnecting to Bluetooth...");
        _connectAndMonitorBluetooth();
      }
    });
  }

  void _onNavBarTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => BluetoothScreen()),
      );
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SettingsScreen()),
      );
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

            BatteryStatus(
              batteryLevel: _batteryLevel,
              isCharging: _isCharging,
              waveController: _waveController,
            ),

            SizedBox(height: 10),

            ElevatedButton(
              onPressed: _toggleCharging,
              child: Text(_isCharging ? "Stop Charging" : "Start Charging"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
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

      // 📌 Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.greenAccent,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.black,
        currentIndex: _selectedIndex,
        onTap: _onNavBarTapped,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.bluetooth), label: "Bluetooth"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
        ],
      ),
    );
  }
}
