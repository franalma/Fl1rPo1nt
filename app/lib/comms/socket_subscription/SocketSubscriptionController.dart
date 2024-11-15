import 'package:app/model/Session.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:app/comms/model/HostContants.dart';

class SocketSubscriptionController {
  late IO.Socket socket;
  String serverMessage = "Waiting for updates...";

  late Function(String) onNewContactRequested; 

  

  SocketSubscriptionController initializeSocketConnection() {
    // Connect to the Node.js server
    socket = IO.io(HostActions.SOCKET_LISTEN.url, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
      'query': {'user_id': Session.user.userId},
    });

    // Listen for updates from the server
    socket.on('new_contact_request', (data) {
      onNewContactRequested(data); 
    });
    return this;
  }

 
}
