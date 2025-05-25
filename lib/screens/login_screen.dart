import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/server_provider.dart';
import '../services/saved_servers_service.dart';
import '../models/saved_server.dart';
import 'dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
  
  void _navigateToPage(int page) {
    _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Consumer<SavedServersService>(
        builder: (context, savedServersService, _) {
          final servers = savedServersService.servers;
          final totalPages = servers.length + 1; // +1 per la pagina "aggiungi nuovo"
          
          return Stack(
            children: [
              PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: totalPages,
                itemBuilder: (context, index) {
                  if (index == servers.length) {
                    // Pagina per aggiungere un nuovo server
                    return _AddNewServerPage(
                      onServerAdded: (server) {
                        savedServersService.addOrUpdateServer(server);
                        // Vai alla pagina del server appena aggiunto
                        _pageController.animateToPage(
                          servers.length - 1,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                    );
                  } else {
                    // Pagina per un server esistente
                    return _ServerLoginPage(
                      server: servers[index],
                      onServerUpdated: (updatedServer) {
                        savedServersService.addOrUpdateServer(updatedServer);
                      },
                      onServerDeleted: () {
                        savedServersService.deleteServer(servers[index].id);
                        if (_currentPage > 0) {
                          _pageController.previousPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        }
                      },
                    );
                  }
                },
              ),
              // Freccia sinistra
              if (_currentPage > 0)
                Positioned(
                  left: 20,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back_ios, size: 20),
                        onPressed: () => _navigateToPage(_currentPage - 1),
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ),
              // Freccia destra
              if (_currentPage < totalPages - 1)
                Positioned(
                  right: 20,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha:0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_forward_ios, size: 20),
                        onPressed: () => _navigateToPage(_currentPage + 1),
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ),
              // Indicatore di pagina con testo
              if (totalPages > 1)
                Positioned(
                  bottom: 20,
                  left: 0,
                  right: 0,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (_currentPage == servers.length)
                        Text(
                          'Scorri per vedere i server salvati',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        )
                      else
                        Text(
                          '${_currentPage + 1} di ${servers.length} server',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          totalPages,
                          (index) => GestureDetector(
                            onTap: () => _navigateToPage(index),
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              width: index == _currentPage ? 24 : 8,
                              height: 8,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: _currentPage == index
                                    ? Theme.of(context).primaryColor
                                    : Colors.grey[400],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _ServerLoginPage extends StatefulWidget {
  final SavedServer server;
  final Function(SavedServer) onServerUpdated;
  final VoidCallback onServerDeleted;

  const _ServerLoginPage({
    required this.server,
    required this.onServerUpdated,
    required this.onServerDeleted,
  });

  @override
  State<_ServerLoginPage> createState() => _ServerLoginPageState();
}

class _ServerLoginPageState extends State<_ServerLoginPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _hostnameController;
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;
  late TextEditingController _portController;
  
  bool _isPasswordVisible = false;
  bool _hasChanges = false;
  
  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.server.name);
    _hostnameController = TextEditingController(text: widget.server.hostname);
    _usernameController = TextEditingController(text: widget.server.username);
    _passwordController = TextEditingController(text: widget.server.password);
    _portController = TextEditingController(text: widget.server.port.toString());
    
    // Aggiungi listener per rilevare le modifiche
    _nameController.addListener(_onFieldChanged);
    _hostnameController.addListener(_onFieldChanged);
    _usernameController.addListener(_onFieldChanged);
    _passwordController.addListener(_onFieldChanged);
    _portController.addListener(_onFieldChanged);
  }
  
  void _onFieldChanged() {
    final hasChanges = _nameController.text != widget.server.name ||
        _hostnameController.text != widget.server.hostname ||
        _usernameController.text != widget.server.username ||
        _passwordController.text != widget.server.password ||
        _portController.text != widget.server.port.toString();
    
    if (hasChanges != _hasChanges) {
      setState(() {
        _hasChanges = hasChanges;
      });
    }
  }
  
  @override
  void dispose() {
    _nameController.dispose();
    _hostnameController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _portController.dispose();
    super.dispose();
  }
  
  Future<void> _connect() async {
    if (_formKey.currentState!.validate()) {
      // Se ci sono modifiche, salva il server aggiornato
      if (_hasChanges) {
        final updatedServer = widget.server.copyWith(
          name: _nameController.text.trim(),
          hostname: _hostnameController.text.trim(),
          username: _usernameController.text.trim(),
          password: _passwordController.text,
          port: int.tryParse(_portController.text) ?? 22,
        );
        widget.onServerUpdated(updatedServer);
      }
      
      final provider = Provider.of<ServerProvider>(context, listen: false);
      
      final success = await provider.connectToServer(
        hostname: _hostnameController.text.trim(),
        username: _usernameController.text.trim(),
        password: _passwordController.text,
        port: int.tryParse(_portController.text) ?? 22,
      );
      
      if (success && mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const DashboardScreen()),
        );
      } else if (mounted) {
        _showErrorDialog(provider.errorMessage);
      }
    }
  }
  
  void _showErrorDialog(String? errorMessage) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Errore di connessione'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Dettagli dell\'errore:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                errorMessage ?? 'Errore sconosciuto',
                style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
              ),
              const SizedBox(height: 16),
              const Text(
                'Verifica:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              const Text('• L\'hostname/IP è corretto'),
              const Text('• La porta SSH è corretta (default: 22)'),
              const Text('• Username e password sono corretti'),
              const Text('• Il server SSH è attivo e raggiungibile'),
              const Text('• Il firewall permette la connessione'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
  
  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Elimina server'),
        content: Text('Vuoi eliminare il server "${widget.server.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annulla'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              widget.onServerDeleted();
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Elimina'),
          ),
        ],
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(width: 40),
                        Icon(
                          Icons.monitor,
                          size: 64,
                          color: Theme.of(context).primaryColor,
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline),
                          color: Colors.red,
                          onPressed: _confirmDelete,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Server Monitor',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Connetti al server',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 32),
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Nome server',
                        prefixIcon: Icon(Icons.label),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Inserisci un nome per il server';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _hostnameController,
                      decoration: const InputDecoration(
                        labelText: 'Hostname/IP',
                        prefixIcon: Icon(Icons.dns),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Inserisci l\'hostname o l\'IP';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _usernameController,
                      decoration: const InputDecoration(
                        labelText: 'Username',
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Inserisci l\'username';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: !_isPasswordVisible,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: const Icon(Icons.lock),
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible 
                              ? Icons.visibility_off 
                              : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Inserisci la password';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _portController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Porta SSH (default: 22)',
                        prefixIcon: Icon(Icons.settings_ethernet),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value != null && value.isNotEmpty) {
                          final port = int.tryParse(value);
                          if (port == null || port < 1 || port > 65535) {
                            return 'Porta non valida';
                          }
                        }
                        return null;
                      },
                    ),
                    if (_hasChanges) ...[
                      const SizedBox(height: 16),
                      Text(
                        'Le modifiche verranno salvate automaticamente',
                        style: TextStyle(
                          color: Colors.orange[700],
                          fontSize: 12,
                        ),
                      ),
                    ],
                    const SizedBox(height: 32),
                    Consumer<ServerProvider>(
                      builder: (context, provider, _) {
                        return SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton.icon(
                            onPressed: provider.isLoading ? null : _connect,
                            icon: provider.isLoading 
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                              : const Icon(Icons.login),
                            label: Text(
                              provider.isLoading 
                                ? 'Connessione in corso...' 
                                : 'Connetti',
                            ),
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AddNewServerPage extends StatefulWidget {
  final Function(SavedServer) onServerAdded;

  const _AddNewServerPage({
    required this.onServerAdded,
  });

  @override
  State<_AddNewServerPage> createState() => _AddNewServerPageState();
}

class _AddNewServerPageState extends State<_AddNewServerPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _hostnameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _portController = TextEditingController(text: '22');
  
  bool _isPasswordVisible = false;
  
  @override
  void dispose() {
    _nameController.dispose();
    _hostnameController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _portController.dispose();
    super.dispose();
  }
  
  void _addServer() {
    if (_formKey.currentState!.validate()) {
      final savedServersService = Provider.of<SavedServersService>(context, listen: false);
      final newServer = SavedServer(
        id: savedServersService.generateServerId(),
        name: _nameController.text.trim(),
        hostname: _hostnameController.text.trim(),
        username: _usernameController.text.trim(),
        password: _passwordController.text,
        port: int.tryParse(_portController.text) ?? 22,
      );
      
      widget.onServerAdded(newServer);
      
      // Pulisci i campi
      _nameController.clear();
      _hostnameController.clear();
      _usernameController.clear();
      _passwordController.clear();
      _portController.text = '22';
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(32),
                      ),
                      child: Icon(
                        Icons.add,
                        size: 32,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Aggiungi nuovo server',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Inserisci le informazioni del server',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 32),
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Nome server',
                        prefixIcon: Icon(Icons.label),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Inserisci un nome per il server';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _hostnameController,
                      decoration: const InputDecoration(
                        labelText: 'Hostname/IP',
                        prefixIcon: Icon(Icons.dns),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Inserisci l\'hostname o l\'IP';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _usernameController,
                      decoration: const InputDecoration(
                        labelText: 'Username',
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Inserisci l\'username';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: !_isPasswordVisible,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: const Icon(Icons.lock),
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible 
                              ? Icons.visibility_off 
                              : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Inserisci la password';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _portController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Porta SSH (default: 22)',
                        prefixIcon: Icon(Icons.settings_ethernet),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value != null && value.isNotEmpty) {
                          final port = int.tryParse(value);
                          if (port == null || port < 1 || port > 65535) {
                            return 'Porta non valida';
                          }
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton.icon(
                        onPressed: _addServer,
                        icon: const Icon(Icons.save),
                        label: const Text('Salva server'),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
