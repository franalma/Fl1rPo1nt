import 'package:app/app_localizations.dart';
import 'package:app/ui/elements/AppDrawerMenu.dart';
import 'package:app/ui/elements/Navigator.dart';
import 'package:app/ui/elements/UIElements.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: AppDrawerMenu().getDrawer(context),
        appBar: AppBar(
            title: Text(AppLocalizations.of(context)!.translate('app_name'))),
        body: Center(
            child: Column(
          children: [
            Expanded(
              child: Container(
                color: Colors.blue,
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.green,
              ),
            ),
            Positioned(
              top: 50, // Ajusta la posición del botón en la primera parte
              left: 20,
              child: FloatingActionButton(
                onPressed: () {
                  print('Botón flotante 1 presionado');
                },
                child: const Icon(Icons.add),
              ),
            ),
            Positioned(
              bottom: 50, // Ajusta la posición del botón en la segunda parte
              right: 20,
              child: FloatingActionButton(
                onPressed: () {
                  print('Botón flotante 2 presionado');
                },
                child: const Icon(Icons.add),
              ),
            ),
          ],
        )));
  }
}
