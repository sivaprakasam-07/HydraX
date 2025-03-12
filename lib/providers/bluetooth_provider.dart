import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BluetoothProvider extends ChangeNotifier {
  BluetoothDevice? connectedDevice;
  BluetoothCharacteristic? temperatureCharacteristic;
  BluetoothCharacteristic? batteryCharacteristic;
  bool isScanning = false;
  List<BluetoothDevice> scannedDevices = [];

  // 🔍 Start scanning for Bluetooth devices
  Future<void> startScan() async {
    if (isScanning) return;
    isScanning = true;
    scannedDevices.clear();
    notifyListeners();

    // ✅ Use FlutterBluePlus.scanResults (Static Access)
    FlutterBluePlus.scanResults.listen((results) {
      for (ScanResult result in results) {
        if (!scannedDevices.contains(result.device)) {
          scannedDevices.add(result.device);
          notifyListeners();
        }
      }
    });

    // ✅ Use FlutterBluePlus.startScan() (Static Access)
    await FlutterBluePlus.startScan(timeout: const Duration(seconds: 5));

    isScanning = false;
    notifyListeners();
  }

  // ⏹ Stop scanning (Fixed)
  Future<void> stopScan() async {
    await FlutterBluePlus.stopScan(); // ✅ Use FlutterBluePlus.stopScan()
    isScanning = false;
    notifyListeners();
  }

  // 🔗 Connect to a Bluetooth device
  Future<bool> connectToDevice(BluetoothDevice device) async {
    try {
      await device.connect();
      connectedDevice = device;
      notifyListeners();

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
      return true;
    } catch (e) {
      print("Connection error: $e");
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

  // ✅ Check if device is connected
  Future<bool> isConnected() async {
    if (connectedDevice == null) return false;
    return connectedDevice!.isConnected;
  }

  // ❌ Disconnect from Bluetooth device
  Future<void> disconnectDevice() async {
    if (connectedDevice != null) {
      await connectedDevice!.disconnect();
      connectedDevice = null;
      notifyListeners();
    }
  }
}
