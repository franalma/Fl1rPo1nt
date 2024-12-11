import 'package:app/app_localizations.dart';
import 'package:app/comms/model/request/auth/HostLoginRequest.dart';
import 'package:app/comms/model/response/auth/HostLoginResponse.dart';
import 'package:app/comms/socket_subscription/SocketSubscriptionController.dart';
import 'package:app/model/Flirt.dart';
import 'package:app/model/HostErrorCode.dart';
import 'package:app/model/SecureStorage.dart';
import 'package:app/model/Session.dart';
import 'package:app/services/DeviceInfoService.dart';
import 'package:app/ui/NavigatorApp.dart';
import 'package:app/ui/elements/AlertDialogs.dart';
import 'package:app/ui/elements/DefaultModalDialog.dart';
import 'package:app/ui/home/Home2Page.dart';
import 'package:app/ui/elements/my_button.dart';
import 'package:app/ui/elements/my_textfield.dart';
import 'package:app/ui/register/RegisterPage.dart';
import 'package:app/ui/utils/Log.dart';
import 'package:app/ui/utils/toast_message.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum StatusDialog { accountNotActivate, wrongUserPass, unknownError, exception }

class LoginPage2 extends StatefulWidget {
  @override
  State<LoginPage2> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage2> {
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    NavigatorApp(context);
    super.initState();

    _tryLoginWithStoredInfo().then((value) {
      Log.d("stored info: $value");
      if (value) {
      } else {}
    });
  }

  void showmessage(String errorMessage) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(title: Text(errorMessage));
        });
  }

  void _signUserIn(BuildContext context) async {
    _processLogin(_emailController.text, _passwordController.text);
    AlertDialogs().buildLoadingModal(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const SizedBox(height: 20),
              GestureDetector(
                onDoubleTap: () {
                  _emailController.text = "test@floiint.com";
                  _passwordController.text = "Aa123456\$";
                },
                child: SizedBox(
                    height: 150,
                    width: 150,
                    child: Image.asset("assets/img/floiint_logo.png")),
              ),
              const SizedBox(height: 50),
              GestureDetector(
                onDoubleTap: () {
                  _emailController.text = "test2@floiint.com";
                  _passwordController.text = "Aa123456\$";
                },
                child: Text(
                  AppLocalizations.of(context)!.translate("do_login"),
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 25),
              MyTextField(
                controller: _emailController,
                hintText: AppLocalizations.of(context)!.translate("user"),
                obscureText: false,
              ),
              const SizedBox(height: 10),
              MyTextField(
                controller: _passwordController,
                hintText: AppLocalizations.of(context)!.translate("password"),
                obscureText: true,
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    AppLocalizations.of(context)!.translate("password_forgot"),
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),
              ),
              const SizedBox(height: 25),
              MyButton(
                text: AppLocalizations.of(context)!.translate("do_login"),
                onTap: () => _signUserIn(context),
              ),
              const SizedBox(height: 70),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppLocalizations.of(context)!.translate("no_account"),
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: () {
                      NavigatorApp.push(RegisterPage(), context);
                    },
                    child: Text(
                      AppLocalizations.of(context)!.translate("register_now"),
                      style: const TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _tryLoginWithStoredInfo() async {
    String? userId = await SecureStorage().getSecureData("user_id");
    String? token = await SecureStorage().getSecureData("token");
    String? refreshToken = await SecureStorage().getSecureData("refresh_token");

    if (userId != null && token != null && refreshToken != null) {
      return true;
    }
    return false;
  }

  void _showStatusDialog(StatusDialog status) {
    Log.d("Starts ");

    switch (status) {
      case StatusDialog.accountNotActivate:
        {
          NavigatorApp.pop(context);
          DefaultModalDialog.showErrorDialog(
              context,
              "Tu cuenta no está activada, revisa tu correo electrónico",
              "Cerrar",
              FontAwesomeIcons.envelope);
          break;
        }
      case StatusDialog.wrongUserPass:
        {
          NavigatorApp.pop(context);
          DefaultModalDialog.showErrorDialog(
              context,
              "Usuario/Contraseña incorrectos",
              "Cerrar",
              FontAwesomeIcons.circleExclamation);
          break;
        }
      case StatusDialog.unknownError:
        {
          NavigatorApp.pop(context);
          DefaultModalDialog.showErrorDialog(context, "Error desconocido",
              "Cerrar", FontAwesomeIcons.circleExclamation);
          break;
        }
      case StatusDialog.exception:
        {
          FlutterToast().showToast(
              AppLocalizations.of(context)!.translate("unknown_error"));
          NavigatorApp.pop(context);
          break;
        }
    }
  }

  void _processLogin(String user, String pass) async {
    Log.d("Starts _processLogin");
    try {
      var response = await HostLoginRequest().run(user, pass);
      HostErrorCodesValue hostErrorCodesValue =
          HostErrorCodesValue.parse(response.hostErrorCode!.code);
      Log.d("Loging status ${hostErrorCodesValue.code}");
      switch (hostErrorCodesValue) {
        case HostErrorCodesValue.NoError:
          {
            _onLoginSuccess(response);
            break;
          }

        case HostErrorCodesValue.UserNotActivated:
          {
            _showStatusDialog(StatusDialog.accountNotActivate);
            break;
          }

        case HostErrorCodesValue.WrongUserPass:
          {
            _showStatusDialog(StatusDialog.wrongUserPass);
            break;
          }

        default:
          {
            _showStatusDialog(StatusDialog.unknownError);
          }
      }
    } catch (error, stackTrace) {
      Log.d("$error, $stackTrace");
      _showStatusDialog(StatusDialog.exception);
    }
  }

  void _onLoginSuccess(HostLoginResponse response) {
    try {
      if (response.user != null) {
        Session.user = response.user!;
        Deviceinfoservice().init(context);
        Session.socketSubscription =
            SocketSubscriptionController().initializeSocketConnection();

        Session.user.getActiveFlirtByUserId().then((flirt) {
          if (flirt != null) {
            Session.currentFlirt = flirt;
            Session.user.isFlirting = true;
          }

          Session.loadProfileImage().then((value) {
            SecureStorage().saveSecureData("token", Session.user.token);
            SecureStorage()
                .saveSecureData("refresh_token", Session.user.refreshToken);
            SecureStorage().saveSecureData("user_id", Session.user.userId);

            NavigatorApp.pushAndRemoveUntil(context, Home2Page());
          });
        });
      } else {
        _showStatusDialog(StatusDialog.unknownError);
      }
    } catch (error, stackTrace) {
      Log.d("$error, $stackTrace");
    }
  }
}
