import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';

class Search extends SearchDelegate {
  final List countryList;
  final Function setCountry;
  final Function updateWorlddata;
  Search(this.countryList, this.setCountry, this.updateWorlddata);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [IconButton(icon: Icon(Icons.clear), onPressed: () => query = '')];
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
              padding: EdgeInsets.all(5),
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.white
                  : Colors.blueGrey[900],
              child: Image.network(
                suggestionList[index]['countryInfo']['flag'],
                height: 30,
                width: 100,
              ),
            ),
            title: Text(suggestionList[index]['country'].toString()),
            onTap: () {
              this.setCountry(suggestionList[index]['country'].toString());
              this.updateWorlddata();
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
            leading: Image.network(
              suggestionList[index]['countryInfo']['flag'],
              height: 30,
              width: 100,
            ),
            title: Text(suggestionList[index]['country'].toString()),
            onTap: () {
              this.setCountry(suggestionList[index]['country'].toString());
              this.updateWorlddata();
              Navigator.pop(context);
            },
          );
        });
  }
}
