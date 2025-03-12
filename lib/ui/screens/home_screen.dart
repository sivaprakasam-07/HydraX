import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/battery_status.dart';
import '../widgets/hydration_chart.dart';
import 'settings_screen.dart';
import 'bluetooth_screen.dart';
import '../../services/bluetooth_service.dart';
import '../../providers/theme_provider.dart';
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
  Timer? _bluetoothReconnectTimer;

  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..repeat(reverse: true);

    _connectAndMonitorBluetooth();
  }

  @override
  void dispose() {
    _waveController.dispose();
    _chargingTimer?.cancel();
    _bluetoothReconnectTimer?.cancel();
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

  Future<void> _connectAndMonitorBluetooth() async {
    var devices = await _bluetoothService.scanForDevices();
    if (devices.isNotEmpty) {
      bool isConnected = await _bluetoothService.connectToDevice(devices[0]);
      setState(() {
        _isBluetoothConnected = isConnected;
      });

      if (isConnected) {
        _updateBluetoothData();
      } else {
        _scheduleReconnect();
      }
    } else {
      _scheduleReconnect();
    }
  }

  Future<void> _updateBluetoothData() async {
    while (_isBluetoothConnected) {
      double? temp = await _bluetoothService.readTemperature();
      int? battery = await _bluetoothService.readBatteryLevel();

      setState(() {
        if (temp != null) _currentTemperature = temp;
        if (battery != null) _batteryLevel = battery.toDouble();
      });

      await Future.delayed(Duration(seconds: 3));

      bool stillConnected = await _bluetoothService.isConnected();
      if (!stillConnected) {
        setState(() {
          _isBluetoothConnected = false;
        });
        _scheduleReconnect();
        break;
      }
    }
  }

  void _scheduleReconnect() {
    _bluetoothReconnectTimer?.cancel();
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
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);
    bool isDarkMode = themeProvider.isDarkMode;

    List<Widget> _screens = [
      _buildHomeScreen(),
      BluetoothScreen(),
      SettingsScreen(),
      HydrationChart(),
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'HydraX',
          style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(
            icon: Icon(Icons.settings, color: isDarkMode ? Colors.white : Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsScreen()),
              );
            },
          ),
          Switch(
            value: isDarkMode,
            onChanged: (value) {
              themeProvider.toggleTheme();
            },
          ),
        ],
      ),
      body: _screens[_selectedIndex],

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).primaryColor,
        selectedItemColor: isDarkMode ? Colors.cyanAccent : Colors.blueAccent,
        unselectedItemColor: isDarkMode ? Colors.grey : Colors.black,
        currentIndex: _selectedIndex,
        onTap: _onNavBarTapped,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.bluetooth), label: "Bluetooth"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: "Hydration"),
        ],
      ),
    );
  }

  Widget _buildHomeScreen() {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'HydraX',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
          SizedBox(height: 20),
          BatteryStatus(
            batteryLevel: _batteryLevel,
            isCharging: _isCharging,
            waveController: _waveController,
            textColor: isDarkMode ? Colors.white : Colors.black, // ✅ Battery % Fix
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: _toggleCharging,
            child: Text(_isCharging ? "Stop Charging" : "Start Charging"),
            style: ElevatedButton.styleFrom(
              backgroundColor: isDarkMode ? Colors.grey[700] : Colors.blueAccent,
              foregroundColor: Colors.white,
            ),
          ),
          SizedBox(height: 20),
          Text(
            'Temperature: ${_currentTemperature.toStringAsFixed(1)}°C',
            style: TextStyle(
              fontSize: 20,
              color: isDarkMode ? Colors.white70 : Colors.black,
            ),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.remove, size: 30, color: isDarkMode ? Colors.white70 : Colors.black),
                onPressed: _decreaseTemperature,
              ),
              IconButton(
                icon: Icon(Icons.add, size: 30, color: isDarkMode ? Colors.white70 : Colors.black),
                onPressed: _increaseTemperature,
              ),
            ],
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _connectAndMonitorBluetooth,
            child: Text("Connect Bluetooth"),
            style: ElevatedButton.styleFrom(
              backgroundColor: isDarkMode ? Colors.tealAccent[700] : Colors.greenAccent,
              foregroundColor: isDarkMode ? Colors.black : Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }
}
