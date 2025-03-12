import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BluetoothScreen extends StatefulWidget {
  @override
  _BluetoothScreenState createState() => _BluetoothScreenState();
}

class _BluetoothScreenState extends State<BluetoothScreen> {
  FlutterBluePlus flutterBlue = FlutterBluePlus();
  List<BluetoothDevice> devicesList = [];

  @override
  void initState() {
    super.initState();
    scanForDevices();
  }

  void scanForDevices() {
    FlutterBluePlus.startScan(timeout: Duration(seconds: 5));

    FlutterBluePlus.scanResults.listen((results) {
      for (ScanResult result in results) {
        if (!devicesList.contains(result.device)) {
          setState(() {
            devicesList.add(result.device);
          });
        }
      }
    });
  }

  void connectToDevice(BluetoothDevice device) async {
    await device.connect();
    Navigator.pop(context, device);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Select a Device"),
        backgroundColor: Colors.blueAccent,
      ),
      body: devicesList.isEmpty
          ? Center(child: CircularProgressIndicator(color: Colors.white))
          : ListView.builder(
              itemCount: devicesList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    devicesList[index].name.isNotEmpty
                        ? devicesList[index].name
                        : "Unknown Device",
                    style: TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(devicesList[index].id.toString(),
                      style: TextStyle(color: Colors.white70)),
                  trailing: Icon(Icons.bluetooth, color: Colors.blueAccent),
                  onTap: () => connectToDevice(devicesList[index]),
                );
              },
            ),
    );
  }
}
