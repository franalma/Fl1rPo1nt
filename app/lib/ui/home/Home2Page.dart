import 'package:app/model/Session.dart';
import 'package:app/model/User.dart';
import 'package:app/services/ConfigService.dart';
import 'package:app/services/IapService.dart';
import 'package:app/services/NewMessageService.dart';
import 'package:app/ui/NavigatorApp.dart';
import 'package:app/ui/contacts/ListContactsPage.dart';
import 'package:app/ui/elements/AlertDialogs.dart';
import 'package:app/ui/elements/DefaultModalDialog.dart';
import 'package:app/ui/elements/FancyButton.dart';
import 'package:app/ui/map_explorer/MapFilterCriterialsPage.dart';
import 'package:app/ui/my_social_networks/MySocialNetworksPage.dart';
import 'package:app/ui/party_mode/PartyModePage.dart';
import 'package:app/ui/qr_manager/ListQrPage.dart';
import 'package:app/ui/smart_points/SmartPointsListPage.dart';
import 'package:app/ui/tutorial/TutorialPage.dart';
import 'package:app/ui/user_profile/UserProfilePage.dart';
import 'package:app/ui/user_state/UserStatePage.dart';
import 'package:app/ui/utils/Log.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class Home2Page extends StatefulWidget {
  @override
  State<Home2Page> createState() => _Home2State();
}

class _Home2State extends State<Home2Page> {
  final User _user = Session.user;
  late ConfigService _configService;

  @override
  void initState()  {
    super.initState();
    Session.socketSubscription?.onNewContactRequested =
        _handleNewContactRequest;
    _configService = ConfigService(_user);
    
    _launchTutorial();
  }

  void _handleNewContactRequest(String message) {
    NewMessageServie().handleNewContactRequest(message, onNewMessage);
  }

  void onNewMessage(String name, String url) {
    AlertDialogs().showCustomModalDialog(context, name, url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () {
                  NavigatorApp.push(UserProfilePage(), context);
                },
                icon: const Icon(Icons.account_circle))
          ],
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue, Colors.purple],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
        ),
        body: Stack(
          children: [
            _buildBody(),
          ],
        ));
  }

  Widget _buildBody() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          shrinkWrap: true, // Allows GridView to take only the needed space
          crossAxisCount: 2, // Two buttons per row
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          children: [
            FancyButton(
                text: 'Mi estado',
                icon: FontAwesomeIcons.eye,
                color: const Color.fromARGB(255, 237, 129, 6),
                onTap: () {
                  NavigatorApp.push(UserStatePage(), context);
                }),
            FancyButton(
                text: 'Mis redes',
                icon: FontAwesomeIcons.solidCirclePlay,
                color: Color.fromARGB(255, 85, 22, 244),
                onTap: () {
                  NavigatorApp.push(const MySocialNetworksPage(), context);
                }),
            FancyButton(
                text: 'Mis QR',
                icon: Icons.qr_code,
                color: const Color.fromARGB(255, 187, 23, 202),
                onTap: () {
                  NavigatorApp.push(ListQrPage(), context);
                }),
            FancyButton(
                text: 'Modo fiesta',
                icon: FontAwesomeIcons.hands,
                color: Colors.blue,
                onTap: () async {
                  var result = await _launchConfigChecker();
                  if (await _launchConfigChecker() == ConfigError.noError) {
                    if (_user.isFlirting) {
                      if (_user.qrValues.isEmpty) {
                        DefaultModalDialog.showErrorDialog(
                            context,
                            "Debes crear al menos un QR para compartir",
                            "Cerrar",
                            FontAwesomeIcons.exclamation);
                      } else {
                        NavigatorApp.push(PartyModePage(), context);
                      }
                    } else {
                      AlertDialogs().showModalDialogMessage(
                          context,
                          200,
                          Icons.visibility,
                          50,
                          Colors.red,
                          "Debes hacerte visible para comenzar la fiesta",
                          const TextStyle(fontSize: 18),
                          "Cerrar");
                    }
                  }
                }),
            FancyButton(
                text: 'Mis contactos',
                icon: Icons.favorite,
                color: Colors.pink,
                onTap: () async {
                  if (await _launchConfigChecker() == ConfigError.noError) {
                    NavigatorApp.push(ListContactsPage(), context);
                  }
                }),
            FancyButton(
                text: 'Buscar',
                icon: Icons.search,
                color: Colors.amber,
                onTap: () async {
                  if (await _launchConfigChecker() == ConfigError.noError) {
                    if (_user.isFlirting) {
                      if (Session.location != null) {
                        NavigatorApp.push(MapFilterCriterialsPage(), context);
                      } else {
                        DefaultModalDialog.showErrorDialog(
                            context,
                            "Debes activar tu ubicación para poder acceder al mapa",
                            "Cerrar",
                            FontAwesomeIcons.exclamation);
                      }
                    } else {
                      AlertDialogs().showModalDialogMessage(
                          context,
                          200,
                          Icons.visibility,
                          50,
                          Colors.red,
                          "Debes hacerte visible para comenzar la fiesta",
                          const TextStyle(fontSize: 18),
                          "Cerrar");
                    }
                  }
                }),
            FancyButton(
                text: 'Mis Puntos',
                icon: Icons.nfc,
                color: const Color.fromARGB(255, 91, 3, 61),
                onTap: () {
                  NavigatorApp.push(SmartPointsListPage(), context);
                }),
            FancyButton(
                text: 'Dónde ir',
                icon: Icons.people,
                color: Colors.green,
                onTap: () {}),
          ],
        ),
      ),
    );
  }

  void _handleConfigCheckerStatus(ConfigError result) {
    switch (result) {
      case ConfigError.genderRequired:
        DefaultModalDialog.showErrorDialog(
            context,
            "Necesitamos tu género antes de comenzar. Cámbialo en Mi Estado",
            "Cerrar",
            FontAwesomeIcons.genderless);
        break;

      case ConfigError.qrRequired:
        DefaultModalDialog.showErrorDialog(
            context,
            "Necesitamos que registres un QR antes de comenzar. Agrégalo en Mis QR",
            "Cerrar",
            FontAwesomeIcons.qrcode);
        break;

      case ConfigError.profileImageRequired:
        DefaultModalDialog.showErrorDialog(
            context,
            "Necesitamos que añadas al menos una foto a tu perfil. Puedes hacerlo en Mi Estado",
            "Cerrar",
            FontAwesomeIcons.image);
        break;

      case ConfigError.sexOrientationRequired:
        DefaultModalDialog.showErrorDialog(
            context,
            "Necesitamos que indiques tu preferencia sexual. Puedes hacerlo en Mi Estado",
            "Cerrar",
            FontAwesomeIcons.person);
        break;
      case ConfigError.relationshipRequired:
        DefaultModalDialog.showErrorDialog(
            context,
            "Necesitamos que indiques el tipo de pareja que buscas. Puedes hacerlo en Mi Estado",
            "Cerrar",
            FontAwesomeIcons.peopleGroup);
        break;
      case ConfigError.lookingForGenderRequired:
        DefaultModalDialog.showErrorDialog(
            context,
            "Necesitamos que indiques el género que buscas. Puedes hacerlo en Mi Estado",
            "Cerrar",
            FontAwesomeIcons.searchengin);
        break;
      case ConfigError.biographyRequired:
        DefaultModalDialog.showErrorDialog(
            context,
            "Necesitamos que hables un poco sobre ti. Puedes hacerlo en Mi Estado",
            "Cerrar",
            FontAwesomeIcons.peopleGroup);
        break;
      case ConfigError.hobbiesRequired:
        DefaultModalDialog.showErrorDialog(
            context,
            "Necesitamos que indiques tus afciones. Puedes hacerlo en Mi Estado",
            "Cerrar",
            FontAwesomeIcons.peopleGroup);
        break;
      default:
    }
  }

  Future<ConfigError> _launchConfigChecker() async {
    Log.d("Starts _launchConfigChecker");
    ConfigError result = ConfigError.noError;

    try {
      result = _configService.checkConfiguration();
      _handleConfigCheckerStatus(result);
    } catch (error, stackTrace) {
      Log.d("$error $stackTrace");
    }
    return result;
  }

  Future<void> _launchTutorial() async {
    Log.d("Starts _launchConfigChecker");
    try {
      bool isFirstLogin = await _configService.isFirstLogin();
      if (isFirstLogin) {
        TutorialPage.showTutorialDialog(context);
        await _configService.registerFirstInit(true);
      } else {
        await _launchConfigChecker();
      }
    } catch (error, stackTrace) {
      Log.d("$error, $stackTrace");
    }
  }
}
