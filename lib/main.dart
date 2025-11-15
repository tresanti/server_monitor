import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'services/server_provider.dart';
import 'services/saved_servers_service.dart';
import 'screens/login_screen.dart';
import '../gen_l10n/app_localizations.dart';



void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runZonedGuarded<Future<void>>(() async {
    FlutterError.onError = (FlutterErrorDetails details) {
      if (kReleaseMode) {
        FlutterError.presentError(details);
      } else {
        Zone.current.handleUncaughtError(details.exception, details.stack ?? StackTrace.current);
      }
    };

    runApp(const MyApp());
  }, (error, stack) {
    if (error is AssertionError && error.toString().contains('KeyUpEvent')) {
      if (kDebugMode) {
        debugPrint('Suppressed KeyUpEvent assertion: $error');
      }
      return;
    }

    FlutterError.reportError(FlutterErrorDetails(exception: error, stack: stack));
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ServerProvider()),
        ChangeNotifierProvider(create: (_) => SavedServersService()),
      ],
      child: MaterialApp(
        title: 'Server Monitor',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        ),
        debugShowCheckedModeBanner: false,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en'), // English
          Locale('it'), // Italian
        ],
        home: const LoginScreen(),
      ),
    );
  }
}
