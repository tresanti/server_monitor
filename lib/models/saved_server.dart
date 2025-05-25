class SavedServer {
  final String id;
  final String name;
  final String hostname;
  final String username;
  final String password;
  final int port;

  SavedServer({
    required this.id,
    required this.name,
    required this.hostname,
    required this.username,
    required this.password,
    required this.port,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'hostname': hostname,
      'username': username,
      'password': password,
      'port': port,
    };
  }

  factory SavedServer.fromJson(Map<String, dynamic> json) {
    return SavedServer(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      hostname: json['hostname'] ?? '',
      username: json['username'] ?? '',
      password: json['password'] ?? '',
      port: json['port'] ?? 22,
    );
  }

  SavedServer copyWith({
    String? id,
    String? name,
    String? hostname,
    String? username,
    String? password,
    int? port,
  }) {
    return SavedServer(
      id: id ?? this.id,
      name: name ?? this.name,
      hostname: hostname ?? this.hostname,
      username: username ?? this.username,
      password: password ?? this.password,
      port: port ?? this.port,
    );
  }
}
