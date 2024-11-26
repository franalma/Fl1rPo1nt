import 'package:app/ui/utils/Log.dart';

class Gender{
  int? id; 
  String? name; 

  Gender (this.id, this.name);
  Gender.empty(); 

  factory Gender.fromJson(Map<String, dynamic>json){
    try{
        return Gender (json["id"], json["name"]);
    }catch(error, stackTrace){
      Log.d("$error -- $stackTrace");
    }
    return Gender.empty(); 
  }
}