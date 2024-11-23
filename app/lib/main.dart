import 'package:app/app_localizations.dart';
import 'package:app/ui/login/LoginPage.dart';
import 'package:app/ui/login/LoginPage2.dart';
import 'package:app/ui/splash/SplashPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
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
        home:LoginPage2(onTap: () {  },));
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
