import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:restaurant/data/model/restaurant.dart';
import 'package:restaurant/ui/favorite_page.dart';
import 'package:restaurant/ui/restaurant_detail_Page.dart';
import 'package:restaurant/ui/HomePage.dart';
import 'package:restaurant/ui/search_page.dart';
import 'package:restaurant/utils/notification_helper.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final NotificationHelper notificationHelper = NotificationHelper();

  await notificationHelper.initNotifications(flutterLocalNotificationsPlugin);
  notificationHelper.requestIOSPermissions(flutterLocalNotificationsPlugin);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Restaurant App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: HomePage.routeName,
      routes: {
        HomePage.routeName: (context) => HomePage(),
        RestaurantDetailPage.routeName: (context) => RestaurantDetailPage(
            id: ModalRoute.of(context)?.settings.arguments as String
        ),
        SearchPage.routeName: (context) => SearchPage(),
        FavoritePage.routeName: (context) => FavoritePage(
          restaurant: ModalRoute.of(context)?.settings.arguments as List<Restaurant>,
        ),
      },
    );
  }
}
