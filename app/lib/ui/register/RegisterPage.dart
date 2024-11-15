import 'package:app/comms/model/request/auth/HostRegisterRequest.dart';
import 'package:app/ui/utils/toast_message.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _RegisterPage();
  }
}

class _RegisterPage extends State<RegisterPage> {
  final _usernameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmation = TextEditingController();
  final countries = ["España", "Portual"];
  final cities = ["Madrid", "Barcelona"];
  String selectedCountry = "";
  String selectedCity = ""; 

  @override
  Widget build(BuildContext context) {
    selectedCountry = countries[0];
    selectedCity = cities[0];
    return Scaffold(
      appBar: AppBar(title: Text('Registro')),
      body: Padding(      
        padding: EdgeInsets.all(16.0),
        child: Form(
          // key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(labelText: 'Nombre'),          
              ),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: 'Teléfono'),              
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Correo electrónico'),
                keyboardType: TextInputType.emailAddress,
                // validator: (value) {
                //   if (value == null || value.isEmpty) {
                //     return 'Por favor ingresa tu correo electrónico';
                //   } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                //     return 'Ingresa un correo electrónico válido';
                //   }
                //   return null;
                // },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Contraseña'),
                obscureText: true,                
              ),
              TextFormField(
                controller: _passwordConfirmation,
                decoration: InputDecoration(labelText: 'Confirmar contraseña'),
                obscureText: true,                            
              ),
              DropdownButton<String>(
                // Valor seleccionado
                value: selectedCountry,
                hint: Text('Seleccione una opción'),
                // Lista de opciones
                items: countries.map((String item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Text(item),
                  );
                }).toList(),
                // Cuando el usuario selecciona una opción
                onChanged: (String? newValue) {
                  setState(() {
                    selectedCountry = newValue!;
                  });
                },
              ),
               DropdownButton<String>(
                // Valor seleccionado
                value: selectedCity,
                hint: Text('Seleccione una opción'),
                // Lista de opciones
                items: cities.map((String item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Text(item),
                  );
                }).toList(),
                // Cuando el usuario selecciona una opción
                onChanged: (String? newValue) {
                  setState(() {
                    selectedCity = newValue!;
                  });
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  String name = _usernameController.text; 
                  String phone = _phoneController.text; 
                  String email = _emailController.text; 
                  String pass = _passwordController.text; 
                  String passConfirmation = _passwordConfirmation.text; 
                  String country = selectedCountry;
                  String city = selectedCity; 
                  if (name.isEmpty){
                   FlutterToast().showToast("Debes indicar un nombre"); 
                  } else if (phone.isEmpty){
                    FlutterToast().showToast("Debes indicar un número de teléfono"); 
                  }else if (email.isEmpty){
                    FlutterToast().showToast("Debes indicar un email"); 
                  }else if (pass.isEmpty){
                    FlutterToast().showToast("Debes indicar una contraseña"); 
                  }else if (pass != passConfirmation){
                    FlutterToast().showToast("Confirmación de contraseña errónea"); 
                  }

                  HostRegisterRequest().run(name, "",phone, email, pass, country, city).then((value){
                      if (value.id.isEmpty){
                        FlutterToast().showToast("Error el proceso, revisa los campos");
                      }else{
                          print ("Register response");
                      }
                        
                  });
                },
                child: Text('Registrarse'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
