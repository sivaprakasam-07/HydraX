import 'dart:async';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class MyBluetoothService {
  final FlutterBluePlus flutterBlue = FlutterBluePlus();
  BluetoothDevice? connectedDevice;
  BluetoothCharacteristic? temperatureCharacteristic;
  BluetoothCharacteristic? batteryCharacteristic;

  // 🔍 Scan for Bluetooth devices (Fixed for flutter_blue_plus v1.35.3+)
  Future<List<BluetoothDevice>> scanForDevices() async {
    List<BluetoothDevice> devices = [];

    // Listen to scan results
    StreamSubscription? scanSubscription;
    scanSubscription = FlutterBluePlus.scanResults.listen((results) {
      for (ScanResult result in results) {
        if (!devices.contains(result.device)) {
          devices.add(result.device);
        }
      }
    });

    // Start scanning
    await FlutterBluePlus.startScan(timeout: const Duration(seconds: 5));

    // Wait for scan to complete
    await Future.delayed(const Duration(seconds: 5));

    // Stop scanning
    await FlutterBluePlus.stopScan();
    await scanSubscription?.cancel(); // Cancel subscription

    return devices;
  }

  // 🔗 Connect to a selected Bluetooth device
  Future<bool> connectToDevice(BluetoothDevice device) async {
    try {
      await device.connect();
      connectedDevice = device;

      // Discover services
      List<BluetoothService> services = await device.discoverServices();
      for (var service in services) {
        for (var characteristic in service.characteristics) {
          if (characteristic.uuid.toString() == "your-temperature-uuid") {
            temperatureCharacteristic = characteristic;
          }
          if (characteristic.uuid.toString() == "your-battery-uuid") {
            batteryCharacteristic = characteristic;
          }
        }
      }
      return true; // Connection successful
    } catch (e) {
      print("Error connecting: $e");
      return false;
    }
  }

  // 📶 Read temperature data
  Future<double?> readTemperature() async {
    if (temperatureCharacteristic == null) return null;
    List<int> data = await temperatureCharacteristic!.read();
    return data[0].toDouble(); // Convert byte data to double
  }

  // 🔋 Read battery level
  Future<int?> readBatteryLevel() async {
    if (batteryCharacteristic == null) return null;
    List<int> data = await batteryCharacteristic!.read();
    return data[0]; // Convert byte data to integer
  }

  // ✅ Check if the device is still connected
  Future<bool> isConnected() async {
    if (connectedDevice == null) return false;
    return connectedDevice!.isConnected;
  }

  // ❌ Disconnect from Bluetooth device
  Future<void> disconnectDevice() async {
    if (connectedDevice != null) {
      await connectedDevice!.disconnect();
      connectedDevice = null;
    }
  }
}
