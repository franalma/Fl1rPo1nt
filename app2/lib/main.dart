import 'package:app/app_localizations.dart';
import 'package:app/comms/HostController.dart';
import 'package:app/comms/model/user.dart';
import 'package:app/ui/home/home.dart';
import 'package:app/ui/login/LoginPage.dart';
import 'package:app/ui/utils/toast_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'ui/NavigatorApp.dart';
import 'model/session.dart';

void main() {
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
        home: LoginPage(processLogin));
  }

  void processLogin(String user, String pass, BuildContext context) {
    HostController()
        .doLogin("test@gmail.com", "Aa1234567\$")
        .then((response) {
      if (response.id.isNotEmpty) {
        Session.user = User(response.mail, response.name, response.mail);
        NavigatorApp.push(Home(), context);
      } else {
        FlutterToast().showToast("Usuario/contraseña incorrectos");
      }
    }).onError((error, stackTrace) {
       FlutterToast().showToast("Error desconocido");
      print(stackTrace);
    });
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
