import 'package:covid_19/constant.dart';
import 'package:covid_19/ui/views/home/home_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked_hooks/stacked_hooks.dart';

class Recent extends StatefulWidget {
  final SharedPreferences prefs;
  final Function fetchcountryData;
  final Function setcountry;
  Recent({
    this.prefs,
    this.fetchcountryData,
    this.setcountry,
    Key key,
  }) : super(
          key: key,
        );

  @override
  _RecentState createState() => _RecentState();
}

class _RecentState extends State<Recent> {
  List<Color> borderColors = [
    Colors.orangeAccent,
    Colors.redAccent,
    Colors.greenAccent,
    Colors.purpleAccent,
    Colors.black
  ];

  deleteNotificationCountry(String country, SharedPreferences prefs) async {
    // setBusy(true);
    List<String> a = prefs.getStringList('country');
    a.removeWhere((element) => element == country);
    setState(() {
      prefs.setStringList('country', a);
    });

    // setBusy(false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        // width: MediaQuery.of(context).size.width,
        // color:Colors.yellow,
        height: (widget.prefs.getStringList('country') != null &&
                widget.prefs.getStringList('country').length != 0)
            ? 50
            : 30,
        child: (widget.prefs.getStringList('country') != null &&
                widget.prefs.getStringList('country').length != 0)
            ? ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: widget.prefs.getStringList('country').length,
                itemBuilder: (BuildContext context, int index) {
                  // print(widget.recent.toString());
                  return GestureDetector(
                    onTap: () {
                      widget.setcountry(
                          widget.prefs.getStringList('country')[index]);
                      widget.fetchcountryData();
                      Navigator.pop(context);
                    },
                    child: Container(
                      margin: EdgeInsets.only(
                          right: 10, left: 10, top: 15, bottom: 5),
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: borderColors[index]),
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(0, 4),
                            blurRadius: 30,
                            color: kShadowColor,
                          ),
                        ],
                      ),
                      height: 10,
                      child: Center(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(widget.prefs.getStringList('country')[index]),
                          SizedBox(width: 10),
                          GestureDetector(
                            onTap: () {
                              deleteNotificationCountry(
                                  widget.prefs.getStringList('country')[index],
                                  widget.prefs);
                            },
                            child:
                                Icon(Icons.close, size: 17, color: Colors.red),
                          )
                        ],
                      )),
                    ),
                  );
                },
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                      margin: EdgeInsets.only(
                          top: 10, bottom: 5),
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text("No Recent Search"))
                ],
              ));
  }
}
