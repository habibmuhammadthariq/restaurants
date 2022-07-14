import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:restaurant/utils/background_service.dart';
import 'package:restaurant/utils/date_time_helper.dart';

class SchedullingProvider extends ChangeNotifier {
  bool _isScheduled = false;

  bool get isScheduled => _isScheduled;

  Future<bool> scheduledNews(bool value) async {
    _isScheduled = value;
    if(_isScheduled) {
      print('Hidupkan reminder');
      notifyListeners();
      return await AndroidAlarmManager.periodic(
        const Duration(hours: 24),
        0,
        BackgroundService.callback,
        startAt: DateTimeHelper.format(),
        exact: true,
        wakeup: true
      );
    } else {
      print('Yaah remindernya kok dimatiin gan');
      notifyListeners();
      return await AndroidAlarmManager.cancel(1);
    }
  }
}