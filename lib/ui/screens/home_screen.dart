import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/battery_status.dart';
import '../widgets/hydration_chart.dart';
import '../widgets/water_bottle.dart';
import '../widgets/temperature_chart.dart';
import 'settings_screen.dart';
import '../../services/bluetooth_service.dart';
import '../../providers/theme_provider.dart';

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
  double _waterFillLevel = 0.5;
  late AnimationController _waveController;
  int _selectedIndex = 0;

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
    super.dispose();
  }

  void _onNavBarTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _increaseTemperature() {
    setState(() {
      if (_currentTemperature < 50) _currentTemperature += 1; // Max 50°C
    });
  }

  void _decreaseTemperature() {
    setState(() {
      if (_currentTemperature > 10) _currentTemperature -= 1; // Min 10°C
    });
  }

  void _toggleCharging() {
    setState(() {
      _isCharging = !_isCharging;
    });
  }

  void _toggleBluetooth() {
    setState(() {
      _isBluetoothConnected = !_isBluetoothConnected;
    });
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);
    bool isDarkMode = themeProvider.isDarkMode;

    List<Widget> _screens = [
      _buildHomeScreen(),
      Padding(
        padding: EdgeInsets.all(10),
        child: HydrationChart(),
      ),
      WaterBottle(fillPercentage: _waterFillLevel),
      Padding(
        padding: EdgeInsets.all(10),
        child: TemperatureChart(
          temperatureValues: [25, 24, 26, 23, 27, 22, 28], // Actual Temp (Blue Bars)
          maxTemperatureValues: [30, 30, 30, 30, 30, 30, 30], // Max Temp (Gray Background)
        ),
      ),
      SettingsScreen(),
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
              Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsScreen()));
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
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: "Analysis"),
          BottomNavigationBarItem(icon: Icon(Icons.local_drink), label: "Hydration"),
          BottomNavigationBarItem(icon: Icon(Icons.thermostat), label: "Temp Log"), // ✅ Fixed
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
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
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: isDarkMode ? Colors.white : Colors.black),
          ),
          SizedBox(height: 20),
          BatteryStatus(
            batteryLevel: _batteryLevel,
            isCharging: _isCharging,
            waveController: _waveController,
            textColor: isDarkMode ? Colors.white : Colors.black,
          ),
          SizedBox(height: 20),

          // Temperature Display & Controls
          Text(
            "Temperature: ${_currentTemperature.toInt()}°C",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isDarkMode ? Colors.white : Colors.black),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.remove, color: Colors.red),
                onPressed: _decreaseTemperature,
              ),
              IconButton(
                icon: Icon(Icons.add, color: Colors.green),
                onPressed: _increaseTemperature,
              ),
            ],
          ),

          // Charging & Bluetooth Buttons
          SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: _toggleCharging,
            icon: Icon(_isCharging ? Icons.bolt : Icons.power),
            label: Text(_isCharging ? "Stop Charging" : "Start Charging"),
            style: ElevatedButton.styleFrom(
              backgroundColor: _isCharging ? Colors.orange : Colors.blue,
            ),
          ),
          SizedBox(height: 10),
          ElevatedButton.icon(
            onPressed: _toggleBluetooth,
            icon: Icon(_isBluetoothConnected ? Icons.bluetooth_connected : Icons.bluetooth_disabled),
            label: Text(_isBluetoothConnected ? "Disconnect Bluetooth" : "Connect Bluetooth"),
            style: ElevatedButton.styleFrom(
              backgroundColor: _isBluetoothConnected ? Colors.green : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
