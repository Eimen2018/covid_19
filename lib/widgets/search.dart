import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Search extends SearchDelegate {
  final List countryList;
  final Function setCountry;
  final Function updateWorlddata;
  final SharedPreferences prefs;
  Search({this.countryList, this.setCountry, this.updateWorlddata, this.prefs});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [IconButton(icon: Icon(Icons.clear), onPressed: () => query = '')];
  }

  void getrecent(String country) {
    if (this.prefs.getStringList('country') == null) {
      this.prefs.setStringList('country', [country]);
    } else {
      List<String> a = this.prefs.getStringList('country');
      int i = a.indexWhere((element) => element == country);
      if (i < 0) a.insert(0, country);
      if (a.length > 5) a.removeAt(5);
      this.prefs.setStringList('country', a);
    }
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        color: Colors.black87,
        icon: Icon(Icons.arrow_back_ios),
        onPressed: () {
          Navigator.pop(context);
          FlutterStatusbarcolor.setStatusBarWhiteForeground(true);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    final suggestionList = query.isEmpty
        ? countryList
        : countryList
            .where((element) =>
                element['country'].toString().toLowerCase().contains(query))
            .toList();
    return ListView.builder(
        itemCount: suggestionList.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Container(
              width: 60,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.light
                      ? Colors.black12
                      : Colors.blueGrey[900],
                  borderRadius: BorderRadius.circular(5)),
              child: Image.network(
                suggestionList[index]['countryInfo']['flag'],
                height: 30,
                width: 50,
                fit: BoxFit.fill,
                errorBuilder: (BuildContext context, Object exception,
                    StackTrace stackTrace) {
                  return Icon(Icons.error);
                },
                loadingBuilder: (BuildContext context, Widget child,
                    ImageChunkEvent loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes
                          : null,
                    ),
                  );
                },
              ),
            ),
            title: Text(suggestionList[index]['country'].toString()),
            onTap: () async {
              this.setCountry(suggestionList[index]['country'].toString());
              this.updateWorlddata();
              getrecent(suggestionList[index]['country'].toString());
              Navigator.pop(context);
            },
          );
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList = query.isEmpty
        ? countryList
        : countryList
            .where((element) =>
                element['country'].toString().toLowerCase().contains(query))
            .toList();
    return ListView.builder(
        itemCount: suggestionList.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Container(
              width: 60,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.light
                      ? Colors.black12
                      : Colors.blueGrey[900],
                  borderRadius: BorderRadius.circular(5)),
              child: Image.network(
                suggestionList[index]['countryInfo']['flag'],
                height: 30,
                width: 50,
                fit: BoxFit.fill,
                loadingBuilder: (BuildContext context, Widget child,
                    ImageChunkEvent loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes
                          : null,
                    ),
                  );
                },
              ),
            ),
            title: Text(suggestionList[index]['country'].toString()),
            onTap: () async {
              this.setCountry(suggestionList[index]['country'].toString());
              this.updateWorlddata();
              getrecent(suggestionList[index]['country'].toString());
              Navigator.pop(context);
            },
          );
        });
  }
}
