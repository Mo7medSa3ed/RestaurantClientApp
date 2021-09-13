import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:resturantapp/constants.dart';
import 'package:resturantapp/models/categorys.dart';
import 'package:resturantapp/models/dish.dart';
import 'package:resturantapp/notification.dart';
import 'package:resturantapp/provider/appdata.dart';
import 'package:resturantapp/provider/special.dart';
import 'package:resturantapp/screans/alldishes.dart';
import 'package:resturantapp/screans/details.dart';
import 'package:resturantapp/screans/ordertimeline.dart';
import 'package:resturantapp/screans/splashScrean.dart';
import 'package:resturantapp/socket.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  if (!(Socket().socket.connected)) {
    Socket().socket.connect();
  }
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider<Specials>(
      create: (context) => Specials(),
    ),
    ChangeNotifierProvider<AppData>(
      create: (context) => AppData(),
    ),
  ], child: MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static const channel = MethodChannel("notification");

  void getNotificationDataIfExist() async {
    final notificationData = await channel.invokeMethod("getNotification");
     final type = notificationData.split('/')[0];
    final id = notificationData.split('/')[1];
      switch (type) {
      case 'dish':
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (_) => DetailsScrean(id)));
        break;
      case 'category':
      Navigator.of(context)
            .push(MaterialPageRoute(builder: (_) => AllDishScrean(type,catId: id,)));
        break;
      case 'orderConfirmed':
      Navigator.of(context)
            .push(MaterialPageRoute(builder: (_) => OrderTimeLine()));
        break;
    }
  }

  @override
  void initState() {
    getNotificationDataIfExist();
    Socket().socket.on('newDish', (data) async {
      final pro = Provider.of<AppData>(context, listen: false);
      data['category'] = pro.getCategoryById(data['category']);
      final dish = Dish.fromJson(data);
      pro.addNewDish(dish);
      await notificationPlugin.showNotification(Random().nextInt(1000),
          'admin add new Dish', '${dish.name}\n${dish.desc}', dish.id, 'dish');
    });

    Socket().socket.on('updateDish', (data) async {
      final pro = Provider.of<AppData>(context, listen: false);
      data['category'] = pro.getCategoryById(data['category']);
      final dish = Dish.fromJson(data);
      pro.updateDish(dish);
      await notificationPlugin.showNotification(Random().nextInt(1000),
          'admin update Dish', '${dish.name}\n${dish.desc}', dish.id, 'dish');
    });

    Socket().socket.on('deleteDish', (data) async {
      print(data);
      final pro = Provider.of<AppData>(context, listen: false);
      pro.removeDish(data['_id']);
      await notificationPlugin.showNotification(
          Random().nextInt(1000),
          'admin delete ${data['name']}',
          '${data['desc']}',
          data['_id'],
          'delete');
    });

    Socket().socket.on('newCategory', (data) async {
      print(data);
      final pro = Provider.of<AppData>(context, listen: false);
      pro.addCategory(Categorys.fromJson(data));
      await notificationPlugin.showNotification(Random().nextInt(1000),
          'admin add new category', '${data['name']}', data['_id'], 'category');
    });

    Socket().socket.on('updateCategory', (data) async {
      print(data);
      final pro = Provider.of<AppData>(context, listen: false);
      pro.updateCategory(Categorys.fromJson(data));
      await notificationPlugin.showNotification(Random().nextInt(1000),
          'admin update category', '${data['name']}', data['_id'], 'category');
    });

    Socket().socket.on('deleteCategory', (data) async {
      print(data);
      final pro = Provider.of<AppData>(context, listen: false);
      pro.removeCategory(data['_id']);
      await notificationPlugin.showNotification(Random().nextInt(1000),
          'admin removed ${data['name']}', '', data['_id'], 'delete');
    });

    Socket().socket.on('orderConfirmedByDelivery', (data) async {
      final pro = Provider.of<AppData>(context, listen: false);
      pro.updateOrder(data['updatedOrder']);
      if (data['updatedOrder']['state'] == 'confirmed') {
        await notificationPlugin.showNotification(
            Random().nextInt(1000),
            'Delivery Confirmed your Order',
            'you can now track your order',
            data['_id'],
            'orderConfirmed');
      } else if (data['updatedOrder']['state'] == 'canceled') {
        if (pro.loginUser.id != data['updatedOrder']['user']['_id'])
          await notificationPlugin.showNotification(
              Random().nextInt(1000),
              'cancel order by admin',
              'admin canceled your order',
              data['_id'],
              'order');
      }
    });

    Socket().socket.on('deliveryLocationChanged', (data) async {
      final pro = Provider.of<AppData>(context, listen: false);
      pro.updateOrderLocation(data['updatedOrder']);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Resturant App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
              fontFamily: 'Montserrat',
              // ignore: deprecated_member_use
              accentColor: Kprimary,
              primaryColor: Kprimary)
          .copyWith(
        dialogBackgroundColor: Colors.white,
        colorScheme: ThemeData().colorScheme.copyWith(
              secondary: Kprimary,
              primary: red,
            ),
        primaryColor: Kprimary,
        highlightColor: Colors.grey[400],
        hintColor: Colors.grey,
        textSelectionTheme: TextSelectionThemeData(cursorColor: red),
        scaffoldBackgroundColor: white.withOpacity(0.97),
        appBarTheme: AppBarTheme(
          // ignore: deprecated_member_use
          brightness: Brightness.dark,
          iconTheme: IconThemeData(color: Kprimary.withOpacity(0.6)),
          elevation: 0,
          color: Colors.white.withOpacity(0.4),
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SplashScrean(),
    );
  }
}
