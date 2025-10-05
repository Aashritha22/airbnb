import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class AdminChart extends StatelessWidget {
  const AdminChart({
    super.key,
    required this.title,
    required this.data,
    this.isRevenue = true,
    this.height = 200,
  });

  final String title;
  final List<Map<String, dynamic>> data;
  final bool isRevenue;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: height,
              child: data.isEmpty ? Center(
                child: Text(
                  'No data available',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 16,
                  ),
                ),
              ) : LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: true,
                    horizontalInterval: isRevenue ? 2000 : 20,
                    verticalInterval: 1,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: Colors.grey.shade300,
                        strokeWidth: 1,
                      );
                    },
                    getDrawingVerticalLine: (value) {
                      return FlLine(
                        color: Colors.grey.shade300,
                        strokeWidth: 1,
                      );
                    },
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        interval: 1,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          const style = TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          );
                          Widget text;
                          if (data.isNotEmpty && value.toInt() < data.length) {
                            text = Text(
                              data[value.toInt()]['month'],
                              style: style,
                            );
                          } else {
                            text = const Text('', style: style);
                          }
                          return SideTitleWidget(
                            axisSide: meta.axisSide,
                            child: text,
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: isRevenue ? 2000 : 20,
                        reservedSize: 42,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          const style = TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          );
                          return Text(
                            isRevenue ? '\$${value.toInt()}' : value.toInt().toString(),
                            style: style,
                          );
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  minX: 0,
                  maxX: data.isEmpty ? 0 : data.length.toDouble() - 1,
                  minY: 0,
                  maxY: data.isEmpty 
                    ? 100 
                    : (isRevenue 
                        ? data.map((e) => e['value'] as double).reduce((a, b) => a > b ? a : b) * 1.2
                        : data.map((e) => e['value'] as double).reduce((a, b) => a > b ? a : b) * 1.2),
                  lineBarsData: data.isEmpty ? [] : [
                    LineChartBarData(
                      spots: data.asMap().entries.map((entry) {
                        return FlSpot(entry.key.toDouble(), entry.value['value'] as double);
                      }).toList(),
                      isCurved: true,
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFFE31C5F),
                          const Color(0xFFE31C5F).withOpacity(0.5),
                        ],
                      ),
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) {
                          return FlDotCirclePainter(
                            radius: 4,
                            color: const Color(0xFFE31C5F),
                            strokeWidth: 2,
                            strokeColor: Colors.white,
                          );
                        },
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFFE31C5F).withOpacity(0.3),
                            const Color(0xFFE31C5F).withOpacity(0.1),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
