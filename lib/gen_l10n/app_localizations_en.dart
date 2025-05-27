// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Server Monitor';

  @override
  String get connectToServer => 'Connect to server';

  @override
  String get connectToYourServer => 'Connect to your server via SSH';

  @override
  String get serverName => 'Server name';

  @override
  String get hostnameIp => 'Hostname/IP';

  @override
  String get username => 'Username';

  @override
  String get password => 'Password';

  @override
  String get sshPort => 'SSH Port (default: 22)';

  @override
  String get connect => 'Connect';

  @override
  String get connecting => 'Connecting...';

  @override
  String get connectionError => 'Connection Error';

  @override
  String get errorDetails => 'Error details:';

  @override
  String get unknownError => 'Unknown error';

  @override
  String get verify => 'Verify:';

  @override
  String get verifyHostname => '• Hostname/IP is correct';

  @override
  String get verifyPort => '• SSH port is correct (default: 22)';

  @override
  String get verifyCredentials => '• Username and password are correct';

  @override
  String get verifyServerActive => '• SSH server is active and reachable';

  @override
  String get verifyFirewall => '• Firewall allows the connection';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get deleteServer => 'Delete server';

  @override
  String deleteServerConfirm(String serverName) {
    return 'Do you want to delete the server \"$serverName\"?';
  }

  @override
  String get changesWillBeSaved => 'Changes will be saved automatically';

  @override
  String get addNewServer => 'Add new server';

  @override
  String get enterServerInfo => 'Enter server information';

  @override
  String get saveServer => 'Save server';

  @override
  String get scrollToSeeSavedServers => 'Swipe to see saved servers';

  @override
  String serverCount(int current, int total) {
    return '$current of $total servers';
  }

  @override
  String get enterServerName => 'Enter a server name';

  @override
  String get enterHostname => 'Enter hostname or IP';

  @override
  String get enterUsername => 'Enter username';

  @override
  String get enterPassword => 'Enter password';

  @override
  String get invalidPort => 'Invalid port';

  @override
  String get resources => 'Resources';

  @override
  String get cpu => 'CPU';

  @override
  String get ram => 'RAM';

  @override
  String get disk => 'Disk';

  @override
  String get used => 'Used';

  @override
  String get free => 'Free';

  @override
  String get usage => 'Usage';

  @override
  String get loadingData => 'Loading data...';

  @override
  String get connectionLost => 'Connection lost';

  @override
  String lastUpdate(String time) {
    return 'Last update: $time';
  }

  @override
  String get system => 'System';

  @override
  String get swap => 'Swap';

  @override
  String get disconnect => 'Disconnect';

  @override
  String get error => 'Error';

  @override
  String get retry => 'Retry';

  @override
  String get load => 'Load';

  @override
  String get cpuUsageOverTime => 'CPU usage over time';

  @override
  String get ramUsageOverTime => 'RAM usage over time';

  @override
  String get diskUsage => 'Disk Usage';

  @override
  String get diskDetails => 'Disk Details';

  @override
  String get updating => 'Updating...';

  @override
  String get update => 'Update';
}
