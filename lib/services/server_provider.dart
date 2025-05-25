import 'package:flutter/foundation.dart';
import 'ssh_service.dart';
import '../models/server_resources.dart';

class ServerProvider extends ChangeNotifier {
  final SSHService _sshService = SSHService();
  
  ServerResources? _currentResources;
  List<ServerResources> _resourceHistory = [];
  bool _isConnected = false;
  bool _isLoading = false;
  String? _errorMessage;
  
  // Getters
  ServerResources? get currentResources => _currentResources;
  List<ServerResources> get resourceHistory => _resourceHistory;
  bool get isConnected => _isConnected;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  
  // Limite di storia da mantenere (per i grafici)
  static const int _historyLimit = 8;
  
  Future<bool> connectToServer({
    required String hostname,
    required String username,
    required String password,
    int port = 22,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    
    try {
      final success = await _sshService.connect(
        hostname: hostname,
        username: username,
        password: password,
        port: port,
      );
      
      if (success) {
        _isConnected = true;
        // Carica immediatamente i dati
        await refreshData();
      } else {
        _errorMessage = _sshService.lastError ?? 'Impossibile connettersi al server';
      }
      
      _isLoading = false;
      notifyListeners();
      return success;
    } catch (e) {
      _errorMessage = 'Errore di connessione: $e';
      _isLoading = false;
      _isConnected = false;
      notifyListeners();
      return false;
    }
  }
  
  Future<void> disconnect() async {
    await _sshService.disconnect();
    _isConnected = false;
    _currentResources = null;
    _resourceHistory.clear();
    notifyListeners();
  }
  
  Future<void> refreshData() async {
    if (!_isConnected) return;
    
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    
    try {
      final resources = await _sshService.fetchServerResources();
      
      if (resources != null) {
        _currentResources = resources;
        
        // Aggiungi alla storia
        _resourceHistory.add(resources);
        
        // Mantieni solo gli ultimi N elementi
        if (_resourceHistory.length > _historyLimit) {
          _resourceHistory = _resourceHistory.sublist(
            _resourceHistory.length - _historyLimit,
          );
        }
      } else {
        _errorMessage = 'Impossibile recuperare i dati dal server';
      }
    } catch (e) {
      _errorMessage = 'Errore nel recupero dati: $e';
    }
    
    _isLoading = false;
    notifyListeners();
  }
  
  // Metodi helper per i grafici
  List<double> getCpuHistory() {
    return _resourceHistory.map((r) => r.cpuUsage).toList();
  }
  
  List<double> getRamHistory() {
    return _resourceHistory.map((r) => r.ramUsagePercentage).toList();
  }
  
  List<DateTime> getTimestamps() {
    return _resourceHistory.map((r) => r.timestamp).toList();
  }
}
