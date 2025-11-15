import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class CpuChart extends StatelessWidget {
  final List<double> cpuHistory;
  final List<DateTime> timestamps;

  const CpuChart({
    super.key,
    required this.cpuHistory,
    required this.timestamps,
  });

  @override
  Widget build(BuildContext context) {
    if (cpuHistory.isEmpty) {
      return const Center(
        child: Text('Nessun dato disponibile'),
      );
    }

    final int n = cpuHistory.length;
    final int smallCount = cpuHistory.where((v) => v.abs() <= 1.5).length;
    final bool likelyFraction = (smallCount / n) > 0.6;

    final scaledCpu = cpuHistory.map<double>((v) {
      var val = v;
      if (likelyFraction && val.abs() <= 1.5) val = val * 100.0;
      if (val.isNaN || val.isInfinite) val = 0.0;
      return val.clamp(0.0, 100.0);
    }).toList();

    final spots = scaledCpu.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value);
    }).toList();

    const int maxLabels = 6;
    final int labelInterval = (cpuHistory.length <= maxLabels)
        ? 1
        : (cpuHistory.length / maxLabels).ceil();

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          getDrawingHorizontalLine: (value) => FlLine(
            color: Colors.grey[300]!,
            strokeWidth: 1,
          ),
          getDrawingVerticalLine: (value) => FlLine(
            color: Colors.grey[300]!,
            strokeWidth: 1,
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              interval: labelInterval.toDouble(),
              getTitlesWidget: (value, meta) {
                final idx = value.toInt();
                if (idx < 0 || idx >= timestamps.length) return const SizedBox.shrink();
                if (idx % labelInterval != 0) return const SizedBox.shrink();

                final time = timestamps[idx];
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}',
                    style: const TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 10, // maggiore granularità per vedere piccoli valori
              reservedSize: 40,
              getTitlesWidget: (value, meta) => Text(
                '${value.toInt()}%',
                style: const TextStyle(fontSize: 10, color: Colors.grey),
              ),
            ),
          ),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: Colors.grey[300]!),
        ),
        minX: 0,
        maxX: (spots.length - 1).toDouble(),
        minY: 0,
        maxY: 100,
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: Colors.blue,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 3,
                  color: Colors.blue,
                  strokeWidth: 2,
                  strokeColor: Colors.white,
                );
              },
            ),
            belowBarData: BarAreaData(
              show: true,
              color: Colors.blue.withOpacity(0.15),
            ),
          ),
        ],
      ),
    );
  }
}