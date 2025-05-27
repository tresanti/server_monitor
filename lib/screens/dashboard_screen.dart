import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../gen_l10n/app_localizations.dart';
import '../services/server_provider.dart';
import '../widgets/cpu_chart.dart';
import '../widgets/ram_chart.dart';
import '../widgets/disk_chart.dart';
import '../widgets/resource_card.dart';
import 'login_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    // Avvia refresh automatico ogni 10 secondi
    _startAutoRefresh();
  }

  void _startAutoRefresh() {
    Future.delayed(const Duration(seconds: 10), () {
      if (mounted) {
        final provider = Provider.of<ServerProvider>(context, listen: false);
        if (provider.isConnected) {
          provider.refreshData();
          _startAutoRefresh();
        }
      }
    });
  }

  Future<void> _disconnect() async {
    final provider = Provider.of<ServerProvider>(context, listen: false);
    await provider.disconnect();
    
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _disconnect,
            tooltip: l10n.disconnect,
          ),
        ],
      ),
      body: Consumer<ServerProvider>(
        builder: (context, provider, _) {
          if (provider.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.error,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    provider.errorMessage!,
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: provider.refreshData,
                    icon: const Icon(Icons.refresh),
                    label: Text(l10n.retry),
                  ),
                ],
              ),
            );
          }

          final resources = provider.currentResources;
          if (resources == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return RefreshIndicator(
            onRefresh: provider.refreshData,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Riga superiore con cards
                  Row(
                    children: [
                      Expanded(
                        child: ResourceCard(
                          title: l10n.cpu,
                          value: '${resources.cpuUsage.toStringAsFixed(1)}%',
                          icon: Icons.memory,
                          color: Colors.blue,
                          subtitle: '${l10n.load}: ${resources.loadAvg1.toStringAsFixed(2)}',
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ResourceCard(
                          title: l10n.ram,
                          value: '${resources.ramUsagePercentage.toStringAsFixed(1)}%',
                          icon: Icons.storage,
                          color: Colors.green,
                          subtitle: '${(resources.ramUsed / 1024).toStringAsFixed(1)} GB / ${(resources.ramTotal / 1024).toStringAsFixed(1)} GB',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Grafici CPU e RAM
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.cpuUsageOverTime,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            height: 200,
                            child: CpuChart(
                              cpuHistory: provider.getCpuHistory(),
                              timestamps: provider.getTimestamps(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.ramUsageOverTime,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            height: 200,
                            child: RamChart(
                              ramHistory: provider.getRamHistory(),
                              timestamps: provider.getTimestamps(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Grafico Disco
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.diskUsage,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            height: 265,
                            child: DiskChart(
                              diskUsages: resources.diskUsages,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Dettagli dischi
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.diskDetails,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 16),
                          ...resources.diskUsages.map((disk) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  disk.mountPoint,
                                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.bold,                                 
                                  ),
                                ),
                                const SizedBox(height: 4),
                                LinearProgressIndicator(
                                  value: disk.usagePercentage / 100,
                                  backgroundColor: Colors.grey[300],                               
                                  minHeight: 8,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${disk.usedSize.toStringAsFixed(1)} GB / ${disk.totalSize.toStringAsFixed(1)} GB (${disk.usagePercentage.toStringAsFixed(1)}%)',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                          )),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 42), // Added margin bottom
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: Consumer<ServerProvider>(
        builder: (context, provider, _) {
          return FloatingActionButton.extended(
            onPressed: provider.isLoading ? null : provider.refreshData,
            icon: provider.isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Icon(Icons.refresh),
            label: Text(provider.isLoading ? l10n.updating : l10n.update),
          );
        },
      ),
    );
  }
}
