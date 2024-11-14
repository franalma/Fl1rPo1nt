import 'package:app/model/Flirt.dart';

class HostPutFlirtByUserIdResponse{

  Flirt? flirt; 

  HostPutFlirtByUserIdResponse (this.flirt);
  HostPutFlirtByUserIdResponse.empty(); 

  factory HostPutFlirtByUserIdResponse.fromJson(){
      return HostPutFlirtByUserIdResponse.empty();
  }

}