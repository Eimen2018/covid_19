import 'package:covid_19/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class AnalysisGraph extends StatelessWidget {
  final Map allhistoricalData;
  final List linebar;

  const AnalysisGraph({Key key, this.allhistoricalData, this.linebar})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 310,
      child: Center(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Text(
                  '60 days Data Analysis',
                  style: Theme.of(context).brightness == Brightness.light
                      ? kTitleTextstyle
                      : kTitleTextstyle.copyWith(color: Colors.white60),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            (linebar == null)
                ? CupertinoActivityIndicator()
                : Container(
                    // color: Colors.white,
                    width: MediaQuery.of(context).size.width,
                    height: 270,
                    child: (allhistoricalData['message']!=null)
                        ? Center(child: Text("No Data for this country"))
                        : charts.TimeSeriesChart(
                            linebar,
                            animate: true,
                            animationDuration: Duration(seconds: 1),
                          ),
                  )
          ],
        ),
      ),
    );
  }
}
