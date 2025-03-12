import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BluetoothScreen extends StatefulWidget {
  @override
  _BluetoothScreenState createState() => _BluetoothScreenState();
}

class _BluetoothScreenState extends State<BluetoothScreen> {
  List<BluetoothDevice> devicesList = [];
  bool isScanning = false;
  BluetoothDevice? connectedDevice;

  @override
  void initState() {
    super.initState();
    scanForDevices(); // 🔵 Start scanning automatically
  }

  // 🔄 Scan for Bluetooth devices
  void scanForDevices() {
    setState(() {
      isScanning = true;
      devicesList.clear(); // 🔥 Clear old results before scanning
    });

    FlutterBluePlus.startScan(timeout: Duration(seconds: 5));

    FlutterBluePlus.scanResults.listen((results) {
      for (ScanResult result in results) {
        if (!devicesList.any((device) => device.id == result.device.id)) {
          setState(() {
            devicesList.add(result.device);
          });
        }
      }
    });

    Future.delayed(Duration(seconds: 5), () {
      setState(() {
        isScanning = false;
      });
      FlutterBluePlus.stopScan(); // 🔥 Stop scanning after timeout
    });
  }

  // ✅ Connect to a Bluetooth device
  void connectToDevice(BluetoothDevice device) async {
    try {
      setState(() {
        connectedDevice = device;
      });

      await device.connect();
      setState(() {
        connectedDevice = device; // ✅ Save connected device
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Connected to ${device.name}")),
      );
    } catch (e) {
      print("Connection Error: $e");
      setState(() {
        connectedDevice = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to connect")),
      );
    }
  }

  @override
  void dispose() {
    FlutterBluePlus.stopScan(); // 🔥 Stop scanning when screen is closed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Bluetooth Devices"),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: scanForDevices, // 🔄 Rescan devices
          ),
        ],
      ),
      body: Column(
        children: [
          if (isScanning)
            LinearProgressIndicator(
              backgroundColor: Colors.grey[800],
              color: Colors.blueAccent,
            ),

          Expanded(
            child: devicesList.isEmpty
                ? Center(
                    child: Text(
                      isScanning ? "Scanning for devices..." : "No devices found",
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                : ListView.builder(
                    itemCount: devicesList.length,
                    itemBuilder: (context, index) {
                      BluetoothDevice device = devicesList[index];

                      return ListTile(
                        title: Text(
                          device.name.isNotEmpty ? device.name : "Unknown Device",
                          style: TextStyle(color: Colors.white),
                        ),
                        subtitle: Text(device.id.toString(),
                            style: TextStyle(color: Colors.white70)),
                        trailing: connectedDevice?.id == device.id
                            ? Icon(Icons.check_circle, color: Colors.greenAccent)
                            : Icon(Icons.bluetooth, color: Colors.blueAccent),
                        onTap: () => connectToDevice(device),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
