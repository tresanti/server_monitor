import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_it.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen_l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('it')
  ];

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'Server Monitor'**
  String get appTitle;

  /// Connect to server subtitle
  ///
  /// In en, this message translates to:
  /// **'Connect to server'**
  String get connectToServer;

  /// Login screen subtitle
  ///
  /// In en, this message translates to:
  /// **'Connect to your server via SSH'**
  String get connectToYourServer;

  /// Server name field label
  ///
  /// In en, this message translates to:
  /// **'Server name'**
  String get serverName;

  /// Hostname or IP field label
  ///
  /// In en, this message translates to:
  /// **'Hostname/IP'**
  String get hostnameIp;

  /// Username field label
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// Password field label
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// SSH port field label
  ///
  /// In en, this message translates to:
  /// **'SSH Port (default: 22)'**
  String get sshPort;

  /// Connect button label
  ///
  /// In en, this message translates to:
  /// **'Connect'**
  String get connect;

  /// Connecting status
  ///
  /// In en, this message translates to:
  /// **'Connecting...'**
  String get connecting;

  /// Connection error dialog title
  ///
  /// In en, this message translates to:
  /// **'Connection Error'**
  String get connectionError;

  /// Error details label
  ///
  /// In en, this message translates to:
  /// **'Error details:'**
  String get errorDetails;

  /// Unknown error message
  ///
  /// In en, this message translates to:
  /// **'Unknown error'**
  String get unknownError;

  /// Verify label
  ///
  /// In en, this message translates to:
  /// **'Verify:'**
  String get verify;

  /// Verify hostname message
  ///
  /// In en, this message translates to:
  /// **'• Hostname/IP is correct'**
  String get verifyHostname;

  /// Verify port message
  ///
  /// In en, this message translates to:
  /// **'• SSH port is correct (default: 22)'**
  String get verifyPort;

  /// Verify credentials message
  ///
  /// In en, this message translates to:
  /// **'• Username and password are correct'**
  String get verifyCredentials;

  /// Verify server active message
  ///
  /// In en, this message translates to:
  /// **'• SSH server is active and reachable'**
  String get verifyServerActive;

  /// Verify firewall message
  ///
  /// In en, this message translates to:
  /// **'• Firewall allows the connection'**
  String get verifyFirewall;

  /// OK button
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// Cancel button
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Delete button
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// Delete server dialog title
  ///
  /// In en, this message translates to:
  /// **'Delete server'**
  String get deleteServer;

  /// Delete server confirmation message
  ///
  /// In en, this message translates to:
  /// **'Do you want to delete the server \"{serverName}\"?'**
  String deleteServerConfirm(String serverName);

  /// Changes will be saved message
  ///
  /// In en, this message translates to:
  /// **'Changes will be saved automatically'**
  String get changesWillBeSaved;

  /// Add new server title
  ///
  /// In en, this message translates to:
  /// **'Add new server'**
  String get addNewServer;

  /// Enter server info subtitle
  ///
  /// In en, this message translates to:
  /// **'Enter server information'**
  String get enterServerInfo;

  /// Save server button
  ///
  /// In en, this message translates to:
  /// **'Save server'**
  String get saveServer;

  /// Scroll hint for saved servers
  ///
  /// In en, this message translates to:
  /// **'Swipe to see saved servers'**
  String get scrollToSeeSavedServers;

  /// Server count indicator
  ///
  /// In en, this message translates to:
  /// **'{current} of {total} servers'**
  String serverCount(int current, int total);

  /// Server name validation message
  ///
  /// In en, this message translates to:
  /// **'Enter a server name'**
  String get enterServerName;

  /// Hostname validation message
  ///
  /// In en, this message translates to:
  /// **'Enter hostname or IP'**
  String get enterHostname;

  /// Username validation message
  ///
  /// In en, this message translates to:
  /// **'Enter username'**
  String get enterUsername;

  /// Password validation message
  ///
  /// In en, this message translates to:
  /// **'Enter password'**
  String get enterPassword;

  /// Invalid port validation message
  ///
  /// In en, this message translates to:
  /// **'Invalid port'**
  String get invalidPort;

  /// Resources title
  ///
  /// In en, this message translates to:
  /// **'Resources'**
  String get resources;

  /// CPU label
  ///
  /// In en, this message translates to:
  /// **'CPU'**
  String get cpu;

  /// RAM label
  ///
  /// In en, this message translates to:
  /// **'RAM'**
  String get ram;

  /// Disk label
  ///
  /// In en, this message translates to:
  /// **'Disk'**
  String get disk;

  /// Used label
  ///
  /// In en, this message translates to:
  /// **'Used'**
  String get used;

  /// Free label
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get free;

  /// Usage label
  ///
  /// In en, this message translates to:
  /// **'Usage'**
  String get usage;

  /// Loading data message
  ///
  /// In en, this message translates to:
  /// **'Loading data...'**
  String get loadingData;

  /// Connection lost message
  ///
  /// In en, this message translates to:
  /// **'Connection lost'**
  String get connectionLost;

  /// Last update time
  ///
  /// In en, this message translates to:
  /// **'Last update: {time}'**
  String lastUpdate(String time);

  /// System label
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get system;

  /// Swap label
  ///
  /// In en, this message translates to:
  /// **'Swap'**
  String get swap;

  /// Disconnect tooltip
  ///
  /// In en, this message translates to:
  /// **'Disconnect'**
  String get disconnect;

  /// Error label
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// Retry button
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// CPU load label
  ///
  /// In en, this message translates to:
  /// **'Load'**
  String get load;

  /// CPU chart title
  ///
  /// In en, this message translates to:
  /// **'CPU usage over time'**
  String get cpuUsageOverTime;

  /// RAM chart title
  ///
  /// In en, this message translates to:
  /// **'RAM usage over time'**
  String get ramUsageOverTime;

  /// Disk usage title
  ///
  /// In en, this message translates to:
  /// **'Disk Usage'**
  String get diskUsage;

  /// Disk details title
  ///
  /// In en, this message translates to:
  /// **'Disk Details'**
  String get diskDetails;

  /// Updating status
  ///
  /// In en, this message translates to:
  /// **'Updating...'**
  String get updating;

  /// Update button
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'it'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'it': return AppLocalizationsIt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
