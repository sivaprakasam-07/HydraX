import 'dart:async';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class MyBluetoothService {
  final FlutterBluePlus flutterBlue = FlutterBluePlus();
  BluetoothDevice? connectedDevice;
  BluetoothCharacteristic? temperatureCharacteristic;
  BluetoothCharacteristic? batteryCharacteristic;

  /// 🔍 **Scan for Bluetooth devices**
  Future<List<BluetoothDevice>> scanForDevices() async {
    List<BluetoothDevice> devices = [];

    // Clear previous results
    List<BluetoothDevice> connectedDevices = FlutterBluePlus.connectedDevices;
    devices.addAll(connectedDevices);

    // Listen to scan results
    StreamSubscription? scanSubscription;
    scanSubscription = FlutterBluePlus.scanResults.listen((results) {
      for (ScanResult result in results) {
        if (!devices.any((d) => d.id == result.device.id)) {
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
    await scanSubscription.cancel(); // Cancel subscription

    return devices;
  }

  /// 🔗 **Connect to a Bluetooth device**
  Future<bool> connectToDevice(BluetoothDevice device) async {
    if (connectedDevice != null && connectedDevice!.id == device.id) {
      print("Already connected to ${device.name}");
      return true;
    }

    try {
      await device.connect();
      connectedDevice = device;

      // Discover services and characteristics
      await _discoverCharacteristics(device);
      return true; // Connection successful
    } catch (e) {
      print("Error connecting: $e");
      return false;
    }
  }

  /// 📡 **Discover services & characteristics**
  Future<void> _discoverCharacteristics(BluetoothDevice device) async {
    List<BluetoothService> services = await device.discoverServices();
    for (var service in services) {
      for (var characteristic in service.characteristics) {
        if (characteristic.uuid.toString().toLowerCase() == "your-temperature-uuid") {
          temperatureCharacteristic = characteristic;
        } else if (characteristic.uuid.toString().toLowerCase() == "your-battery-uuid") {
          batteryCharacteristic = characteristic;
        }
      }
    }
  }

  /// 🌡️ **Read temperature data**
  Future<double?> readTemperature() async {
    if (temperatureCharacteristic == null) return null;
    List<int> data = await temperatureCharacteristic!.read();
    return data.isNotEmpty ? data[0].toDouble() : null; // Convert byte to double
  }

  /// 🔋 **Read battery level**
  Future<int?> readBatteryLevel() async {
    if (batteryCharacteristic == null) return null;
    List<int> data = await batteryCharacteristic!.read();
    return data.isNotEmpty ? data[0] : null; // Convert byte to integer
  }

  /// ✅ **Check if Bluetooth is connected**
  Future<bool> isConnected() async {
    if (connectedDevice == null) return false;
    return connectedDevice!.isConnected;
  }

  /// ❌ **Disconnect from Bluetooth device**
  Future<void> disconnectDevice() async {
    if (connectedDevice != null) {
      await connectedDevice!.disconnect();
      connectedDevice = null;
    }
  }

  Future<void> disconnect() async {
    if (connectedDevice != null) {
      await connectedDevice!.disconnect();
      connectedDevice = null;
    }
  }

  Future<bool> scanAndConnect() async {
    List<BluetoothDevice> devices = await scanForDevices();
    if (devices.isNotEmpty) {
      return await connectToDevice(devices.first);
    }
    return false;
  }

  Future<List<BluetoothDevice>> get connectedDevices async {
    return FlutterBluePlus.connectedDevices;
  }
}
