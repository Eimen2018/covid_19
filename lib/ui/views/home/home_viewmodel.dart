import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:connectivity/connectivity.dart';
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
  Map _source = {ConnectivityResult.none: false};
  MyConnectivity _connectivity = MyConnectivity.instance;

  String _country = 'Global';
  String get country => _country;

  double _height = 90;
  double get height => _height;

  bool _moreInfo = false;
  bool get moreInfo => _moreInfo;

  void showHide() async {
    if (_height == 300) {
      _height = 90;
      _moreInfo = false;
    } else if (_height == 90) {
      _height = 300;
      notifyListeners();
      await new Future.delayed(const Duration(milliseconds: 510));
      _moreInfo = true;
    }
    notifyListeners();
  }

  void setcountry(String country) {
    _country = country;
    notifyListeners();
  }

  Map _worldData;
  Map get worldData => _worldData;

  List _mostAffected;
  List get mostAffected => _mostAffected;

  List _mostAffectedYesterday;
  List get mostAffectedYesterday => _mostAffectedYesterday;

  List _countryData;
  List get countryData => _countryData;

  List _historicalData;
  List get historicalData => _historicalData;

  List<charts.Series<TimeSeriesSales, DateTime>> _linebar;
  List<charts.Series<TimeSeriesSales, DateTime>> get linebar => _linebar;

  Map _allhistoricalData;
  Map get allhistoricalData => _allhistoricalData;

  fetchWorldData() async {
    _worldData = null;
    http.Response response = await http.get('http://corona.lmao.ninja/v2/all');
    _worldData = json.decode(response.body);
    notifyListeners();
  }

  fetchcountryData() async {
    _allhistoricalData = null;
    notifyListeners();
    _worldData = null;
    http.Response response =
        await http.get('https://disease.sh/v2/countries/' + country);
    _worldData = json.decode(response.body);
    notifyListeners();
    fetchHistoricalDatacountries();
  }

  fetchMostAffected() async {
    http.Response response =
        await http.get('https://disease.sh/v2/countries?sort=deaths');
    _mostAffected = json.decode(response.body);
    response = await http
        .get('https://disease.sh/v2/countries?yesterday=true&sort=deaths');
    _mostAffectedYesterday = json.decode(response.body);
    notifyListeners();
  }

  fetchAllcountries() async {
    http.Response response = await http.get('https://disease.sh/v2/countries');
    _countryData = json.decode(response.body);
  }

  fetchHistoricalDatacountries() async {
    _allhistoricalData = null;
    http.Response response = await http
        .get('https://disease.sh/v2/historical/' + _country + '?lastdays=60');
    _allhistoricalData = json.decode(response.body);
    _linebar = List<charts.Series<TimeSeriesSales, DateTime>>();
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

class MyConnectivity {
  MyConnectivity._internal();

  static final MyConnectivity _instance = MyConnectivity._internal();

  static MyConnectivity get instance => _instance;

  Connectivity connectivity = Connectivity();

  StreamController controller = StreamController.broadcast();

  Stream get myStream => controller.stream;

  void initialise() async {
    ConnectivityResult result = await connectivity.checkConnectivity();
    _checkStatus(result);
    connectivity.onConnectivityChanged.listen((result) {
      _checkStatus(result);
    });
  }

  void _checkStatus(ConnectivityResult result) async {
    bool isOnline = false;
    try {
      final result = await InternetAddress.lookup('https://www.google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        isOnline = true;
      } else
        isOnline = false;
    } on SocketException catch (_) {
      isOnline = false;
    }
    controller.sink.add({result: isOnline});
  }

  void disposeStream() => controller.close();
}
