import 'package:app/comms/model/request/auth/HostRegisterRequest.dart';
import 'package:app/model/HostErrorCode.dart';
import 'package:app/ui/NavigatorApp.dart';
import 'package:app/ui/elements/AlertDialogs.dart';
import 'package:app/ui/elements/DefaultModalDialog.dart';
import 'package:app/ui/login/LoginPage.dart';
import 'package:app/ui/elements/my_button.dart';
import 'package:app/ui/elements/my_textfield.dart';
import 'package:app/ui/utils/Log.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final TextEditingController _dateController = TextEditingController();

  DateTime? _selectedDate;

  bool isValidPass(String pass) {
    final RegExp passwordRegex = RegExp(
      r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$',
    );
    return passwordRegex.hasMatch(pass);
  }

  bool isValidPhoneNumber(String phone) {
    final RegExp phoneRegex = RegExp(r'^\d{9,15}$'); // 10 to 15 digits allowed
    return phoneRegex.hasMatch(phone);
  }

  bool isValidEmail(String email) {
    final RegExp emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  void showLoadingModal() {
    showDialog(
        context: context,
        builder: (context) {
          return const Center(child: CircularProgressIndicator());
        });
  }

  void _signUserup(BuildContext context) async {
    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      _showAllFieldsRequired();
      return;
    }

    if (_nameController.text.length < 4) {
      _showValidNameRequired();
      return;
    }

    if (!isValidPass(_passwordController.text)) {
      _showPasswordRequirements();
      return;
    }
    if (_passwordController.text != _confirmPasswordController.text) {
      _showPasswordMissmatch();
      return;
    }
    if (!isValidEmail(_emailController.text)) {
      _showValidMailRequired();
      return;
    }

    if (!isValidPhoneNumber(_phoneController.text)) {
      _showValidPhoneNumberRequired();
      return;
    }

    if (!isValidDate(_selectedDate)) {
      DefaultModalDialog.showErrorDialog(context, "Indica fecha de nacimiento válida", "Cerrar", FontAwesomeIcons.exclamation);
      return;
    }

    await _sendToHost();
  }

  bool isValidDate(DateTime? dateTime) {
    if (dateTime == null) return false;
    DateTime today = DateTime.now();
    if (dateTime.isAfter(today)) return false;
    if (dateTime.year == today.year &&
        dateTime.month == today.month &&
        dateTime.day == today.day) return false;
    if (today.year - dateTime.year < 18) return false;
    return true;
  }

  void _showAllFieldsRequired() {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return Wrap(children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              height: 200,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    FontAwesomeIcons.circleExclamation,
                    size: 40,
                    color: Colors.red,
                  ),
                  const Text(
                    "Debes rellenar todos los campos",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the bottom sheet
                    },
                    child: const Text('Cerrar'),
                  ),
                ],
              ),
            ),
          ]);
        });
  }

  void _showPasswordRequirements() {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return Wrap(children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              height: 300,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    FontAwesomeIcons.circleExclamation,
                    size: 10,
                    color: Colors.red,
                  ),
                  const Text(
                    "La contraseña no es segura. Asegúrate de que cumple con los siguientes requisitos:",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    "- Longitud mayor o igual a 9 caracteres",
                    style: TextStyle(fontSize: 14),
                  ),
                  const Text(
                    "- Al menos una mayúscula o minúsculas",
                    style: TextStyle(fontSize: 14),
                  ),
                  const Text(
                    "- Al menos un dígito",
                    style: TextStyle(fontSize: 14),
                  ),
                  const Text(
                    "- Al menos un caracter especial",
                    style: TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the bottom sheet
                    },
                    child: const Text('Cerrar'),
                  ),
                ],
              ),
            ),
          ]);
        });
  }

  void _showPasswordMissmatch() {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return Wrap(children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              height: 200,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    FontAwesomeIcons.circleExclamation,
                    size: 40,
                    color: Colors.red,
                  ),
                  const Text(
                    "La contraseña no coincide",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the bottom sheet
                    },
                    child: const Text('Cerrar'),
                  ),
                ],
              ),
            ),
          ]);
        });
  }

  void _showValidMailRequired() {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return Wrap(children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              height: 200,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    FontAwesomeIcons.circleExclamation,
                    size: 40,
                    color: Colors.red,
                  ),
                  const Text(
                    "Introduce un correo válido",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the bottom sheet
                    },
                    child: const Text('Cerrar'),
                  ),
                ],
              ),
            ),
          ]);
        });
  }

  void _showValidNameRequired() {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return Wrap(children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              height: 200,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    FontAwesomeIcons.circleExclamation,
                    size: 40,
                    color: Colors.red,
                  ),
                  const Text(
                    "Introduce un nombre válido",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the bottom sheet
                    },
                    child: const Text('Cerrar'),
                  ),
                ],
              ),
            ),
          ]);
        });
  }

  void _showValidPhoneNumberRequired() {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return Wrap(children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              height: 200,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    FontAwesomeIcons.circleExclamation,
                    size: 40,
                    color: Colors.red,
                  ),
                  const Text(
                    "Introduce un teléfono válido",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the bottom sheet
                    },
                    child: const Text('Cerrar'),
                  ),
                ],
              ),
            ),
          ]);
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
              GestureDetector(
                onDoubleTap: () {
                  _nameController.text = "Fran";
                  _emailController.text = "test@floiint.com";
                  _phoneController.text = "676404766";
                  _passwordController.text = "Aa123456\$";
                  _confirmPasswordController.text = "Aa123456\$";
                },
                child: SizedBox(
                    height: 20,
                    width: 20,
                    child: Image.asset("assets/img/splash_icon.png")),
              ),
              const SizedBox(height: 30),
              GestureDetector(
                onDoubleTap: () {
                  _nameController.text = "Fran2";
                  _emailController.text = "test2@floiint.com";
                  _phoneController.text = "676404766";
                  _passwordController.text = "Aa123456\$";
                  _confirmPasswordController.text = "Aa123456\$";
                },
                child: const Text(
                  'Regístrate',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 10),
              MyTextField(
                controller: _nameController,
                hintText: 'Nombre',
                obscureText: false,
              ),
              const SizedBox(height: 10),
              MyTextField(
                controller: _emailController,
                hintText: 'eMail',
                obscureText: false,
              ),
              const SizedBox(height: 10),
              MyTextFieldNumber(
                controller: _phoneController,
                hintText: 'Teléfono',
                obscureText: false,
              ),
              const SizedBox(height: 10),
              _buildBornDataPicker(),
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

  Future<void> _sendToHost() async {
    Log.d("Starts _sendToHost");
    String name = _nameController.text;
    String phone = _phoneController.text;
    String email = _emailController.text;
    String pass = _passwordController.text;

    const TextStyle styleMessages =
        TextStyle(fontSize: 18, fontWeight: FontWeight.bold);
    showLoadingModal();
    HostRegisterRequest()
        .run(name, phone, email, pass, _selectedDate!.millisecondsSinceEpoch)
        .then((response) {
      var hostCode = HostErrorCodesValue.parse(response.hostErrorCode!.code);
      NavigatorApp.pop(context);
      switch (hostCode) {
        case HostErrorCodesValue.NoError:
          {
            AlertDialogs().showModalDialogMessage(
                context,
                250,
                FontAwesomeIcons.check,
                40,
                const Color.fromARGB(245, 3, 203, 30),
                "¡Enhorabuena! Te has registrado correctamente. Revisa tu correo para activar tu cuenta",
                styleMessages,
                "Cerrar",
                LoginPage2());
            break;
          }
        case HostErrorCodesValue.UserExist:
          {
            AlertDialogs().showModalDialogMessage(
                context,
                200,
                FontAwesomeIcons.circleExclamation,
                40,
                Colors.red,
                "Ya existe una cuante para este usuario",
                styleMessages,
                "Cerrar");
            break;
          }
        case HostErrorCodesValue.WrongUserPass:
          {
            AlertDialogs().showModalDialogMessage(
                context,
                200,
                FontAwesomeIcons.circleExclamation,
                40,
                Colors.red,
                "Usuario/contraseña erróneos",
                styleMessages,
                "Cerrar");
            break;
          }
        default:
          {}
      }
    });
  }

  Widget _buildBornDataPicker() {
    // Display selected date or placeholder text
    var today = DateTime.now();
    return Column(
      children: [
        MyTextField(
            isEditable: true,
            buttonIcon: IconButton(
              icon: const Icon(Icons.calendar_month),
              onPressed: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: today, // Default initial date
                  firstDate: DateTime(1900), // Earliest date
                  lastDate: DateTime.now(), // Latest date
                  helpText: "Fecha de nacimiento",
                );

                if (pickedDate != null && pickedDate != _selectedDate) {
                  setState(() {
                    _selectedDate = pickedDate;
                    _dateController.text =
                        _selectedDate!.toLocal().toString().split(' ')[0];
                  });
                }
              },
            ),
            controller: _dateController,
            hintText: "Fecha de nacimiento",
            obscureText: false),
      ],
    );
  }
}
