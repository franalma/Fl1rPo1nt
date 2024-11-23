import 'package:app/ui/NavigatorApp.dart';
import 'package:app/ui/login/components/my_button.dart';
import 'package:app/ui/login/components/my_textfield.dart';
import 'package:app/ui/login/components/square_tile.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  void showmessage(String errorMessage) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(title: Text(errorMessage));
        });
  }

  void _signUserup(BuildContext context) async {
    if (_passwordController.text != _confirmPasswordController.text) {
      showmessage("La contraseña no coincide");
      return;
    }

    showDialog(
        context: context,
        builder: (context) {
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
              SizedBox(
                  height: 150,
                  width: 150,
                  child: Image.asset("assets/img/splash_icon.png")),
                                
              const SizedBox(height: 50),
              const Text(
                'Regístrate',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              MyTextField(
                controller: _emailController,
                hintText: 'Nombre',
                obscureText: false,
              ),
              const SizedBox(height: 10),
              MyTextField(
                controller: _phoneController,
                hintText: 'Teléfono',
                obscureText: false,
              ),
              const SizedBox(height: 10),
              MyTextField(
                controller: _passwordController,
                hintText: 'Contraseña',
                obscureText: true,
              ),
              const SizedBox(height: 10),
              MyTextField(
                controller: _confirmPasswordController,
                hintText: 'Confirma la contraseña',
                obscureText: true,
              ),

              const SizedBox(height: 25),
              MyButton(
                text: "Aceptar",
                onTap: () => _signUserup(context),
              ),
              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '¿Ya tienes una cuenta?',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: () => NavigatorApp.pop(context),
                    child: const Text(
                      'Inicia sesión ahora',
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
}
