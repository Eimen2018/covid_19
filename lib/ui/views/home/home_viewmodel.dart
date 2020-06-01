import 'dart:async';
import 'dart:convert';
import 'package:covid_19/app/locator.dart';
import 'package:covid_19/app/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:http/http.dart' as http;
import 'package:charts_flutter/flutter.dart' as charts;

class HomeViewModel extends BaseViewModel {
  final NavigationService _navigationService = locator<NavigationService>();

  String _country = 'Global';
  String get country => _country;

  double _height = 90;
  double get height => _height;

  bool _moreInfo = false;
  bool get moreInfo => _moreInfo;

  Map _worldData;
  Map get worldData => _worldData;

  List _mostAffected;
  List get mostAffected => _mostAffected;

  List _mostAffectedYesterday;
  List get mostAffectedYesterday => _mostAffectedYesterday;

  List _mostAffectedCases;
  List get mostAffectedCases => _mostAffectedCases;

  List _mostAffectedCasesYesterday;
  List get mostAffectedCasesYesterday => _mostAffectedCasesYesterday;

  List _countryData;
  List get countryData => _countryData;

  List _historicalData;
  List get historicalData => _historicalData;

  int _timeStamp;
  int get timeStamp => _timeStamp;

  List<charts.Series<TimeSeriesSales, DateTime>> _linebar;
  List<charts.Series<TimeSeriesSales, DateTime>> get linebar => _linebar;

  Map _allhistoricalData;
  Map get allhistoricalData => _allhistoricalData;

  int _pageIndicator = 0;
  int get pageIndicator => _pageIndicator;
  int _pageIndicator2 = 0;
  int get pageIndicator2 => _pageIndicator2;
  List<String> _notificatioinCases;
  List<String> get notificationCases => _notificatioinCases;
  int trial = 0;
  Map<String, String> endOfTrial = Map();

  changePageindicator(int current, int slider) {
    if (slider == 1) _pageIndicator = current;
    if (slider == 2) _pageIndicator2 = current;
    notifyListeners();
  }

  void showHide() async {
    if (_height == 310) {
      _height = 90;
      _moreInfo = false;
    } else if (_height == 90) {
      _height = 310;
      notifyListeners();
      await new Future.delayed(const Duration(milliseconds: 510));
      _moreInfo = true;
    }
    notifyListeners();
  }

  void setcountry(String country) {
    _country = country;
    _worldData = null;
    _linebar = null;
    _allhistoricalData = null;
    notifyListeners();
  }

  addcoma(int number) {
    String num = number.toString();
    num = num.replaceAllMapped(
        new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
    return num;
  }

  fetchWorldData() async {
    try {
      http.Response response =
          await http.get('http://corona.lmao.ninja/v2/all');
      _worldData = json.decode(response.body);
      _timeStamp = worldData['updated'];
    } catch (e) {
      print(e);
      if (trial < 3) {
        fetchWorldData();
        trial++;
      } else
        endOfTrial.addAll({"WorldData": "Failed to Load World Data"});
    }
    notifyListeners();
    fetchMostAffected();
    // return _worldData;
  }

  // Future<Map> fetchWorldData() => locator<Api>().getData();

  fetchcountryData() async {
    // _allhistoricalData = null;
    // notifyListeners();
    // _worldData = null;
    try {
      http.Response response =
          await http.get('https://disease.sh/v2/countries/' + country);
      _worldData = json.decode(response.body);
      _timeStamp = worldData['updated'];
    } catch (e) {
      print(e);
      if (trial < 10) {
        fetchcountryData();
        trial++;
      } else
        endOfTrial.addAll({"CountryData": "Failed to Load Country Data"});
    }

    notifyListeners();
    fetchHistoricalDatacountries();
    // return _worldData;
  }

  fetchMostAffected() async {
    try {
      http.Response response =
          await http.get('https://disease.sh/v2/countries?sort=deaths');
      _mostAffected = json.decode(response.body);
      response = await http
          .get('https://disease.sh/v2/countries?yesterday=true&sort=deaths');
      _mostAffectedYesterday = json.decode(response.body);
    } catch (e) {
      print(e);
      if (trial < 10) {
        fetchMostAffected();
        trial++;
      } else
        endOfTrial
            .addAll({"MostAffected": "Failed to Load Most Affected Data"});
    }
    notifyListeners();
    // return _mostAffected;
  }

  fetchMostAffectedCases() async {
    try {
      http.Response response =
          await http.get('https://disease.sh/v2/countries?sort=cases');
      _mostAffectedCases = json.decode(response.body);
      response = await http
          .get('https://disease.sh/v2/countries?yesterday=true&sort=cases');
      _mostAffectedCasesYesterday = json.decode(response.body);
    } catch (e) {
      print(e);
      if (trial < 10) {
        fetchMostAffectedCases();
        trial++;
      } else
        endOfTrial
            .addAll({"MostAffected": "Failed to Load Most Affected Data"});
    }
    notifyListeners();
    // return _mostAffectedCases;
  }

  fetchAllcountries() async {
    try {
      http.Response response =
          await http.get('https://disease.sh/v2/countries');
      _countryData = json.decode(response.body);
    } catch (e) {
      print(e);
      if (trial < 10) {
        fetchAllcountries();
        trial++;
      } else
        endOfTrial.addAll({"ListCountries": "Failed to Load Country List"});
    }
    notifyListeners();
  }

  fetchHistoricalDatacountries() async {
    try {
      http.Response response = await http
          .get('https://disease.sh/v2/historical/' + _country + '?lastdays=60');
      if (response.statusCode != 404) {
        _allhistoricalData = json.decode(response.body);
        _linebar = new List<charts.Series<TimeSeriesSales, DateTime>>();
        _linebar.add(charts.Series(
          colorFn: (__, _) => charts.ColorUtil.fromDartColor(Colors.orange),
          id: 'cases',
          domainFn: (TimeSeriesSales sales, _) => sales.time,
          measureFn: (TimeSeriesSales sales, _) => sales.sales,
          data: changedata(_allhistoricalData['timeline']['cases']),
        ));
        _linebar.add(charts.Series(
          colorFn: (__, _) => charts.ColorUtil.fromDartColor(Colors.red),
          id: 'deaths',
          domainFn: (TimeSeriesSales sales, _) => sales.time,
          measureFn: (TimeSeriesSales sales, _) => sales.sales,
          data: changedata(_allhistoricalData['timeline']['deaths']),
        ));
        _linebar.add(charts.Series(
          colorFn: (__, _) => charts.ColorUtil.fromDartColor(Colors.green),
          id: 'recovered',
          domainFn: (TimeSeriesSales sales, _) => sales.time,
          measureFn: (TimeSeriesSales sales, _) => sales.sales,
          data: changedata(_allhistoricalData['timeline']['recovered']),
        ));
      } else {
        _allhistoricalData = {"message": "No Data"};
        _linebar = new List<charts.Series<TimeSeriesSales, DateTime>>();
      }
    } catch (e) {
      print(e);
      if (trial < 10) {
        fetchHistoricalDatacountries();
        trial++;
      } else
        endOfTrial.addAll({"Historical": "Failed to Load Historical Data"});
    }
    notifyListeners();
  }

  List<TimeSeriesSales> changedata(Map<dynamic, dynamic> data) {
    List<TimeSeriesSales> dataD = [];
    data.forEach((k, v) {
      dataD.add(new TimeSeriesSales(
          DateFormat.yMd('en_US').parse(k + "20"), v, null));
    });
    return dataD;
  }

  Future navigateToInfo() async {
    await _navigationService.navigateTo(Routes.infoViewRoute);
  }
}

class TimeSeriesSales {
  final DateTime time;
  final int sales;
  final Color color;

  TimeSeriesSales(this.time, this.sales, this.color);
}
