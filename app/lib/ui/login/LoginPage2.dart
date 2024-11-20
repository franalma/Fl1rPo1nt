import 'package:app/comms/model/request/auth/HostLoginRequest.dart';
import 'package:app/comms/socket_subscription/SocketSubscriptionController.dart';
import 'package:app/model/Session.dart';
import 'package:app/model/User.dart';
import 'package:app/ui/NavigatorApp.dart';
import 'package:app/ui/home/home.dart';
import 'package:app/ui/login/components/my_button.dart';
import 'package:app/ui/login/components/my_textfield.dart';
import 'package:app/ui/login/components/square_tile.dart';
import 'package:app/ui/utils/toast_message.dart';
import 'package:flutter/material.dart';

class LoginPage2 extends StatefulWidget {
  final Function()? onTap;

  LoginPage2({super.key, required this.onTap});

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
          _processLogin("test@gmail.com","Aa1234567\$"); 
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
              // const Icon(Icons.lock, size: 100),
              SizedBox(
                  height: 150,
                  width: 150,
                  child: Image.asset("assets/img/splash_icon.png")),
              const SizedBox(height: 50),
              const Text(
                'Inicia sesión',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 25),
              MyTextField(
                controller: _emailController,
                hintText: 'Usuario',
                obscureText: false,
              ),
              const SizedBox(height: 10),
              MyTextField(
                controller: _passwordController,
                hintText: 'Contraseña',
                obscureText: true,
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    '¿Has olvidado la contraseña?',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),
              ),
              const SizedBox(height: 25),
              MyButton(
                text: "Login",
                onTap: () => _signUserIn(context),
              ),

              const SizedBox(height: 70),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '¿No tienes cuenta?',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: const Text(
                      'Regístrate ahora',
                      style: TextStyle(
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


  void _processLogin(String user, String pass) {

    HostLoginRequest().run(user, pass).then((response) {
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
}
