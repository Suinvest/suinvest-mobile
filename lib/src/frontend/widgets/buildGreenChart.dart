import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

Widget buildGreenChart() {
  return LineChart(
    LineChartData(
      gridData: FlGridData(show: false),
      titlesData: FlTitlesData(show: false),
      borderData: FlBorderData(show: false),
      minX: 0,
      maxX: 11, // Number of points along the x-axis
      minY: 0,
      maxY: 6, // The maximum range along the y-axis
      lineBarsData: [
        LineChartBarData(
          spots: [
            FlSpot(0, 3),
            FlSpot(2, 4),
            FlSpot(4, 1),
            FlSpot(6, 4),
            FlSpot(8, 3),
            FlSpot(10, 4),
            // You can add more spots here to represent your data
          ],
          isCurved: true, // Curved line
          colors: [Colors.green], // Line color
          barWidth: 4, // Line width
          isStrokeCapRound: true,
          dotData: FlDotData(show: false), // No dots on the graph
          belowBarData: BarAreaData(
            show: true,
            colors: [
              Colors.green.withOpacity(0.3)
            ], // Fill color below the line
          ),
        ),
      ],
    ),
    swapAnimationDuration: Duration(milliseconds: 250), // Optional
  );
}
