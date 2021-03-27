import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class TestScrean extends StatefulWidget {
  @override
  _TestScreanState createState() => _TestScreanState();
}

class _TestScreanState extends State<TestScrean> {
  @override
  void initState() {
    super.initState();
  }

  io() {
   
    IO.Socket socket = IO.io('http://127.0.0.1:9092/chat?token=abc123',
        IO.OptionBuilder().setTransports(['polling', 'websocket']).build());
  
    socket.connect();
    print(socket.connected);
    /*  socket.onError((data) => print(data));
    socket.onConnectError((data) => print(data)); */
   // socket.on("connect", (data) => print("Mohamed Saeed Add dish"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        alignment: Alignment.center,
        child: RaisedButton(
          onPressed: () {io();},
          
        ),
      ),
    );
  }
}


/* 
io() {
    IO.Socket socket = IO.io('http://192.168.1.7:9092/chat?token=abc123',
        IO.OptionBuilder().setTransports(['polling', 'websocket']).build());
   /*  socket.disconnect();
   socket.destroy();  */
    socket.connect();
    print(socket.connected);
   /*  socket.onError((data) => print(data));
    socket.onConnectError((data) => print(data)); */
    socket.on("connect", (data) => print("Mohamed Saeed Add dish"));
  } */