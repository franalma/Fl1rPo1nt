import 'package:app/ui/utils/Log.dart';

class Gender{
  int? id; 
  String? name; 
  String? color; 

  Gender (this.id, this.name, this.color);
  Gender.empty(); 

  factory Gender.fromJson(Map<String, dynamic>json){
    try{
        return Gender (json["id"], json["name"], json["color"]);
    }catch(error, stackTrace){
      Log.d("$error -- $stackTrace");
    }
    return Gender.empty(); 
  }
}