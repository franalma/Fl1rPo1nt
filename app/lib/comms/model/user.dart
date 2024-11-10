import 'dart:convert';

class User {
  late String name;
  late String token;
  late String refreshToken;

  User(this.name, this.token, this.refreshToken);


  // static User fromJson(input) {
  //   var value = jsonDecode(input);
  //   User user = User();
  //   user.name = "fran";
  //   user.token = value["token"];
  //   user.refreshToken = value ["refreshToken"];
  //   return user; 
  // }
}
