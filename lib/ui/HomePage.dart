import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/data/api/resto_api_service.dart';
import 'package:restaurant/provider/resto_provider.dart';
import 'package:restaurant/ui/restaurant_detail_Page.dart';
import 'package:restaurant/ui/restaurant_list_page.dart';
import 'package:restaurant/utils/notification_helper.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/home_page';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final NotificationHelper _notificationHelper = NotificationHelper();

  void initState() {
    super.initState();
    _notificationHelper.configureSelectNotificationSubject(context, RestaurantDetailPage.routeName); // this page need `id` as parameter
    _notificationHelper.configureDidReceiveLocalNotificationSubject(context, RestaurantDetailPage.routeName); // of course this too
  }

  void dispose() {
    selectNotificationSubject.close();
    didReceiveLocalNotificationSubject.close();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RestoProvider>(
      create: (_) => RestoProvider(restoApiService: RestoApiService()),
      child: RestaurantListPage(notificationHelper: _notificationHelper),
    );
  }
}
