import 'package:covid_19/constant.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Recent extends StatefulWidget {
  final SharedPreferences prefs;
  final Function setCountry;
  const Recent({
    this.prefs,
    Key key,
    this.setCountry,
  }) : super(key: key);

  @override
  _RecentState createState() => _RecentState();
}

class _RecentState extends State<Recent> {
  @override
  void initState() {
    super.initState();
  }

  List<Color> borderColors = [
    Colors.orangeAccent,
    Colors.redAccent,
    Colors.greenAccent,
    Colors.purpleAccent,
    Colors.black
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: MediaQuery.of(context).size.width,
      height: 50,
      child: (widget.prefs.getStringList('country') != null)
          ? ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.prefs.getStringList('country').length,
              itemBuilder: (BuildContext context, int index) {
                // print(widget.recent.toString());
                return GestureDetector(
                  onTap: () {
                    widget.setCountry(
                        widget.prefs.getStringList('country')[index]);
                  },
                  child: Container(
                    margin: EdgeInsets.all(10),
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
                    // width: 70,
                    height: 10,
                    child: Center(
                        child:
                            Text(widget.prefs.getStringList('country')[index])),
                  ),
                );
              },
            )
          : SizedBox.shrink(),
    );
  }
}
