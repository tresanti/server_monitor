# Server Monitor - App Flutter per Monitoraggio Risorse Server

Un'applicazione Flutter che consente di connettersi a un server Linux via SSH e monitorare in tempo reale l'utilizzo delle risorse (CPU, RAM, Disco).

## Caratteristiche

- ✅ Connessione sicura via SSH con autenticazione password
- 📊 Grafici in tempo reale per CPU e RAM
- 💾 Visualizzazione utilizzo disco con grafici a torta
- 🔄 Aggiornamento automatico ogni 10 secondi
- 🔃 Pulsante di refresh manuale
- 📱 Interfaccia Material Design moderna e responsive

## Prerequisiti

- Flutter SDK (>= 3.0.0)
- Dart SDK
- Un server Linux con accesso SSH abilitato

## Installazione

1. Clona o scarica il progetto
2. Naviga nella directory del progetto:
   ```bash
   cd server_monitor
   ```
3. Installa le dipendenze:
   ```bash
   flutter pub get
   ```
4. Esegui l'applicazione:
   ```bash
   flutter run
   ```

## Utilizzo

### 1. Schermata di Login
- **Hostname/IP**: Inserisci l'indirizzo IP o hostname del tuo server
- **Username**: Il tuo username SSH
- **Password**: La tua password SSH
- **Porta**: Porta SSH (default: 22)

### 2. Dashboard
Una volta connesso, vedrai:
- **Cards superiori**: Mostrano l'utilizzo corrente di CPU e RAM
- **Grafico CPU**: Mostra l'andamento dell'utilizzo CPU nel tempo
- **Grafico RAM**: Mostra l'andamento dell'utilizzo RAM nel tempo
- **Grafico Disco**: Grafico a torta con l'utilizzo dei vari filesystem
- **Dettagli Dischi**: Lista dettagliata con barre di progresso per ogni partizione

## Comandi Linux Utilizzati

L'app esegue i seguenti comandi sul server per raccogliere i dati:

- `free -m` - Per informazioni sulla memoria RAM
- `df -h` - Per informazioni sull'utilizzo del disco
- `cat /proc/loadavg` - Per il load average del sistema
- `top -b -n 1 | grep "Cpu(s)"` - Per l'utilizzo della CPU

## Struttura del Progetto

```
server_monitor/
├── lib/
│   ├── main.dart                 # Entry point dell'app
│   ├── models/
│   │   └── server_resources.dart # Modelli dati
│   ├── services/
│   │   ├── ssh_service.dart      # Gestione connessione SSH
│   │   └── server_provider.dart  # State management
│   ├── screens/
│   │   ├── login_screen.dart     # Schermata login
│   │   └── dashboard_screen.dart # Dashboard principale
│   └── widgets/
│       ├── resource_card.dart    # Card per CPU/RAM
│       ├── cpu_chart.dart        # Grafico CPU
│       ├── ram_chart.dart        # Grafico RAM
│       └── disk_chart.dart       # Grafico disco
└── pubspec.yaml                  # Dipendenze

```

## Dipendenze Principali

- **dartssh2**: Per la connessione SSH
- **fl_chart**: Per i grafici
- **provider**: Per la gestione dello stato
- **flutter_spinkit**: Per gli indicatori di caricamento

## Sicurezza

⚠️ **IMPORTANTE**: 
- Le password SSH vengono mantenute solo in memoria durante la sessione
- Non vengono salvate permanentemente sul dispositivo
- Si consiglia l'uso di chiavi SSH per una maggiore sicurezza (feature futura)

## Limitazioni Note

- Attualmente supporta solo autenticazione con password
- I comandi sono ottimizzati per sistemi Linux/Debian
- L'output potrebbe variare leggermente tra diverse distribuzioni

## Possibili Miglioramenti Futuri

- [ ] Supporto per autenticazione con chiave SSH
- [ ] Salvataggio sicuro delle credenziali
- [ ] Grafici storici più dettagliati
- [ ] Notifiche per soglie critiche
- [ ] Supporto multi-server
- [ ] Dark mode
- [ ] Export dei dati in CSV/PDF

## Troubleshooting

### Errore di connessione
- Verifica che il server sia raggiungibile
- Controlla che SSH sia abilitato sul server
- Verifica username e password
- Controlla che la porta SSH sia corretta

### Dati non aggiornati
- Usa il pulsante refresh manuale
- Controlla la connessione di rete
- Verifica che i comandi siano supportati dal tuo server

## Licenza

Questo progetto è distribuito con licenza MIT.
