import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/server_provider.dart';
import 'dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _hostnameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _portController = TextEditingController(text: '22');
  
  bool _isPasswordVisible = false;
  
  @override
  void dispose() {
    _hostnameController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _portController.dispose();
    super.dispose();
  }
  
  Future<void> _connect() async {
    if (_formKey.currentState!.validate()) {
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
        // Show detailed error in a dialog for better debugging
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
                    provider.errorMessage ?? 'Errore sconosciuto',
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
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Center(
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
                      Icon(
                        Icons.monitor,
                        size: 64,
                        color: Theme.of(context).primaryColor,
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
                        'Connetti al tuo server via SSH',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 32),
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
      ),
    );
  }
}
