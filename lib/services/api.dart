import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';

@lazySingleton
class Api {
  Future<Map> getData() async {
    var worldData = Map();
    try {
      http.Response response =
          await http.get('http://corona.lmao.ninja/v2/all');
      worldData = json.decode(response.body);
      // timeStamp = worldData['updated'];
    } catch (e) {
      print(e);
    }
    return worldData;
  }

  Future<Map> getCountryData(country) async {
    var worldData = Map();
    try {
      http.Response response =
          await http.get('https://disease.sh/v2/countries/' + country);
      worldData = json.decode(response.body);
      // _timeStamp = worldData['updated'];
    } catch (e) {
      print(e);
    }

    // notifyListeners();
    // fetchHistoricalDatacountries();
    return worldData;
  }
}
