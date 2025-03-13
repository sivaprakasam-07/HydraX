import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class HydrationChart extends StatelessWidget {
  final List<double> hydrationData; // Example: Daily water intake in ml

  HydrationChart({this.hydrationData = const [500, 750, 1000, 800, 1200, 900, 1100]});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      height: 250,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            spreadRadius: 2,
          ),
        ],
      ),
      child: LineChart(
        LineChartData(
          backgroundColor: theme.scaffoldBackgroundColor,
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            getDrawingHorizontalLine: (value) => FlLine(
              color: Colors.grey.withOpacity(0.3),
              strokeWidth: 1,
            ),
          ),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  return Text(
                    '${value.toInt()} ml',
                    style: TextStyle(fontSize: 12, color: theme.textTheme.bodyMedium?.color),
                  );
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                getTitlesWidget: (value, meta) {
                  List<String> days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
                  if (value.toInt() >= 0 && value.toInt() < days.length) {
                    return Text(
                      days[value.toInt()],
                      style: TextStyle(fontSize: 12, color: theme.textTheme.bodyMedium?.color),
                    );
                  }
                  return SizedBox();
                },
              ),
            ),
          ),
          borderData: FlBorderData(
            border: Border.all(color: Colors.grey.withOpacity(0.5)),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: List.generate(
                hydrationData.length,
                (index) => FlSpot(index.toDouble(), hydrationData[index]),
              ),
              isCurved: true,
              color: Colors.blueAccent,
              barWidth: 3,
              isStrokeCapRound: true,
              belowBarData: BarAreaData(
                show: true,
                color: Colors.blueAccent.withOpacity(0.3),
                gradient: LinearGradient(
                  colors: [
                    Colors.blueAccent.withOpacity(0.3),
                    Colors.transparent,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              dotData: FlDotData(show: false),
            ),
          ],
        ),
      ),
    );
  }
}
