import 'package:app/app_localizations.dart';
import 'package:app/services/AnalyticsService.dart';
import 'package:app/services/CrahsalitycsService.dart';
import 'package:app/services/RemoteConfigService.dart';
import 'package:app/ui/login/LoginPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  await Firebase.initializeApp();
  AnalyticsService.init();
  await AnalyticsService.logCustomEvent();
  RemoteConfigService.init();
  await RemoteConfigService.fetchFromHost();
  RemoteConfigService.getApiKey();
  CrahsalitycsService.init(); 
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: '',
        locale: const Locale('es'), // Idioma predeterminado
        supportedLocales: const [
          // Locale('en', ''), // Inglés
          Locale('es', ''), // Español
        ],
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        theme: _buildThemeData(),
        // home: SplashPage());
        home: LoginPage2());
  }

  ThemeData _buildThemeData() {
    return ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
        // brightness: Brightness.dark,
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontSize: 72, fontWeight: FontWeight.bold),
          titleLarge: TextStyle(
            fontSize: 30,
            fontStyle: FontStyle.italic,
          ),
        ),
        appBarTheme: const AppBarTheme(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white //here you can give the text color
            ));
  }
}
