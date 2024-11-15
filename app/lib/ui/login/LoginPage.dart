
import 'package:app/app_localizations.dart';
import 'package:app/comms/model/request/auth/HostLoginRequest.dart';
import 'package:app/comms/socket_subscription/SocketSubscriptionController.dart';
import 'package:app/model/Session.dart';
import 'package:app/model/User.dart';
import 'package:app/ui/home/home.dart';
import 'package:app/ui/utils/toast_message.dart';
import 'package:flutter/material.dart';
import '../NavigatorApp.dart';
import '../register/RegisterPage.dart';

class LoginPage extends StatefulWidget {
  // void Function(String, String, BuildContext context) onLoginTapped;

  LoginPage({super.key});

  @override
  State<LoginPage> createState() {
    return _LoginPage();
  }
}

class _LoginPage extends State<LoginPage> {
  bool isChecked = false;
  late bool _isLoading = false;

  TextEditingController userController = TextEditingController();
  TextEditingController passController = TextEditingController();

  Widget _buildTextField(
      {required bool obscureText,
      required prefixedIcon,
      required hintText,
      required textController}) {
    return Material(
      color: Colors.transparent,
      elevation: 2,
      child: TextField(
        controller: textController,
        cursorColor: Colors.white,
        cursorWidth: 2,
        obscureText: obscureText,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          border: InputBorder.none,
          filled: true,
          fillColor: Color(0xFF5180ff),
          prefixIcon: prefixedIcon,
          hintText: hintText,
          hintStyle: const TextStyle(
            color: Colors.white54,
            fontWeight: FontWeight.bold,
            fontFamily: 'PTSans',
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    NavigatorApp(context);
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF5967ff),
                Color(0xFF5374ff),
                Color(0xFF5180ff),
                Color(0xFF538bff),
                Color(0xFF5995ff),
              ],
            ),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 40,
              ).copyWith(top: 20),
              child: Column(
                children: [
                  const Text(
                    'Inicia sesión',
                    style: TextStyle(
                      fontFamily: 'PT-Sans',
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      'Correo electrónico',
                      style: TextStyle(
                        fontFamily: 'PT-Sans',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  _buildTextField(
                      hintText: 'Introduce tu correo',
                      obscureText: false,
                      prefixedIcon: const Icon(Icons.mail, color: Colors.white),
                      textController: userController),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      'Contraseña',
                      style: TextStyle(
                        fontFamily: 'PT-Sans',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  _buildTextField(
                      hintText: 'Contraseña',
                      obscureText: true,
                      prefixedIcon: const Icon(Icons.lock, color: Colors.white),
                      textController: passController),
                  const SizedBox(
                    height: 15,
                  ),
                  _buildForgotPasswordButton(),
                  _buildRemeberMe(),
                  const SizedBox(
                    height: 15,
                  ),
                  _buildLoginButton(),
                  _buildLoadingIndicator(),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    '-O-',
                    style: TextStyle(
                      fontFamily: 'PT-Sans',
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    'Inicia sesión con ... ',
                    style: TextStyle(
                      fontFamily: 'PT-Sans',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  _buildSocialButtons(),
                  const SizedBox(
                    height: 30,
                  ),
                  _buildSignUpQuestion()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return _isLoading
        ? (const Center(
            child: CircularProgressIndicator(),
          ))
        : Container();
  }

  Widget _buildSignUpQuestion() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          AppLocalizations.of(context)!.translate("no_account"),
          style: const TextStyle(
            fontFamily: 'PT-Sans',
            fontSize: 16,
            color: Colors.white,
          ),
        ),
        InkWell(
          child: Text(
            AppLocalizations.of(context)!.translate("register"),
            style: const TextStyle(
              fontFamily: 'PT-Sans',
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          onTap: () {
            NavigatorApp.push(RegisterPage(), context);
          },
        ),
      ],
    );
  }

  Widget _buildForgotPasswordButton() {
    return Container(
      alignment: Alignment.centerRight,
      child: TextButton(
        child: Text(
          AppLocalizations.of(context)!.translate("pass_forgot"),
          style: const TextStyle(
            fontFamily: 'PT-Sans',
            fontSize: 14,
            color: Colors.white,
          ),
        ),
        onPressed: () {},
      ),
    );
  }

  Widget _buildRemeberMe() {
    return Row(
      children: [
        Checkbox(
          value: isChecked,
          onChanged: (value) {
            setState(() {
              isChecked = value!;
            });
          },
          checkColor: Colors.blue,
          fillColor: MaterialStateProperty.all(Colors.white),
        ),
        Text(
          AppLocalizations.of(context)!.translate("remind_me"),
          style: const TextStyle(
            fontFamily: 'PT-Sans',
            fontSize: 14,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButton() {
    return SizedBox(
      height: 40,
      width: double.infinity,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
            Colors.white,
          ),
          elevation: MaterialStateProperty.all(6),
          shape: MaterialStateProperty.all(
            const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
          ),
        ),
        child: Text(
          AppLocalizations.of(context)!.translate("do_login"),
          style: const TextStyle(
            fontFamily: 'PT-Sans',
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        onPressed: () {
          _processLogin(userController.text, userController.text);
        },
      ),
    );
  }

  Widget _buildLogoButton({
    required String image,
    required VoidCallback onPressed,
  }) {
    return FloatingActionButton(
      backgroundColor: Colors.white,
      onPressed: onPressed,
      child: SizedBox(
        height: 30,
        child: Image.asset(image),
      ),
    );
  }

  Widget _buildSocialButtons() {
    // return Row(
    //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //   children: [
    //     _buildLogoButton(
    //       image: 'assets/images/google_logo.png',
    //       onPressed: () {},
    //     ),
    //     _buildLogoButton(
    //       image: 'assets/images/apple_logo.png',
    //       onPressed: () {},
    //     ),
    //     _buildLogoButton(
    //       image: 'assets/images/facebook_logo.png',
    //       onPressed: () {},
    //     )
    //   ],
    // );
    return Container();
  }

  void _processLogin(String user, String pass) {
    setState(() {
      _isLoading = true;
    });

    HostLoginRequest().run(userController.text, "Aa1234567\$").then((response) {
      setState(() {
        _isLoading = false;
      });
      if (response.userId.isNotEmpty) {
        Session.user = User.fromHost(response);
        Session.socketSubscription =
            SocketSubscriptionController()
                .initializeSocketConnection();

        NavigatorApp.pushAndRemoveUntil(context, Home());
      } else {
        FlutterToast().showToast("Usuario/contraseña incorrectos");
      }
    }).onError((error, stackTrace) {
      FlutterToast().showToast("Error desconocido");
    });
  }

  @override
  void initState() {    
    super.initState();
    userController.text = "test@gmail.com";
  }
}
