# Server Monitor - Flutter App for Server Resource Monitoring

A Flutter application that allows you to connect to a Linux server via SSH and monitor resource usage (CPU, RAM, Disk) in real-time.

## Features

- ✅ Secure SSH connection with password authentication
- 📊 Real-time charts for CPU and RAM
- 💾 Disk usage visualization with pie charts
- 🔄 Automatic refresh every 5 seconds
- 🔃 Manual refresh button
- 📱 Modern and responsive Material Design interface

## Prerequisites

- Flutter SDK (>= 3.0.0)
- Dart SDK
- A Linux server with SSH access enabled

## Installation

1.  Clone or download the project
2.  Navigate to the project directory:
    ```bash
    cd server_monitor
    ```
3.  Install dependencies:
    ```bash
    flutter pub get
    ```
4.  Run the application:
    ```bash
    flutter run
    ```

## Usage

### 1. Login Screen
- **Hostname/IP**: Enter your server's IP address or hostname
- **Username**: Your SSH username
- **Password**: Your SSH password
- **Port**: SSH port (default: 22)

### 2. Dashboard
Once connected, you will see:
- **Top Cards**: Show current CPU and RAM usage
- **CPU Chart**: Shows CPU usage trend over time
- **RAM Chart**: Shows RAM usage trend over time
- **Disk Chart**: Pie chart showing the usage of various filesystems
- **Disk Details**: Detailed list with progress bars for each partition

## Linux Commands Used

The app executes the following commands on the server to collect data:

- `free -m` - For RAM memory information
- `df -h` - For disk usage information
- `cat /proc/loadavg` - For system load average
- `top -b -n 1 | grep "Cpu(s)"` - For CPU usage

## Project Structure

```
server_monitor/
├── lib/
│   ├── main.dart                 # App entry point
│   ├── models/
│   │   └── server_resources.dart # Data models
│   ├── services/
│   │   ├── ssh_service.dart      # SSH connection management
│   │   └── server_provider.dart  # State management
│   ├── screens/
│   │   ├── login_screen.dart     # Login screen
│   │   └── dashboard_screen.dart # Main dashboard
│   └── widgets/
│       ├── resource_card.dart    # Card for CPU/RAM
│       ├── cpu_chart.dart        # CPU chart
│       ├── ram_chart.dart        # RAM chart
│       └── disk_chart.dart       # Disk chart
└── pubspec.yaml                  # Dependencies

```

## Main Dependencies

- **dartssh2**: For SSH connection
- **fl_chart**: For charts
- **provider**: For state management
- **flutter_spinkit**: For loading indicators

## Security

⚠️ **IMPORTANT**:
- SSH passwords are only kept in memory during the session
- They are not permanently saved on the device
- Using SSH keys is recommended for enhanced security (future feature)

## Known Limitations

- Currently only supports password authentication
- Commands are optimized for Linux/Debian systems
- Output may vary slightly between different distributions

## Possible Future Improvements

- [ ] Support for SSH key authentication
- [ ] Secure credential saving
- [ ] More detailed historical charts
- [ ] Notifications for critical thresholds
- [ ] Multi-server support
- [ ] Dark mode
- [ ] Data export to CSV/PDF

## Troubleshooting

### Connection Error
- Verify that the server is reachable
- Check that SSH is enabled on the server
- Verify username and password
- Check that the SSH port is correct

### Data not updating
- Use the manual refresh button
- Check your network connection
- Verify that the commands are supported by your server

## License

This project is distributed under the MIT license.