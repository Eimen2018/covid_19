import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class NotificationService {
  // NavigationService _navigationService = locator<NavigationService>();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  var initializationSettingsIOS;
  var initializationSettingsAndroid;
  var initializationSettings;

  void initialize() async {
    initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
    initializationSettingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification);
  }

  Future selectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
    // _navigationService.navigateTo('/setting');
  }

  cancelNotification() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  showNotificationReminder() async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails('Case_0',
        'Countries Watching', 'Getting Data\'s of the countries you selected',
        importance: Importance.Max, priority: Priority.High, ticker: 'ticker');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0,
        "Reminder",
        "Select A Country in Settings to Recieve Today Report Notification",
        platformChannelSpecifics,
        payload: "country");
  }

  showNotification(int id, List<String> cases) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails('Case_0',
        'Countries Watching', 'Getting Data\'s of the countries you selected',
        importance: Importance.Max, priority: Priority.High, ticker: 'ticker');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    if (cases.length > 0) {
      await flutterLocalNotificationsPlugin.show(
          id,
          "${cases[0]} Reported Now",
          "${cases[1]} cases ${cases[2]} deaths ${cases[3]} recovered",
          platformChannelSpecifics,
          payload: "country");
    }
  }

  Future onDidReceiveLocalNotification(
      int id, String title, String body, String payload) {
    BuildContext context;
    return showDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(body),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: Text('Ok'),
            onPressed: () async {
              Navigator.of(context, rootNavigator: true).pop();
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }
}
