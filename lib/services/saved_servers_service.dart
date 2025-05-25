import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/saved_server.dart';

class SavedServersService extends ChangeNotifier {
  static const String _serversKey = 'saved_servers';
  List<SavedServer> _servers = [];
  
  List<SavedServer> get servers => _servers;

  SavedServersService() {
    loadServers();
  }

  Future<void> loadServers() async {
    final prefs = await SharedPreferences.getInstance();
    final serversJson = prefs.getString(_serversKey);
    
    if (serversJson != null) {
      final List<dynamic> serversList = json.decode(serversJson);
      _servers = serversList.map((json) => SavedServer.fromJson(json)).toList();
      notifyListeners();
    }
  }

  Future<void> saveServers() async {
    final prefs = await SharedPreferences.getInstance();
    final serversJson = json.encode(_servers.map((s) => s.toJson()).toList());
    await prefs.setString(_serversKey, serversJson);
  }

  Future<void> addOrUpdateServer(SavedServer server) async {
    final existingIndex = _servers.indexWhere((s) => s.id == server.id);
    
    if (existingIndex != -1) {
      _servers[existingIndex] = server;
    } else {
      _servers.add(server);
    }
    
    await saveServers();
    notifyListeners();
  }

  Future<void> deleteServer(String serverId) async {
    _servers.removeWhere((s) => s.id == serverId);
    await saveServers();
    notifyListeners();
  }

  SavedServer? getServerById(String id) {
    try {
      return _servers.firstWhere((s) => s.id == id);
    } catch (e) {
      return null;
    }
  }

  String generateServerId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }
}
