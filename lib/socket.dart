import 'package:socket_io_client/socket_io_client.dart';

class Socket {
  final socket = io('https://resturant-app12.herokuapp.com', <String, dynamic>{
    'transports': ['websocket'],
    'autoConnect': true,
  });
}
