import 'package:app/services/NotificationService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late WebSocketChannel _channel;
  NotificationService notificationService = NotificationService(); 
  @override
  void initState() {
    super.initState();

    // Connect to WebSocket server
    _channel = WebSocketChannel.connect(
      Uri.parse('wss://your-websocket-server-url'),
    );

    // Listen to messages from the server
    _channel.stream.listen((message) {
      print('Message received: $message');
      // _showNotification(message);
    });
  }

  @override
  void dispose() {
    _channel.sink.close();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Socket Notifications")),
      body: Center(child: Text("Listening for WebSocket messages...")),
    );
  }
}