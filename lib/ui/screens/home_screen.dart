import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import '../widgets/battery_status.dart';
import '../widgets/hydration_chart.dart';
import '../widgets/water_bottle.dart';
import '../widgets/temperature_chart.dart';
import 'settings_screen.dart';
import '../../services/bluetooth_service.dart';
import '../../providers/theme_provider.dart';
import '../../services/firebase_service.dart';
import '../../services/location_service.dart';
import '../../services/weather_service.dart';
import '../../models/weather_model.dart';

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

  /// ✅ **Environmental Adaptation Toggle State**
  bool _environmentalAdaptationEnabled = false;

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..repeat(reverse: true);

    _loadEnvironmentalAdaptationPreference(); // ✅ Load Environmental Adaptation State on Start
    _checkAndUpdateTemperature();
    print("🔍 Checking Environmental Adaptation...");
 // ✅ Auto Adjust Temp if Enabled
    _getCurrentLocation();
    // Removed as 'permission' is not defined here.

  }

  /// ✅ **Get Current Location and Print**
  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        print('❌ Location services are disabled.');
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          print('❌ Location permission denied.');
          return;
        }
      }

      // ✅ Add Weather Data Logging
      var position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      WeatherModel? weather = await WeatherService().getWeather(position.latitude, position.longitude);
      if (weather != null) {
        print("✅ Weather Data: ${weather.temperature}°C");
      } else {
        print("⚠️ No Weather Data Retrieved!");
      }
      print("📍 Location Permission Granted: ${permission.toString()}");

      if (permission == LocationPermission.deniedForever) {
        print('❌ Location permissions are permanently denied.');
        return;
      }

      position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      print('📍 Current Location: Lat: ${position.latitude}, Long: ${position.longitude}');
    } catch (e) {
      print('⚠️ Error fetching location: $e');
    }
  }

  @override
  void dispose() {
    _waveController.dispose();
    super.dispose();
  }

  /// ✅ **Load Environmental Adaptation Preference**
  Future<void> _loadEnvironmentalAdaptationPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool savedValue = prefs.getBool("environmentalAdaptation") ?? false;
    setState(() {
      _environmentalAdaptationEnabled = savedValue;
    });
  }

  /// ✅ **Save Environmental Adaptation Preference**
  Future<void> _toggleEnvironmentalAdaptation(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool("environmentalAdaptation", value);
    setState(() {
      _environmentalAdaptationEnabled = value;
    });

    if (value) {
      _checkAndUpdateTemperature(); // 🌡️ Update temperature on toggle
    }
  }

  /// ✅ **Fetch Weather & Update Temperature Automatically**
  Future<void> _checkAndUpdateTemperature() async {
    if (_environmentalAdaptationEnabled) {
      try {
        var position = await LocationService().getCurrentLocation();
        if (position != null) {
          WeatherModel? weather =
              await WeatherService().getWeather(position.latitude, position.longitude);
          if (weather != null) {
            double adaptedTemp = weather.temperature > 25
                ? weather.temperature - 5 // 🔥 Cool if hot
                : weather.temperature + 5; // ❄️ Warm if cold

            /// ✅ **Apply Temperature Limits**
            adaptedTemp = adaptedTemp.clamp(10.0, 50.0);

            setState(() {
              _currentTemperature = adaptedTemp;
            });
            print("✅ Adapted Temp: ${_currentTemperature.round()}°C based on environment");
          } else {
            print('⚠️ Failed to fetch weather data.');
          }
        } else {
          print('❌ Failed to get location.');
        }
      } catch (e) {
        print('⚠️ Error updating temperature: $e');
      }
    }
  }

  void _onNavBarTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  /// ✅ **Bluetooth Connection Handler**
  Future<void> _handleBluetoothConnection() async {
    if (_isBluetoothConnected) {
      await _bluetoothService.disconnect();
      setState(() {
        _isBluetoothConnected = false;
      });
    } else {
      bool success = await _bluetoothService.scanAndConnect();
      if (success) {
        setState(() {
          _isBluetoothConnected = true;
        });
      }
    }
  }

  /// ✅ **Toggle Charging**
  void _toggleCharging() {
    setState(() {
      _isCharging = !_isCharging;
    });
  }

  /// ✅ **Increase/Decrease Temperature with Clamping**
  void _changeTemperature(bool increase) {
    setState(() {
      if (increase) {
        _currentTemperature = (_currentTemperature + 1.0).clamp(10.0, 50.0);
      } else {
        _currentTemperature = (_currentTemperature - 1.0).clamp(10.0, 50.0);
      }
    });
  }

  /// ✅ **Fix Temperature and Log to Firebase**
  Future<void> _fixTemperature() async {
    try {
      await FirebaseService().logTemperature(_currentTemperature.round().toDouble());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('✅ Temperature logged successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ Failed to log temperature!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);
    bool isDarkMode = themeProvider.isDarkMode;

    List<Widget> _screens = [
      _buildHomeScreen(),
      Padding(padding: EdgeInsets.all(10), child: HydrationChart()),
      WaterBottle(fillPercentage: _waterFillLevel),
      Padding(
        padding: EdgeInsets.all(10),
        child: TemperatureChart(
          temperatureValues: [25, 24, 26, 23, 27, 22, 28],
          maxTemperatureValues: [30, 30, 30, 30, 30, 30, 30],
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
            icon: Icon(
              Icons.settings,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
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
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: "Analysis",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_drink),
            label: "Hydration",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.thermostat),
            label: "Temp Log",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Settings",
          ),
        ],
      ),
    );
  }

  /// ✅ **Updated Home Screen with Bluetooth & Temperature Controls + Environmental Adaptation Toggle**
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
            textColor: isDarkMode ? Colors.white : Colors.black,
          ),
          SizedBox(height: 20),

          /// ✅ **Bluetooth Button**
          ElevatedButton.icon(
            onPressed: _handleBluetoothConnection,
            icon: Icon(
              _isBluetoothConnected
                  ? Icons.bluetooth_disabled
                  : Icons.bluetooth,
            ),
            label: Text(
              _isBluetoothConnected
                  ? "Disconnect Bluetooth"
                  : "Connect Bluetooth",
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: _isBluetoothConnected ? Colors.red : Colors.blue,
            ),
          ),
          SizedBox(height: 20),

          /// ✅ **Charging Button**
          ElevatedButton.icon(
            onPressed: _toggleCharging,
            icon: Icon(_isCharging ? Icons.flash_off : Icons.flash_on),
            label: Text(_isCharging ? "Stop Charging" : "Start Charging"),
            style: ElevatedButton.styleFrom(
              backgroundColor: _isCharging ? Colors.orange : Colors.green,
            ),
          ),
          SizedBox(height: 20),

          /// ✅ **Temperature Controls**
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.remove_circle, color: Colors.blue, size: 32),
                onPressed: () => _changeTemperature(false),
              ),
              Text(
                "${_currentTemperature.round()}°C", // ✅ Rounded to Integer
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              IconButton(
                icon: Icon(Icons.add_circle, color: Colors.red, size: 32),
                onPressed: () => _changeTemperature(true),
              ),
            ],
          ),
          SizedBox(height: 10),

          /// ✅ **Fix Temperature Button**
          ElevatedButton(
            onPressed: _fixTemperature,
            child: Text('Fix Temperature'),
          ),
          SizedBox(height: 30),

          /// ✅ **Environmental Adaptation Toggle**
          SwitchListTile(
            title: Text("Environmental Adaptation"),
            value: _environmentalAdaptationEnabled,
            onChanged: (value) {
              _toggleEnvironmentalAdaptation(value);
            },
          ),
        ],
      ),
    );
  }
}
