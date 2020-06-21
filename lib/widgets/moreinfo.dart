import 'package:covid_19/widgets/counter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
                  number: widget.worldData['cases'],
                  color: Colors.purpleAccent,
                  title: "Cases"),
              Counter(
                  number: widget.worldData['deaths'],
                  color: Theme.of(context).brightness == Brightness.light
                      ? Colors.black
                      : Colors.white,
                  title: "Deaths"),
              Counter(
                  number: widget.worldData['recovered'],
                  color: Colors.brown,
                  title: "Recovered"),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Counter(
                  number: widget.worldData['critical'],
                  color: Colors.deepOrange,
                  title: "Critical"),
              Counter(
                  number:NumberFormat.compact().format(widget.worldData['active']),
                  color: Colors.deepOrange,
                  title: "Active"),
              Counter(
                  number: NumberFormat.compact().format(widget.worldData['tests']),
                  color: Colors.indigoAccent,
                  title: "Tests"),
            ],
          )
        ],
      ),
    );
  }
}
