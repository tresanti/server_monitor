// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appTitle => 'Server Monitor';

  @override
  String get connectToServer => 'Connetti al server';

  @override
  String get connectToYourServer => 'Connetti al tuo server via SSH';

  @override
  String get serverName => 'Nome server';

  @override
  String get hostnameIp => 'Hostname/IP';

  @override
  String get username => 'Username';

  @override
  String get password => 'Password';

  @override
  String get sshPort => 'Porta SSH (default: 22)';

  @override
  String get connect => 'Connetti';

  @override
  String get connecting => 'Connessione in corso...';

  @override
  String get connectionError => 'Errore di connessione';

  @override
  String get errorDetails => 'Dettagli dell\'errore:';

  @override
  String get unknownError => 'Errore sconosciuto';

  @override
  String get verify => 'Verifica:';

  @override
  String get verifyHostname => '• L\'hostname/IP è corretto';

  @override
  String get verifyPort => '• La porta SSH è corretta (default: 22)';

  @override
  String get verifyCredentials => '• Username e password sono corretti';

  @override
  String get verifyServerActive => '• Il server SSH è attivo e raggiungibile';

  @override
  String get verifyFirewall => '• Il firewall permette la connessione';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Annulla';

  @override
  String get delete => 'Elimina';

  @override
  String get deleteServer => 'Elimina server';

  @override
  String deleteServerConfirm(String serverName) {
    return 'Vuoi eliminare il server \"$serverName\"?';
  }

  @override
  String get changesWillBeSaved => 'Le modifiche verranno salvate automaticamente';

  @override
  String get addNewServer => 'Aggiungi nuovo server';

  @override
  String get enterServerInfo => 'Inserisci le informazioni del server';

  @override
  String get saveServer => 'Salva server';

  @override
  String get scrollToSeeSavedServers => 'Scorri per vedere i server salvati';

  @override
  String serverCount(int current, int total) {
    return '$current di $total server';
  }

  @override
  String get enterServerName => 'Inserisci un nome per il server';

  @override
  String get enterHostname => 'Inserisci l\'hostname o l\'IP';

  @override
  String get enterUsername => 'Inserisci l\'username';

  @override
  String get enterPassword => 'Inserisci la password';

  @override
  String get invalidPort => 'Porta non valida';

  @override
  String get resources => 'Risorse';

  @override
  String get cpu => 'CPU';

  @override
  String get ram => 'RAM';

  @override
  String get disk => 'Disco';

  @override
  String get used => 'Usato';

  @override
  String get free => 'Libero';

  @override
  String get usage => 'Utilizzo';

  @override
  String get loadingData => 'Caricamento dati...';

  @override
  String get connectionLost => 'Connessione persa';

  @override
  String lastUpdate(String time) {
    return 'Ultimo aggiornamento: $time';
  }

  @override
  String get system => 'Sistema';

  @override
  String get swap => 'Swap';

  @override
  String get disconnect => 'Disconnetti';

  @override
  String get error => 'Errore';

  @override
  String get retry => 'Riprova';

  @override
  String get load => 'Carico';

  @override
  String get cpuUsageOverTime => 'Utilizzo CPU nel tempo';

  @override
  String get ramUsageOverTime => 'Utilizzo RAM nel tempo';

  @override
  String get diskUsage => 'Utilizzo Disco';

  @override
  String get diskDetails => 'Dettagli Dischi';

  @override
  String get updating => 'Aggiornamento...';

  @override
  String get update => 'Aggiorna';
}
