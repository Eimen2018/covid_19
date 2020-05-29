import 'dart:convert';
import 'package:covid_19/app/locator.dart';
import 'package:covid_19/services/notification_service.dart';
import 'package:covid_19/widgets/settingsearch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';

class SettingViewModel extends BaseViewModel {
  bool _isSwitched = true;
  bool get isSwitched => _isSwitched;
  set isSwitched(bool value) {
    _isSwitched = value;
    notifyListeners();
  }

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

  void deleteNotificationCountry(String country, SharedPreferences prefs) {
    List<String> a = prefs.getStringList('notificationcountry');
    a.removeWhere((element) => element == country);
    prefs.setStringList('notificationcountry', a);
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
    } else {
      List<String> a = prefs.getStringList('notificationcountry');
      int i = a.indexWhere((element) => element == country);
      if (i < 0) a.insert(0, country);
      prefs.setStringList('notificationcountry', a);
    }
    notifyListeners();
  }

  Future searchPage(BuildContext context, SharedPreferences prefs) {
    return showSearch(
        context: context,
        delegate: SettingSearch(
            countryList: countryData, prefs: prefs, getselected: getselected));
  }
}

class Item {
  const Item(this.name, this.icon);
  final String name;
  final Icon icon;
}
