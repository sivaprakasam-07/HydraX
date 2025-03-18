// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../widgets/battery_status.dart';
// import '../widgets/hydration_chart.dart';
// import '../widgets/water_bottle.dart';
// import '../widgets/temperature_chart.dart'; // ✅ Temp Log Added
// import 'settings_screen.dart';
// import '../../services/bluetooth_service.dart';
// import '../../providers/theme_provider.dart';
// import 'package:hydrax/services/firebase_service.dart';

// class HomeScreen extends StatefulWidget {
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
//   final MyBluetoothService _bluetoothService = MyBluetoothService();

//   double _batteryLevel = 15.0;
//   double _currentTemperature = 25.0;
//   bool _isCharging = false;
//   bool _isBluetoothConnected = false;
//   double _waterFillLevel = 0.5;
//   late AnimationController _waveController;
//   int _selectedIndex = 0;

//   /// ✅ **User Adaptation Toggle State**
//   bool _userAdaptationEnabled = false;

//   @override
//   void initState() {
//     super.initState();
//     _waveController = AnimationController(
//       vsync: this,
//       duration: Duration(seconds: 2),
//     )..repeat(reverse: true);

//     _loadUserAdaptationPreference(); // ✅ Load User Adaptation State on Start
//   }

//   @override
//   void dispose() {
//     _waveController.dispose();
//     super.dispose();
//   }

//   /// ✅ **Load User Adaptation Preference**
//   Future<void> _loadUserAdaptationPreference() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     bool savedValue = prefs.getBool("userAdaptation") ?? false;
//     debugPrint("Loaded User Adaptation: $savedValue"); // ✅ Debug print
//     setState(() {
//       _userAdaptationEnabled = savedValue;
//     });
//   }

//   /// ✅ **Save User Adaptation Preference**
//   Future<void> _toggleUserAdaptation(bool value) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.setBool("userAdaptation", value);
//     debugPrint("Saved User Adaptation: $value"); // ✅ Debug print
//     setState(() {
//       _userAdaptationEnabled = value;
//     });
//   }

//   void _onNavBarTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   /// ✅ **Bluetooth Connection Handler**
//   Future<void> _handleBluetoothConnection() async {
//     if (_isBluetoothConnected) {
//       await _bluetoothService.disconnect();
//       setState(() {
//         _isBluetoothConnected = false;
//       });
//     } else {
//       bool success = await _bluetoothService.scanAndConnect();
//       if (success) {
//         setState(() {
//           _isBluetoothConnected = true;
//         });
//       }
//     }
//   }

//   /// ✅ **Toggle Charging**
//   void _toggleCharging() {
//     setState(() {
//       _isCharging = !_isCharging;
//     });
//   }

//   /// ✅ **Increase/Decrease Temperature**
//   void _changeTemperature(bool increase) {
//     setState(() {
//       if (increase) {
//         _currentTemperature += 1.0;
//       } else {
//         _currentTemperature -= 1.0;
//       }
//     });
//   }

//   /// ✅ **Fix Temperature Function**
//   void _fixTemperature() {
//     setState(() {
//       _currentTemperature = 25.0; // Default Temperature Reset
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     var themeProvider = Provider.of<ThemeProvider>(context);
//     bool isDarkMode = themeProvider.isDarkMode;

//     List<Widget> _screens = [
//       _buildHomeScreen(),
//       Padding(padding: EdgeInsets.all(10), child: HydrationChart()),
//       WaterBottle(fillPercentage: _waterFillLevel),
//       Padding(
//         padding: EdgeInsets.all(10),
//         child: TemperatureChart(
//           temperatureValues: [25, 24, 26, 23, 27, 22, 28], // ✅ Fixed Data
//           maxTemperatureValues: [
//             30,
//             30,
//             30,
//             30,
//             30,
//             30,
//             30,
//           ], // ✅ Fixed Missing Argument
//         ),
//       ),
//       SettingsScreen(),
//     ];

//     return Scaffold(
//       backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//       appBar: AppBar(
//         title: Text(
//           'HydraX',
//           style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
//         ),
//         backgroundColor: Theme.of(context).primaryColor,
//         actions: [
//           IconButton(
//             icon: Icon(
//               Icons.settings,
//               color: isDarkMode ? Colors.white : Colors.black,
//             ),
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => SettingsScreen()),
//               );
//             },
//           ),
//           Switch(
//             value: isDarkMode,
//             onChanged: (value) {
//               themeProvider.toggleTheme();
//             },
//           ),
//         ],
//       ),
//       body: _screens[_selectedIndex],

//       bottomNavigationBar: BottomNavigationBar(
//         backgroundColor: Theme.of(context).primaryColor,
//         selectedItemColor: isDarkMode ? Colors.cyanAccent : Colors.blueAccent,
//         unselectedItemColor: isDarkMode ? Colors.grey : Colors.black,
//         currentIndex: _selectedIndex,
//         onTap: _onNavBarTapped,
//         items: [
//           BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.bar_chart),
//             label: "Analysis",
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.local_drink),
//             label: "Hydration",
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.thermostat),
//             label: "Temp Log",
//           ), // ✅ Fixed
//           BottomNavigationBarItem(
//             icon: Icon(Icons.settings),
//             label: "Settings",
//           ),
//         ],
//       ),
//     );
//   }

//   /// ✅ **Updated Home Screen with Bluetooth & Temperature Controls + User Adaptation Toggle**
//   Widget _buildHomeScreen() {
//     bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Text(
//             'HydraX',
//             style: TextStyle(
//               fontSize: 24,
//               fontWeight: FontWeight.bold,
//               color: isDarkMode ? Colors.white : Colors.black,
//             ),
//           ),
//           SizedBox(height: 20),
//           BatteryStatus(
//             batteryLevel: _batteryLevel,
//             isCharging: _isCharging,
//             waveController: _waveController,
//             textColor: isDarkMode ? Colors.white : Colors.black,
//           ),
//           SizedBox(height: 20),

//           /// ✅ **Bluetooth Button**
//           ElevatedButton.icon(
//             onPressed: _handleBluetoothConnection,
//             icon: Icon(
//               _isBluetoothConnected
//                   ? Icons.bluetooth_disabled
//                   : Icons.bluetooth,
//             ),
//             label: Text(
//               _isBluetoothConnected
//                   ? "Disconnect Bluetooth"
//                   : "Connect Bluetooth",
//             ),
//             style: ElevatedButton.styleFrom(
//               backgroundColor: _isBluetoothConnected ? Colors.red : Colors.blue,
//             ),
//           ),

//           SizedBox(height: 20),

//           /// ✅ **Charging Button**
//           ElevatedButton.icon(
//             onPressed: _toggleCharging,
//             icon: Icon(_isCharging ? Icons.flash_off : Icons.flash_on),
//             label: Text(_isCharging ? "Stop Charging" : "Start Charging"),
//             style: ElevatedButton.styleFrom(
//               backgroundColor: _isCharging ? Colors.orange : Colors.green,
//             ),
//           ),

//           SizedBox(height: 20),

//           /// ✅ **Temperature Controls**
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               IconButton(
//                 icon: Icon(Icons.remove_circle, color: Colors.blue, size: 32),
//                 onPressed: () => _changeTemperature(false),
//               ),
//               Text(
//                 "${_currentTemperature.toStringAsFixed(1)}°C",
//                 style: TextStyle(
//                   fontSize: 22,
//                   fontWeight: FontWeight.bold,
//                   color: isDarkMode ? Colors.white : Colors.black,
//                 ),
//               ),
//               IconButton(
//                 icon: Icon(Icons.add_circle, color: Colors.red, size: 32),
//                 onPressed: () => _changeTemperature(true),
//               ),
//             ],
//           ),

//           SizedBox(height: 10),

//           /// ✅ **Fix Temperature Button**
//           ElevatedButton(
//             onPressed: () async {
//               double selectedTemperature =
//                   25.5; // Replace with actual selected value
//               await FirebaseService().logTemperature(selectedTemperature);

//               // Optional: Show success message
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(content: Text('✅ Temperature logged successfully!')),
//               );
//             },
//             child: Text('Fix Temperature'),
//           ),

//           SizedBox(height: 30),

//           SwitchListTile(
//             title: Text("User Adaptation"),
//             value: _userAdaptationEnabled,
//             onChanged: (value) {
//               _toggleUserAdaptation(value);
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/battery_status.dart';
import '../widgets/hydration_chart.dart';
import '../widgets/water_bottle.dart';
import '../widgets/temperature_chart.dart'; // ✅ Temp Log Added
import 'settings_screen.dart';
import '../../services/bluetooth_service.dart';
import '../../providers/theme_provider.dart';
import 'package:hydrax/services/firebase_service.dart';

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

  /// ✅ **User Adaptation Toggle State**
  bool _userAdaptationEnabled = false;

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..repeat(reverse: true);

    _loadUserAdaptationPreference(); // ✅ Load User Adaptation State on Start
  }

  @override
  void dispose() {
    _waveController.dispose();
    super.dispose();
  }

  /// ✅ **Load User Adaptation Preference**
  Future<void> _loadUserAdaptationPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool savedValue = prefs.getBool("userAdaptation") ?? false;
    setState(() {
      _userAdaptationEnabled = savedValue;
    });
  }

  /// ✅ **Save User Adaptation Preference**
  Future<void> _toggleUserAdaptation(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool("userAdaptation", value);
    setState(() {
      _userAdaptationEnabled = value;
    });
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

  /// ✅ **Increase/Decrease Temperature**
  void _changeTemperature(bool increase) {
    setState(() {
      if (increase) {
        _currentTemperature += 1.0;
      } else {
        _currentTemperature -= 1.0;
      }
    });
  }

  /// ✅ **Fix Temperature and Log to Firebase**
  Future<void> _fixTemperature() async {
    try {
      await FirebaseService().logTemperature(_currentTemperature);

      // ✅ Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('✅ Temperature logged successfully!')),
      );
    } catch (e) {
      // ❌ Show error message
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
          temperatureValues: [25, 24, 26, 23, 27, 22, 28], // ✅ Fixed Data
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

  /// ✅ **Updated Home Screen with Bluetooth & Temperature Controls + User Adaptation Toggle**
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
                "${_currentTemperature.toStringAsFixed(1)}°C",
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

          /// ✅ **User Adaptation Toggle**
          SwitchListTile(
            title: Text("User Adaptation"),
            value: _userAdaptationEnabled,
            onChanged: (value) {
              _toggleUserAdaptation(value);
            },
          ),
        ],
      ),
    );
  }
}
