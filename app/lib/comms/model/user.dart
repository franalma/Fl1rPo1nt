import 'dart:convert';

class User {
  late String userId; 
  late String name;
  late String phone; 
  late String email; 
  late String city; 
  late String country; 
  late String token;
  late double latitude; 
  late double longitude; 
  
  late String refreshToken;

  User(this.userId, this.name, this.phone, this.email, this.city, this.country, this.token, this.refreshToken);

}
