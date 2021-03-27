import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resturantapp/constants.dart';
import 'package:resturantapp/provider/appdata.dart';
import 'package:resturantapp/provider/special.dart';
import 'package:resturantapp/screans/splashScrean.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

void main() {
  runApp(MyApp());
  io();
}

io() {
  IO.Socket socket = IO.io('https://resturant-app12.herokuapp.com/',
      IO.OptionBuilder().setTransports(['websocket']).build());
  socket.connect();
  socket.on("newDish", (data) => print("Mohamed Saeed Add dish"));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<Specials>(
            create: (context) => Specials(),
          ),
          ChangeNotifierProvider<AppData>(
            create: (context) => AppData(),
          ),
        ],
        child: MaterialApp(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            dialogBackgroundColor: Colors.white,
            colorScheme: ColorScheme.light(primary: red),
            highlightColor: Colors.grey[400],
            fontFamily: 'Montserrat',
            textTheme: TextTheme(
                bodyText2: TextStyle(color: grey, fontWeight: FontWeight.w600)),
            primaryColor: Kprimary,
            accentColor: Kprimary,
            hintColor: Colors.grey,
            cursorColor: red,
            scaffoldBackgroundColor: Colors.white.withOpacity(0.97),
            appBarTheme: AppBarTheme(
              brightness: Brightness.dark,
              iconTheme: IconThemeData(color: Kprimary.withOpacity(0.6)),
              elevation: 0,
              color: Colors.white.withOpacity(0.4),
            ),
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: SplashScrean(),
        ));
  }
}
