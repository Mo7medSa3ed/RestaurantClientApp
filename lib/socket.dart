import 'package:socket_io_client/socket_io_client.dart';

class Socket {
  static final socket =
      io('https://a074-104-28-213-2.eu.ngrok.io/', <String, dynamic>{
    'transports': ['websocket'],
    'autoConnect': true,
  });
}
