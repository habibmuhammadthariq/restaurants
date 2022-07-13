import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../data/model/restaurant.dart';
import '../main.dart';
import '../utils/notification_helper.dart';

class SettingsPage extends StatefulWidget {
  final NotificationHelper notificationHelper;

  const SettingsPage({
    Key? key,
    required this.notificationHelper
  }) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isSwitch = false;

  Restaurant restaurant = Restaurant(
      id: "rqdv5juczeskfw1e867",
      name: "Melting Pot",
      description: "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo. Nullam dictum felis eu pede mollis pretium. Integer tincidunt. Cras dapibus. Vivamus elementum semper nisi. Aenean vulputate eleifend tellus. Aenean leo ligula, porttitor eu, consequat vitae, eleifend ac, enim. Aliquam lorem ante, dapibus in, viverra quis, feugiat a, tellus. Phasellus viverra nulla ut metus varius laoreet.",
      pictureId: "14",
      city: "Medan",
      rating: 4.2
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings Page'),
      ),
      body: ListView(
        children: [
          Material(
            child: ListTile(
              title: const Text('Restaurant Notification'),
              trailing: Switch.adaptive(
                  value: isSwitch,
                  onChanged: (value) async {
                    setState(() {
                      isSwitch = value;
                      print('Saat ini true/ false ? $isSwitch');
                    });

                    if (isSwitch == true) {
                      await widget.notificationHelper.scheduleNotification(
                          flutterLocalNotificationsPlugin,
                          //restaurant // temporary. it should be random restaurant
                      );
                      print('Hidupkan reminder');
                    } else {
                      await flutterLocalNotificationsPlugin.cancel(0);
                      print('Yaah remindernya kok dimatiin gan');
                    }
                  },
              ),
            ),
          )
        ],
      ),
    );
  }
}