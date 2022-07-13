import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/data/api/resto_api_service.dart';
import 'package:restaurant/provider/resto_provider.dart';
import 'package:restaurant/ui/restaurant_detail_Page.dart';
import 'package:restaurant/ui/restaurant_list_page.dart';
import 'package:restaurant/ui/settings_Page.dart';
import 'package:restaurant/utils/notification_helper.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/home_page';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // for notification
  final NotificationHelper _notificationHelper = NotificationHelper();

  @override
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

  // bottom navigation bar
  int _bottomNavIndex = 0;
  static const String _headline = 'Restaurants';
  static const String _settings = 'Settings';

  final List<BottomNavigationBarItem> _bottomNavBarItems = [
    const BottomNavigationBarItem(
        icon: Icon(Icons.restaurant),
      label: _headline
    ),
    const BottomNavigationBarItem(
        icon: Icon(Icons.settings),
      label: _settings
    ),
  ];

  void _onBottomNavTapped(int index) {
    setState(() {
      _bottomNavIndex = index;
    });
  }

  // main widget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _bottomNavIndex == 0
          ? ChangeNotifierProvider<RestoProvider>(
            create: (_) => RestoProvider(restoApiService: RestoApiService()),
            child: const RestaurantListPage(),
            )
          : SettingsPage(notificationHelper: _notificationHelper),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _bottomNavIndex,
        items: _bottomNavBarItems,
        onTap: _onBottomNavTapped,
      ),
    );
  }
}
