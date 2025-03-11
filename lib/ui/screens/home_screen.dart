import 'package:flutter/material.dart';
import '../widgets/battery_status.dart';
import 'dart:math';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  double _batteryLevel = 75.0; // Placeholder battery level
  double _currentTemperature = 25.0; // Default temperature
  late AnimationController _waveController;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Set background to black
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
            Stack(
              alignment: Alignment.center,
              children: [
                // Battery Shape (Bottle shape)
                Container(
                  width: 120,
                  height: 300,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(
                      color: _batteryLevel < 20 ? Colors.redAccent : Colors.greenAccent,
                      width: 4,
                    ),
                  ),
                ),
                // Animated Battery Level (Wave)
                ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: AnimatedBuilder(
                    animation: _waveController,
                    builder: (context, child) {
                      return CustomPaint(
                        painter: BatteryPainter(
                          waveOffset: _waveController.value,
                          batteryLevel: _batteryLevel,
                        ),
                        child: Container(
                          width: 120,
                          height: 300,
                        ),
                      );
                    },
                  ),
                ),
                // Battery Percentage Text
                Text(
                  '${_batteryLevel.toInt()}%',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            // Temperature Display
            Text(
              'Temperature: ${_currentTemperature.toStringAsFixed(1)}°C',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            SizedBox(height: 10),
            // Temperature Control Buttons
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
    );
  }
}

// Battery Wave Animation Painter
class BatteryPainter extends CustomPainter {
  final double waveOffset;
  final double batteryLevel;

  BatteryPainter({required this.waveOffset, required this.batteryLevel});

  @override
  void paint(Canvas canvas, Size size) {
    // Change wave color based on battery level
    Color waveColor = batteryLevel < 20 ? Colors.redAccent : Colors.greenAccent;

    Paint wavePaint = Paint()
      ..color = waveColor
      ..style = PaintingStyle.fill;

    double batteryHeight = (1 - (batteryLevel / 100)) * size.height;

    Path wavePath = Path();
    for (double i = 0; i <= size.width; i++) {
      double waveHeight = sin((i / size.width * 2 * pi) + (waveOffset * 2 * pi)) * 10;
      wavePath.lineTo(i, batteryHeight + waveHeight);
    }
    wavePath.lineTo(size.width, size.height);
    wavePath.lineTo(0, size.height);
    wavePath.close();

    canvas.drawPath(wavePath, wavePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
