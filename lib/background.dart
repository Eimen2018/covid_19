// import 'package:background_fetch/background_fetch.dart';
import 'package:covid_19/app/locator.dart';
import 'package:covid_19/main.dart';
import 'package:covid_19/services/notification_service.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class Background extends StatefulWidget {
//   final Widget child;

//   const Background({Key key, this.child}) : super(key: key);
//   @override
//   _BackgroundState createState() => _BackgroundState();
// }

// class _BackgroundState extends State<Background> {
//   int _status = 0;
//   List<DateTime> _events = [];

//   @override
//   void initState() {
//     super.initState();
//     initPlatformState();
//   }

//   Future<void> initPlatformState() async {
//     // Configure BackgroundFetch.
//     BackgroundFetch.configure(
//         BackgroundFetchConfig(
//             minimumFetchInterval: 15,
//             stopOnTerminate: false,
//             enableHeadless: true,
//             requiresBatteryNotLow: false,
//             requiresCharging: false,
//             requiresStorageNotLow: false,
//             requiresDeviceIdle: false,
//             requiredNetworkType: NetworkType.ANY), (String taskId) async {
//       // This is the fetch-event callback.
//       print("[BackgroundFetch] Event received $taskId");
//       setState(() {
//         _events.insert(0, new DateTime.now());
//       });
//       // IMPORTANT:  You must signal completion of your task or the OS can punish your app
//       // for taking too long in the background.
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       if (prefs.getBool("isSwitched") != null && prefs.getBool("isSwitched")) {
//         if (checkSharedpreference(prefs) && checkTime()) {
//           notificationService.showNotificationReminder();
//         }
//         if (!checkSharedpreference(prefs)) {
//           List<String> b = await getnotificationStrings(prefs);
//           if (b.length > 0) notificationService.showNotification(b);
//         }
//       }
//       BackgroundFetch.finish(taskId);
//     }).then((int status) {
//       print('[BackgroundFetch] configure success: $status');
//       setState(() {
//         _status = status;
//       });
//     }).catchError((e) {
//       print('[BackgroundFetch] configure ERROR: $e');
//       setState(() {
//         _status = e;
//       });
//     });

//     // Optionally query the current BackgroundFetch status.
//     int status = await BackgroundFetch.status;
//     setState(() {
//       _status = status;
//     });

//     // If the widget was removed from the tree while the asynchronous platform
//     // message was in flight, we want to discard the reply rather than calling
//     // setState to update our non-existent appearance.
//     if (!mounted) return;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return widget.child;
//   }
// }

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:background_fetch/background_fetch.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// This "Headless Task" is run when app is terminated.

class Bg extends StatefulWidget {
  final Widget child;

  const Bg({Key key, this.child}) : super(key: key);
  @override
  _BgState createState() => new _BgState();
}

class _BgState extends State<Bg> {
  bool _enabled = true;
  int _status = 0;
  List<DateTime> _events = [];
  NotificationService notificationService = locator<NotificationService>();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    // Configure BackgroundFetch.
    BackgroundFetch.configure(
        BackgroundFetchConfig(
            startOnBoot: true,
            minimumFetchInterval: 15,
            stopOnTerminate: false,
            enableHeadless: true,
            requiresBatteryNotLow: false,
            requiresCharging: false,
            requiresStorageNotLow: false,
            requiresDeviceIdle: false,
            requiredNetworkType: NetworkType.NONE), (String taskId) async {
      // This is the fetch-event callback.
      print("[BackgroundFetch] Event received $taskId");
      setState(() {
        _events.insert(0, new DateTime.now());
      });
      // IMPORTANT:  You must signal completion of your task or the OS can punish your app
      // for taking too long in the background.
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (prefs.getBool("isSwitched") != null && prefs.getBool("isSwitched")) {
        if (checkSharedpreference(prefs) && checkTime()) {
          notificationService.showNotificationReminder();
        }
        if (!checkSharedpreference(prefs)) {
          Map<String, List<String>> notification =
              await getnotificationStrings(prefs);
          print(notification);
          if (notification.length > 0) {
            int id = 0;
            notification.forEach((key, value) {
              List<String> b = [key, value[0], value[1], value[2]];
              if (value[0] != "0") notificationService.showNotification(id, b);
              id += 1;
            });
          }
        }
      }
      BackgroundFetch.finish(taskId);
    }).then((int status) {
      print('[BackgroundFetch] configure success: $status');
      setState(() {
        _status = status;
      });
    }).catchError((e) {
      print('[BackgroundFetch] configure ERROR: $e');
      setState(() {
        _status = e;
      });
    });

    // Optionally query the current BackgroundFetch status.
    int status = await BackgroundFetch.status;
    setState(() {
      _status = status;
    });

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
  }

  void _onClickEnable(enabled) {
    setState(() {
      _enabled = enabled;
    });
    if (enabled) {
      BackgroundFetch.start().then((int status) {
        print('[BackgroundFetch] start success: $status');
      }).catchError((e) {
        print('[BackgroundFetch] start FAILURE: $e');
      });
    } else {
      BackgroundFetch.stop().then((int status) {
        print('[BackgroundFetch] stop success: $status');
      });
    }
  }

  void _onClickStatus() async {
    int status = await BackgroundFetch.status;
    print('[BackgroundFetch] status: $status');
    setState(() {
      _status = status;
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
