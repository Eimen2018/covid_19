import 'package:background_fetch/background_fetch.dart';
import 'package:covid_19/app/locator.dart';
import 'package:covid_19/app/router.gr.dart';
import 'package:covid_19/constant.dart';
import 'package:covid_19/enums/connectivity_status.dart';
import 'package:covid_19/services/connectivity_services.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:provider/provider.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:covid_19/background.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:covid_19/services/notification_service.dart';

NotificationService notificationService = locator<NotificationService>();
void backgroundFetchHeadlessTask(String taskId) async {
  print('[BackgroundFetch] Headless event received.');
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.getBool("isSwitched") != null && prefs.getBool("isSwitched")) {
    if (checkSharedpreference(prefs) && checkTime()) {
      notificationService.showNotificationReminder();
    }
    List<String> b = await getnotificationStrings(prefs);
    if (b.length > 0) notificationService.showNotification(b);
  }
  BackgroundFetch.finish(taskId);
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

Map<String, int> prevCase = Map();
getnotificationStrings(SharedPreferences prefs) async {
  List a;
  List<String> b = [];
  try {
    http.Response response = await http.get('https://disease.sh/v2/countries');
    a = json.decode(response.body);
    prefs.getStringList('notificationcountry').forEach((element) {
      var c = a.firstWhere((e) => (e['country'].toString() == element));
      if (c['todayCases'] != prevCase[element] && c['todayCases'] != 0) {
        prevCase[element] = c['todayCases'];
        b = [element, c['todayCases'], c['todayDeaths'], c['todayRecovered']];
      }
    });
  } catch (e) {
    print(e);
    getnotificationStrings(prefs);
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
          child: Background(
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
