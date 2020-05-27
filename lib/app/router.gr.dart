// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:auto_route/auto_route.dart';
import 'package:covid_19/ui/views/home/home_view.dart';
import 'package:covid_19/ui/views/info/info_view.dart';

abstract class Routes {
  static const homeView = '/';
  static const infoViewRoute = '/info-view-route';
  static const all = {
    homeView,
    infoViewRoute,
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
      default:
        return unknownRoutePage(settings.name);
    }
  }
}
