// import 'package:flutter/material.dart';

// class WaterBottle extends StatelessWidget {
//   final double fillPercentage; // Water fill level (0 to 1)

//   WaterBottle({required this.fillPercentage});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         // 💧 Water Level Text
//         Text(
//           "${(fillPercentage * 5).toStringAsFixed(1)} L",
//           style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//         ),
//         SizedBox(height: 5),
        
//         // 🍼 Water Bottle Container
//         Container(
//           width: 80,
//           height: 200,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(10),
//             border: Border.all(color: Colors.blue, width: 2),
//           ),
//           child: Stack(
//             alignment: Alignment.bottomCenter,
//             children: [
//               // Water fill level
//               Container(
//                 width: double.infinity,
//                 height: 200 * fillPercentage, // Adjust height based on intake
//                 decoration: BoxDecoration(
//                   color: Colors.blue.withOpacity(0.6),
//                   borderRadius: BorderRadius.vertical(
//                     bottom: Radius.circular(10),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'dart:math';

class WaterBottle extends StatefulWidget {
  final double fillPercentage; // Water fill level (0 to 1)

  WaterBottle({required this.fillPercentage});

  @override
  _WaterBottleState createState() => _WaterBottleState();
}

class _WaterBottleState extends State<WaterBottle> with SingleTickerProviderStateMixin {
  late AnimationController _waveController;

  @override
  void initState() {
    super.initState();

    // 🌊 Wave Animation Controller
    _waveController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    )..repeat(); // Loops continuously
  }

  @override
  void dispose() {
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double bottleHeight = 280; // Increased bottle height

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 💧 Water Level Text
          Text(
            "${(widget.fillPercentage * 5).toStringAsFixed(1)} L",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.blue[800],
            ),
          ),
          SizedBox(height: 15),

          // 🍼 Water Bottle Container
          Container(
            width: 120, // Increased bottle width
            height: bottleHeight, // Increased bottle height
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.blue.shade700, width: 4),
              color: Colors.transparent, // ✅ No static background
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 8,
                  offset: Offset(3, 5),
                ),
              ],
            ),
            child: AnimatedBuilder(
              animation: _waveController,
              builder: (context, child) {
                return ClipPath(
                  clipper: WaterClipper(widget.fillPercentage, _waveController.value),
                  child: Container(
                    width: double.infinity,
                    height: bottleHeight,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.blue.withOpacity(0.5),
                          Colors.blueAccent,
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// 🌊 Custom Wave Clipper for Realistic Floating Water
class WaterClipper extends CustomClipper<Path> {
  final double fillPercentage;
  final double waveValue;

  WaterClipper(this.fillPercentage, this.waveValue);

  @override
  Path getClip(Size size) {
    Path path = Path();
    double waveHeight = 10.0; // Wave peak height
    double waveWidth = size.width / 1.5; // Wave frequency
    double waterLevel = size.height * (1 - fillPercentage); // Calculate water height

    path.moveTo(0, waterLevel);

    for (double i = 0; i < size.width; i += waveWidth) {
      path.quadraticBezierTo(
        i + waveWidth / 4,
        waterLevel - sin((i + waveValue * size.width) * pi / waveWidth) * waveHeight,
        i + waveWidth / 2,
        waterLevel,
      );
    }

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(WaterClipper oldClipper) => true;
}
