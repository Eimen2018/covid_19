import 'package:covid_19/app/locator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:injectable/injectable.dart';
import 'package:stacked_services/stacked_services.dart';

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

  // getnotificationeveryday(String cases, String title) async {
  //   var time = Time(14, 0, 0);
  //   var androidPlatformChannelSpecifics = AndroidNotificationDetails(
  //       'repeatDailyAtTime channel id',
  //       'Daily',
  //       'repeatDailyAtTime description');
  //   var iOSPlatformChannelSpecifics = IOSNotificationDetails();
  //   var platformChannelSpecifics = NotificationDetails(
  //       androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
  //   await flutterLocalNotificationsPlugin.showDailyAtTime(
  //       0, title, cases, time, platformChannelSpecifics);
  // }

  // String _toTwoDigitString(int value) {
  //   return value.toString().padLeft(2, '0');
  // }

  cancelNotification() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  showNotification(String cases) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails('Case_0',
        'Countries Watching', 'Getting Data\'s of the countries you selected',
        importance: Importance.Max, priority: Priority.High, ticker: 'ticker');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    print(cases.length);
    if (cases.length != 0) {
      await flutterLocalNotificationsPlugin.show(
          0, "Today Reported Cases", cases, platformChannelSpecifics,
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
