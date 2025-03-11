import 'package:flutter/material.dart';
import 'dart:math';

class BatteryStatus extends StatefulWidget {
  final double batteryLevel;
  final bool isCharging;
  final AnimationController waveController;

  BatteryStatus({
    required this.batteryLevel,
    required this.isCharging,
    required this.waveController,
  });

  @override
  _BatteryStatusState createState() => _BatteryStatusState();
}

class _BatteryStatusState extends State<BatteryStatus>
    with SingleTickerProviderStateMixin {
  late AnimationController _blinkController;
  late Animation<double> _blinkAnimation;

  @override
  void initState() {
    super.initState();
    _blinkController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );

    _blinkAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(_blinkController);

    if (widget.isCharging) {
      _blinkController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(covariant BatteryStatus oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (widget.isCharging && !_blinkController.isAnimating) {
      _blinkController.repeat(reverse: true);
    } else if (!widget.isCharging && _blinkController.isAnimating) {
      _blinkController.stop();
      _blinkController.value = 1.0;
    }
  }

  @override
  void dispose() {
    _blinkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 120,
          height: 300,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(50),
            border: Border.all(
              color: _getBorderColor(),
              width: 4,
            ),
          ),
        ),

        ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: AnimatedBuilder(
            animation: widget.waveController,
            builder: (context, child) {
              return AnimatedOpacity(
                opacity: widget.isCharging ? _blinkAnimation.value : 1.0,
                duration: Duration(milliseconds: 500),
                child: CustomPaint(
                  painter: BatteryPainter(
                    waveOffset: widget.waveController.value,
                    batteryLevel: widget.batteryLevel,
                    isCharging: widget.isCharging,
                  ),
                  child: Container(
                    width: 120,
                    height: 300,
                  ),
                ),
              );
            },
          ),
        ),

        Text(
          '${widget.batteryLevel.toInt()}%',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),

        if (widget.isCharging)
          Positioned(
            top: 10,
            child: AnimatedBuilder(
              animation: _blinkAnimation,
              builder: (context, child) {
                return Opacity(
                  opacity: _blinkAnimation.value,
                  child: Icon(
                    Icons.bolt,
                    color: Colors.yellowAccent,
                    size: 30,
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  Color _getBorderColor() {
    if (widget.isCharging) return Colors.blueAccent;
    return widget.batteryLevel < 20 ? Colors.redAccent : Colors.greenAccent;
  }
}

class BatteryPainter extends CustomPainter {
  final double waveOffset;
  final double batteryLevel;
  final bool isCharging;

  BatteryPainter({required this.waveOffset, required this.batteryLevel, required this.isCharging});

  @override
  void paint(Canvas canvas, Size size) {
    Color waveColor = isCharging ? Colors.blueAccent : (batteryLevel < 20 ? Colors.redAccent : Colors.greenAccent);

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
