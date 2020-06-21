import 'dart:async';
import 'dart:convert';
import 'package:background_fetch/background_fetch.dart';
import 'package:covid_19/services/notification_service.dart';
import 'package:covid_19/widgets/settingsearch.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';

class SettingViewModel extends BaseViewModel {
  // StreamController<String> controller = StreamController<String>();
  bool _isSwitched = false;
  bool get isSwitched => _isSwitched;
  set isSwitched(bool value) {
    _isSwitched = value;
    notifyListeners();
  }

  changeisSwitched(bool value, SharedPreferences prefs) {
    _isSwitched = value;
    prefs.setBool("isSwitched", value);
    if (value) {
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
    notifyListeners();
  }

  // String xxx = "";

  // Stream<String> getCountrydata(SharedPreferences prefs) async* {
  //   String b = "";
  //   while (true) {
  //     await Future.delayed(Duration(seconds: 4));
  //     b = await getnotificationStrings(prefs);
  //     if (xxx != b) {
  //       xxx = await getnotificationStrings(prefs);
  //       yield b;
  //     }
  //   }
  // }

  List<Color> borderColors = [
    Colors.orangeAccent,
    Colors.redAccent,
    Colors.greenAccent,
    Colors.purpleAccent,
    Colors.black
  ];

  List _countryData;
  List get countryData => _countryData;

  String getPrefLength(SharedPreferences prefs) =>
      prefs.getStringList('notificationcountry').length.toString();

  fetchAllcountries() async {
    try {
      http.Response response =
          await http.get('https://disease.sh/v2/countries');
      _countryData = json.decode(response.body);
      notifyListeners();
    } catch (e) {
      print(e);
      fetchAllcountries();
    }
  }

  deleteNotificationCountry(String country, SharedPreferences prefs) async {
    List<String> notificationCountry =
        prefs.getStringList('notificationcountry');
    List<String> prevCases = prefs.getStringList('prevcases');
    notificationCountry.removeWhere((element) => element == country);
    prevCases.removeWhere((element) => element.contains(country));
    await prefs.setStringList('notificationcountry', notificationCountry);
    await prefs.setStringList('prevcases', prevCases);
    notifyListeners();
  }

  bool checkSharedpreference(SharedPreferences prefs) {
    return (prefs.getStringList('notificationcountry') == null ||
        prefs.getStringList('notificationcountry').length == 0);
  }

  bool checkcountryDataandLength(SharedPreferences prefs) {
    if (countryData == null ||
        prefs.getStringList('notificationcountry') == null) return false;
    return (countryData == null ||
        prefs.getStringList('notificationcountry').length == 4);
  }

  void getselected(String country, SharedPreferences prefs) {
    if (prefs.getStringList('notificationcountry') == null) {
      prefs.setStringList('notificationcountry', [country]);
      prefs.setStringList('prevcases', ["$country-0"]);
    } else {
      List<String> notificationCountry =
          prefs.getStringList('notificationcountry');
      List<String> prevCases = prefs.getStringList('prevcases');
      int i = notificationCountry.indexWhere((element) => element == country);
      if (i < 0) {
        notificationCountry.insert(0, country);
        prevCases.insert(0, "$country-0");
      }
      prefs.setStringList('notificationcountry', notificationCountry);
      prefs.setStringList('prevcases', prevCases);
    }
    notifyListeners();
  }

  Future searchPage(BuildContext context, SharedPreferences prefs,
      NotificationService notificationService) {
    return showSearch(
        context: context,
        delegate: SettingSearch(
            countryList: countryData,
            prefs: prefs,
            getselected: getselected,
            notificationService: notificationService,
            checkSharedpreference: checkSharedpreference));
  }

  // getnotificationStrings(SharedPreferences prefs) async {
  //   List a;
  //   String b = "";
  //   if (checkSharedpreference(prefs)) {
  //     return "Select A Country in Settings to Recieve Today Case Notification";
  //   }
  //   try {
  //     http.Response response =
  //         await http.get('https://disease.sh/v2/countries');
  //     a = json.decode(response.body);
  //     prefs.getStringList('notificationcountry').forEach((element) {
  //       var c = a.firstWhere((e) => (e['country'].toString() == element));
  //       if (c['todayCases'] == 0)
  //         b += element + ": " + "Waiting Update" + " \n";
  //       else
  //         b += element + ": " + c['todayCases'].toString() + " \n";
  //     });
  //   } catch (e) {
  //     print(e);
  //     getnotificationStrings(prefs);
  //   }

  //   return b;
  // }
}

class Item {
  const Item(this.name, this.icon);
  final String name;
  final Icon icon;
}
