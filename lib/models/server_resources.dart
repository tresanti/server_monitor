class ServerResources {
  final double cpuUsage;
  final double ramUsage;
  final double ramTotal;
  final double ramUsed;
  final List<DiskUsage> diskUsages;
  final double loadAvg1;
  final double loadAvg5;
  final double loadAvg15;
  final DateTime timestamp;

  ServerResources({
    required this.cpuUsage,
    required this.ramUsage,
    required this.ramTotal,
    required this.ramUsed,
    required this.diskUsages,
    required this.loadAvg1,
    required this.loadAvg5,
    required this.loadAvg15,
    required this.timestamp,
  });

  double get ramFree => ramTotal - ramUsed;
  double get ramUsagePercentage => (ramUsed / ramTotal) * 100;
}

class DiskUsage {
  final String filesystem;
  final String mountPoint;
  final double totalSize;
  final double usedSize;
  final double availableSize;
  final double usagePercentage;

  DiskUsage({
    required this.filesystem,
    required this.mountPoint,
    required this.totalSize,
    required this.usedSize,
    required this.availableSize,
    required this.usagePercentage,
  });
}
