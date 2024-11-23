import 'package:app/app_localizations.dart';
import 'package:app/comms/model/request/auth/HostLoginRequest.dart';
import 'package:app/comms/socket_subscription/SocketSubscriptionController.dart';
import 'package:app/model/SecureStorage.dart';
import 'package:app/model/Session.dart';
import 'package:app/model/User.dart';
import 'package:app/ui/NavigatorApp.dart';
import 'package:app/ui/home/HomeControllerPage.dart';
import 'package:app/ui/login/components/my_button.dart';
import 'package:app/ui/login/components/my_textfield.dart';
import 'package:app/ui/register/RegisterPage2.dart';
import 'package:app/ui/utils/Log.dart';
import 'package:app/ui/utils/toast_message.dart';
import 'package:flutter/material.dart';

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
    _emailController.text = "test2@gmail.com";
    _passwordController.text = "Aa1234567\$";

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
    showDialog(
        context: context,
        builder: (context) {
          _processLogin(_emailController.text, _passwordController.text);
          return Center(child: CircularProgressIndicator());
        });
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
              SizedBox(
                  height: 150,
                  width: 150,
                  child: Image.asset("assets/img/splash_icon.png")),
              const SizedBox(height: 50),
               Text(AppLocalizations.of(context)!.translate("do_login"),
                
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
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
                text:  AppLocalizations.of(context)!.translate("do_login"),
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
                    onTap: (){
                        NavigatorApp.push(RegisterPage(), context);
                    },
                    child:  Text(
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

  void _processLogin(String user, String pass) {
    HostLoginRequest().run(user, pass).then((response) {
      if (response.userId.isNotEmpty) {
        Session.user = User.fromHost(response);
        Session.loadProfileImage().then((value) {
          Session.socketSubscription =
              SocketSubscriptionController().initializeSocketConnection();
          SecureStorage().saveSecureData("token", Session.user.token);
          SecureStorage()
              .saveSecureData("refresh_token", Session.user.refreshToken);
          SecureStorage().saveSecureData("user_id", Session.user.userId);
        });

        NavigatorApp.pushAndRemoveUntil(context, Home2());
      } else {
        NavigatorApp.pop(context);
        FlutterToast().showToast(AppLocalizations.of(context)!.translate("wrong_user_pass"));
      }
    }).onError((error, stackTrace) {
      FlutterToast().showToast(AppLocalizations.of(context)!.translate("unknown_error"));
      NavigatorApp.pop(context);
    });
  }
}
