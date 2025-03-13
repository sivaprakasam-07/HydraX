import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class HydrationChart extends StatelessWidget {
  final List<double> hydrationData; // Example: Daily water intake in ml

  HydrationChart({this.hydrationData = const [500, 750, 1000, 800, 1200, 900, 1100]});

  @override
  Widget build(BuildContext context) {
    // ✅ Adjust text color based on theme
    Color textColor = Theme.of(context).brightness == Brightness.dark ? Colors.white70 : Colors.black87;
    Color borderColor = Theme.of(context).brightness == Brightness.dark ? Colors.white38 : Colors.black38;

    return Container(
      height: 250,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 5,
            spreadRadius: 2,
          ),
        ],
      ),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: false), // Hide grid lines
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  return Text('${value.toInt()} ml',
                      style: TextStyle(fontSize: 12, color: textColor)); // ✅ Dynamic Text Color
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  List<String> days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
                  return Text(days[value.toInt()],
                      style: TextStyle(fontSize: 12, color: textColor)); // ✅ Dynamic Text Color
                },
              ),
            ),
          ),
          borderData: FlBorderData(
            border: Border.all(color: borderColor), // ✅ Dynamic Border Color
          ),
          lineBarsData: [
            LineChartBarData(
              spots: List.generate(
                  hydrationData.length, (index) => FlSpot(index.toDouble(), hydrationData[index])),
              isCurved: true,
              color: Colors.blueAccent,
              dotData: FlDotData(show: false),
              belowBarData: BarAreaData(show: true, color: Colors.blueAccent.withOpacity(0.3)),
            ),
          ],
        ),
      ),
    );
  }
}
