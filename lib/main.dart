import 'dart:convert';
import 'package:background_fetch/background_fetch.dart';
import 'package:covid_19/app/locator.dart';
import 'package:covid_19/app/router.gr.dart';
import 'package:covid_19/constant.dart';
import 'package:covid_19/enums/connectivity_status.dart';
import 'package:covid_19/services/connectivity_services.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:provider/provider.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:covid_19/background.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

const EVENTS_KEY = "fetch_events";

void backgroundFetchHeadlessTask(String taskId) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  print('[BackgroundFetch] Headless event received.');
  if (prefs.getBool("isSwitched") != null && prefs.getBool("isSwitched")) {
    if (checkSharedpreference(prefs) && checkTime()) {
      showNotificationReminder();
    }
    if (!checkSharedpreference(prefs)) {
      Map<String, List<String>> notification =
          await getnotificationStrings(prefs);
      if (notification.length > 0) {
        int id = 0;
        notification.forEach((key, value) {
          List<String> b = [key, value[0], value[1], value[2]];
          if (value[0] != "0") showNotification(id, b);
          id += 1;
        });
      }
    }
  }
  // showNotification(["Hello", "Aymen", "Nur","Ibrahim"]);
  BackgroundFetch.finish(taskId);
}

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
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

bool checkTime() {
  TimeOfDay now = TimeOfDay.now();
  int nowInMinutes = now.hour * 60;
  TimeOfDay eight = TimeOfDay(hour: 14, minute: 0);
  int eightInMinutes = eight.hour * 60;
  TimeOfDay nine = TimeOfDay(hour: 15, minute: 0);
  int nineInMinutes = nine.hour * 60;
  return (nowInMinutes > eightInMinutes && nowInMinutes < nineInMinutes);
}

int trial = 0;
Future getnotificationStrings(SharedPreferences prefs) async {
  List a;
  Map<String, List<String>> b = Map();
  List<String> countryFound = prefs.getStringList("prevcases");
  try {
    http.Response response = await http.get('https://disease.sh/v2/countries');
    a = json.decode(response.body);
    print(countryFound);
    prefs.getStringList('notificationcountry').forEach((element) async {
      var c = a.firstWhere((e) => (e['country'].toString() == element));
      String data =
          countryFound.firstWhere((element) => element.contains(c['country']));
      List<String> dataNumber = data.split("-");
      if (c['todayCases'] != int.parse(dataNumber[dataNumber.length - 1])) {
        int index = countryFound.indexOf(countryFound
            .firstWhere((element) => element.contains(c['country'])));
        countryFound[index] = "${c['country']}-${c['todayCases']}";
        b[element] = [
          c['todayCases'].toString(),
          c['todayDeaths'].toString(),
          c['todayRecovered'].toString()
        ];
        // b = [
        //   element,
        //   c['todayCases'].toString(),
        //   c['todayDeaths'].toString(),
        //   c['todayRecovered'].toString()
        // ];
        await prefs.setStringList('prevcases', countryFound);
      }
    });
  } catch (e) {
    print(e);
    if (trial < 3) {
      trial++;
      getnotificationStrings(prefs);
    }
  }
  return b;
}

bool checkSharedpreference(SharedPreferences prefs) {
  return (prefs.getStringList('notificationcountry') == null ||
      prefs.getStringList('notificationcountry').length == 0);
}

void main() {
  setupLocator();
  runApp(MyApp());
  BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarColor(Colors.transparent);
    FlutterStatusbarcolor.setStatusBarWhiteForeground(true);

    return DynamicTheme(
      data: (brightness) {
        return ThemeData(
            appBarTheme: AppBarTheme(brightness: Brightness.dark),
            hintColor: Colors.grey,
            primaryColor: kPrimaryColor,
            scaffoldBackgroundColor: brightness == Brightness.dark
                ? Colors.black87
                : kBackgroundColor,
            fontFamily: "Poppins",
            textTheme: TextTheme(headline6: TextStyle(color: Colors.black87)),
            brightness: brightness);
      },
      themedWidgetBuilder: (context, theme) {
        return StreamProvider<ConnectivityStatus>(
          create: (context) =>
              ConnectivityService().connectionStatusController.stream,
          child: Bg(
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Covid 19',
              theme: theme,
              initialRoute: Routes.homeView,
              onGenerateRoute: Router().onGenerateRoute,
              navigatorKey: locator<NavigationService>().navigatorKey,
              // darkTheme: ThemeData(scaffoldBackgroundColor: Colors.black87),
            ),
          ),
        );
      },
    );
  }
}
