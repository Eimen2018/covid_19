import 'package:covid_19/widgets/counter.dart';
import 'package:flutter/material.dart';

class MoreInfo extends StatefulWidget {
  const MoreInfo({Key key, this.worldData}) : super(key: key);

  @override
  _MoreInfoState createState() => _MoreInfoState();
  final Map worldData;
}

class _MoreInfoState extends State<MoreInfo> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Counter(
                  number: widget.worldData['critical'],
                  color: Colors.purpleAccent,
                  title: "Critical"),
              Counter(
                  number: widget.worldData['todayDeaths'],
                  color: Theme.of(context).brightness == Brightness.light
                      ? Colors.black
                      : Colors.white,
                  title: "Today Deaths"),
              Counter(
                  number: widget.worldData['active'],
                  color: Colors.brown,
                  title: "Active"),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Counter(
                  number: widget.worldData['tests'],
                  color: Colors.deepOrange,
                  title: "Tests"),
              Counter(
                  number: widget.worldData['population'],
                  color: Colors.indigoAccent,
                  title: "population"),
            ],
          )
        ],
      ),
    );
  }
}
