import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class TutorialPage {
  static void showTutorialDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Bienvenid@ a Floiint!"),
          content: ListView(
          
            // mainAxisSize: MainAxisSize.min,
            children: const [
              Text('Algunos consejos antes de empezar a utilizar Floiint:'),
              SizedBox(height: 10),
              ListTile(
                leading: Icon(Icons.person),
                title: Text('Completa tu perfil en la opción Mi Estado.'),
              ),
              ListTile(
                leading: Icon(Icons.qr_code),
                title: Text('Crea códigos QR con tus datos a compartir.'),
              ),
              ListTile(
                leading: Icon(Icons.play_arrow),
                title: Text('Añade las redes que quieras compartir.'),
              ),
              ListTile(
                leading: Icon(Icons.visibility),
                title: Text('Cambia tu visibilidad en tu perfil.'),
              ),
              ListTile(
                leading: Icon(Icons.party_mode),
                title: Text('Utiliza el modo fiesta para escanear y guardar contactos de tus ligues.'),
              ),
               ListTile(
                leading: Icon(FontAwesomeIcons.heart),
                title: Text("Consulta el perfil y habla con tus contactos."),
              ),
              ListTile(
                leading: Icon(FontAwesomeIcons.searchengin),
                title: Text("Busca nuevos contactos con tus mismos intereses."),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('¡A ligar!'),
            ),
          ],
        );
      },
    );
  }
}
