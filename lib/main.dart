import 'package:covid_19/app/locator.dart';
import 'package:covid_19/app/router.gr.dart' as Router;
import 'package:covid_19/constant.dart';
import 'package:covid_19/enums/connectivity_status.dart';
import 'package:covid_19/services/connectivity_services.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:provider/provider.dart';
import 'package:stacked_services/stacked_services.dart';

void main() {
  setupLocator();
  runApp(MyApp());
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
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Covid 19',
            theme: theme,
            initialRoute: Router.Routes.homeView,
            onGenerateRoute: Router.Router().onGenerateRoute,
            navigatorKey: locator<NavigationService>().navigatorKey,
            // darkTheme: ThemeData(scaffoldBackgroundColor: Colors.black87),
          ),
        );
      },
    );
  }
}
