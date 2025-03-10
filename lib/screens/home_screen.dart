import 'package:flutter/material.dart';
import 'dart:math';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  double _waterLevel = 70.0; // Water level percentage
  double _currentTemperature = 25.0; // Default temperature

  late AnimationController _waveController;

  @override
  void initState() {
    super.initState();
    _waveController =
        AnimationController(vsync: this, duration: Duration(seconds: 2))
          ..repeat(reverse: true);
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'HydraX',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Stack(
              alignment: Alignment.center,
              children: [
                // Water Bottle Shape
                Container(
                  width: 120,
                  height: 300,
                  decoration: BoxDecoration(
                    color: Colors.blue[100],
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(color: Colors.blue, width: 4),
                  ),
                ),
                // Water Wave Animation
                ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: AnimatedBuilder(
                    animation: _waveController,
                    builder: (context, child) {
                      return CustomPaint(
                        painter: WaterPainter(
                            waveOffset: _waveController.value,
                            waterLevel: _waterLevel),
                        child: Container(
                          width: 120,
                          height: 300,
                        ),
                      );
                    },
                  ),
                ),
                // Water Level Text
                Text(
                  '${_waterLevel.toInt()}%',
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'Temperature: ${_currentTemperature.toStringAsFixed(1)}°C',
              style: TextStyle(fontSize: 20),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.remove, size: 30),
                  onPressed: _decreaseTemperature,
                ),
                IconButton(
                  icon: Icon(Icons.add, size: 30),
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

class WaterPainter extends CustomPainter {
  final double waveOffset;
  final double waterLevel;

  WaterPainter({required this.waveOffset, required this.waterLevel});

  @override
  void paint(Canvas canvas, Size size) {
    Paint wavePaint = Paint()
      ..color = Colors.blueAccent
      ..style = PaintingStyle.fill;

    double waterHeight = (1 - (waterLevel / 100)) * size.height;

    Path wavePath = Path();
    for (double i = 0; i <= size.width; i++) {
      double waveHeight = sin((i / size.width * 2 * pi) + (waveOffset * 2 * pi)) * 10;
      wavePath.lineTo(i, waterHeight + waveHeight);
    }
    wavePath.lineTo(size.width, size.height);
    wavePath.lineTo(0, size.height);
    wavePath.close();

    canvas.drawPath(wavePath, wavePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
