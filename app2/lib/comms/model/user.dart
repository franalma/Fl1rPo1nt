import 'dart:convert';

class User {
  late String name;
  late String phone; 
  late String email; 
  late String city; 
  late String country; 
  late String token;
  
  late String refreshToken;

  User(this.name, this.phone, this.email, this.city, this.country, this.token, this.refreshToken);


  // static User fromJson(input) {
  //   var value = jsonDecode(input);
  //   User user = User();
  //   user.name = "fran";
  //   user.token = value["token"];
  //   user.refreshToken = value ["refreshToken"];
  //   return user; 
  // }
}
