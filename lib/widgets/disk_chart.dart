import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/server_resources.dart';

class DiskChart extends StatelessWidget {
  final List<DiskUsage> diskUsages;

  const DiskChart({
    super.key,
    required this.diskUsages,
  });

  @override
  Widget build(BuildContext context) {
    if (diskUsages.isEmpty) {
      return const Center(
        child: Text('Nessun dato disponibile'),
      );
    }

    return PieChart(
      PieChartData(
        sectionsSpace: 2,
        centerSpaceRadius: 40,
        sections: _getSections(),
        pieTouchData: PieTouchData(
          touchCallback: (FlTouchEvent event, pieTouchResponse) {},
        ),
      ),
    );
  }

  List<PieChartSectionData> _getSections() {
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.red,
      Colors.purple,
      Colors.teal,
      Colors.amber,
      Colors.indigo,
    ];

    return diskUsages.asMap().entries.map((entry) {
      final index = entry.key;
      final disk = entry.value;
      final color = colors[index % colors.length];

      return PieChartSectionData(
        color: color,
        value: disk.usagePercentage,
        title:
            '${disk.mountPoint}\n${disk.usagePercentage.toStringAsFixed(1)}%',
        radius: 80,
        titleStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          backgroundColor: color.withValues(alpha: 0.8),
        ),
        badgeWidget: Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            '${disk.usedSize.toStringAsFixed(1)} GB',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        badgePositionPercentageOffset: 1.1,
      );
    }).toList();
  }
}
