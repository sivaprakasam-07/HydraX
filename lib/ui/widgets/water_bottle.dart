// import 'package:flutter/material.dart';

// class WaterBottle extends StatelessWidget {
//   final double fillPercentage; // Water fill level (0 to 1)

//   WaterBottle({required this.fillPercentage});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 80,
//       height: 200,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(10),
//         border: Border.all(color: Colors.blue, width: 2),
//       ),
//       child: Stack(
//         alignment: Alignment.bottomCenter,
//         children: [
//           Container(
//             width: double.infinity,
//             height: 200 * fillPercentage, // Adjust height based on intake
//             decoration: BoxDecoration(
//               color: Colors.blue.withOpacity(0.6),
//               borderRadius: BorderRadius.circular(10),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';

class WaterBottle extends StatelessWidget {
  final double fillPercentage; // Water fill level (0 to 1)

  WaterBottle({required this.fillPercentage});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 💧 Water Level Text
        Text(
          "${(fillPercentage * 5).toStringAsFixed(1)} L",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 5),
        
        // 🍼 Water Bottle Container
        Container(
          width: 80,
          height: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.blue, width: 2),
          ),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              // Water fill level
              Container(
                width: double.infinity,
                height: 200 * fillPercentage, // Adjust height based on intake
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.6),
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
