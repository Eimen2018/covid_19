// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:auto_route/auto_route.dart';
import 'package:covid_19/ui/views/home/home_view.dart';
import 'package:covid_19/ui/views/info/info_view.dart';
import 'package:covid_19/ui/views/setting/setting_view.dart';
import 'package:covid_19/services/notification_service.dart';

abstract class Routes {
  static const homeView = '/';
  static const infoViewRoute = '/info-view-route';
  static const setting = '/setting';
  static const all = {
    homeView,
    infoViewRoute,
    setting,
  };
}

class Router extends RouterBase {
  @override
  Set<String> get allRoutes => Routes.all;

  @Deprecated('call ExtendedNavigator.ofRouter<Router>() directly')
  static ExtendedNavigatorState get navigator =>
      ExtendedNavigator.ofRouter<Router>();

  @override
  Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case Routes.homeView:
        return MaterialPageRoute<dynamic>(
          builder: (context) => HomeView(),
          settings: settings,
        );
      case Routes.infoViewRoute:
        return MaterialPageRoute<dynamic>(
          builder: (context) => InfoView(),
          settings: settings,
        );
      case Routes.setting:
        if (hasInvalidArgs<SettingViewArguments>(args)) {
          return misTypedArgsRoute<SettingViewArguments>(args);
        }
        final typedArgs =
            args as SettingViewArguments ?? SettingViewArguments();
        return MaterialPageRoute<dynamic>(
          builder: (context) => SettingView(
              key: typedArgs.key,
              notificationService: typedArgs.notificationService),
          settings: settings,
        );
      default:
        return unknownRoutePage(settings.name);
    }
  }
}

// *************************************************************************
// Arguments holder classes
// **************************************************************************

//SettingView arguments holder class
class SettingViewArguments {
  final Key key;
  final NotificationService notificationService;
  SettingViewArguments({this.key, this.notificationService});
}
