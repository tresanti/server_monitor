import 'dart:async';
import 'dart:convert';
import 'package:dartssh2/dartssh2.dart';
import '../models/server_resources.dart';

class SSHService {
  SSHClient? _client;
  int _port = 22;
  String? _lastError;

  String? get lastError => _lastError;

  Future<bool> connect({
    required String hostname,
    required String username,
    required String password,
    int port = 22,
  }) async {
    try {
      _lastError = null;
      _port = port;
      
      // ignore: avoid_print
      print('SSH: Attempting to connect to $hostname:$_port as $username');
      
      // Add timeout for connection
      final socket = await SSHSocket.connect(
        hostname, 
        _port,
        timeout: const Duration(seconds: 5),
      );
      
      // ignore: avoid_print
      print('SSH: Socket connected successfully');
      
      _client = SSHClient(
        socket,
        username: username,
        onPasswordRequest: () {
          // ignore: avoid_print
          print('SSH: Password requested for authentication');
          return password;
        },
      );

      // Actually authenticate with the server
      await _client!.authenticated;
      
      // ignore: avoid_print
      print('SSH: Authentication successful');

      return true;
    } catch (e, stackTrace) {
      _lastError = e.toString();
      // ignore: avoid_print
      print('SSH Connection Error: $e');
      // ignore: avoid_print
      print('Stack trace: $stackTrace');
      
      // Close socket if connection failed
      _client?.close();
      _client = null;
      
      return false;
    }
  }

  Future<void> disconnect() async {
    _client?.close();
    _client = null;
  }

  Future<ServerResources?> fetchServerResources() async {
    if (_client == null) {
      throw Exception('Client SSH non connesso');
    }

    try {
      // Esegui comandi in parallelo per maggiore efficienza
      final results = await Future.wait([
        _executeCommand('free -m'),
        _executeCommand('df -h'),
        _executeCommand('cat /proc/loadavg'),
        _executeCommand('top -b -n 1 | grep "Cpu(s)"'),
      ]);

      final ramData = _parseMemoryInfo(results[0]);
      final diskData = _parseDiskInfo(results[1]);
      final loadAvg = _parseLoadAverage(results[2]);
      final cpuUsage = _parseCpuUsage(results[3]);

      return ServerResources(
        cpuUsage: cpuUsage,
        ramUsage: ramData['used']! / ramData['total']! * 100,
        ramTotal: ramData['total']!,
        ramUsed: ramData['used']!,
        diskUsages: diskData,
        loadAvg1: loadAvg[0],
        loadAvg5: loadAvg[1],
        loadAvg15: loadAvg[2],
        timestamp: DateTime.now(),
      );
    } catch (e) {
      
      return null;
    }
  }

  Future<String> _executeCommand(String command) async {
    final session = await _client!.execute(command);
  
    final output = await utf8.decodeStream(session.stdout);
     // ignore: avoid_print
    print('Executing command: $output');
    session.close();
    return output;
  }

  Map<String, double> _parseMemoryInfo(String output) {
    final lines = output.split('\n');
    Map<String, double> result = {'total': 0, 'used': 0};

    for (final line in lines) {
      if (line.startsWith('Mem:')) {
        final parts = line.split(RegExp(r'\s+'));
        if (parts.length >= 4) {
          result['total'] = double.tryParse(parts[1]) ?? 0;
          result['used'] = double.tryParse(parts[2]) ?? 0;
        }
        break;
      }
    }

    return result;
  }

  List<DiskUsage> _parseDiskInfo(String output) {
    final lines = output.split('\n');
    final diskUsages = <DiskUsage>[];

    for (int i = 1; i < lines.length; i++) {
      final line = lines[i].trim();
      if (line.isEmpty) continue;

      final parts = line.split(RegExp(r'\s+'));
      if (parts.length >= 6) {
        // Filtra solo i filesystem reali (esclude tmpfs, devtmpfs, etc.)
        if (!parts[0].contains('tmpfs') && 
            !parts[0].contains('devtmpfs') && 
            !parts[0].contains('udev')) {
          
          final filesystem = parts[0];
          final totalStr = parts[1];
          final usedStr = parts[2];
          final availStr = parts[3];
          final percentStr = parts[4].replaceAll('%', '');
          final mountPoint = parts[5];

          diskUsages.add(DiskUsage(
            filesystem: filesystem,
            mountPoint: mountPoint,
            totalSize: _parseSize(totalStr),
            usedSize: _parseSize(usedStr),
            availableSize: _parseSize(availStr),
            usagePercentage: double.tryParse(percentStr) ?? 0,
          ));
        }
      }
    }

    return diskUsages;
  }

  double _parseSize(String sizeStr) {
    sizeStr = sizeStr.replaceAll(',', '.').trim();
    final regex = RegExp(r'(\d+\.?\d*)([KMGT]?)');
    final match = regex.firstMatch(sizeStr);
    
    if (match != null) {
      final value = double.parse(match.group(1)!);
      final unit = match.group(2) ?? '';
      // ignore: avoid_print
          print('size: $value $unit');
      switch (unit) {
        case 'K':
          return value / 1024; // Converti in GB
        case 'M':
          return value / 1024; // Converti in GB
        case 'G':
          return value;
        case 'T':
          // ignore: avoid_print
          print('size: $value T e in GB: ${value * 1024}');
          return value * 1024; // Converti in GB
        default:
          return value / (1024 * 1024 * 1024); // Assumo byte, converti in GB
      }
    }
    
    return 0;
  }

  List<double> _parseLoadAverage(String output) {
    final parts = output.trim().split(' ');
    if (parts.length >= 3) {
      return [
        double.tryParse(parts[0]) ?? 0,
        double.tryParse(parts[1]) ?? 0,
        double.tryParse(parts[2]) ?? 0,
      ];
    }
    return [0, 0, 0];
  }

  double _parseCpuUsage(String output) {
    // Esempio di output: Cpu(s): 0.3%us, 0.2%sy, 0.0%ni, 99.4%id, 0.0%wa, 0.0%hi, 0.0%si, 0.0%st
    final regex = RegExp(r'(\d+\.?\d*)%id');
    final match = regex.firstMatch(output);
    
    if (match != null) {
      final idle = double.parse(match.group(1)!);
      return 100 - idle; // CPU usage = 100 - idle%
    }
    
    return 0;
  }
}
