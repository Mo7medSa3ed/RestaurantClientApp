import 'package:socket_io_client/socket_io_client.dart';

class Socket {
  static final socket =
      io('https://restaurant-api-xj7i.onrender.com/', <String, dynamic>{
    'transports': ['websocket'],
    'autoConnect': true,
  });
}
