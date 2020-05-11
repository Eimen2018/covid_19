import 'package:covid_19/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class AnalysisGraph extends StatelessWidget {

final Map allhistoricalData;
final List linebar;

  const AnalysisGraph({Key key, this.allhistoricalData, this.linebar}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: Center(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Text(
                  '60 days Data Analysis',
                  style: Theme.of(context).brightness == Brightness.light?kTitleTextstyle:kTitleTextstyle.copyWith(color:Colors.white70),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            (allhistoricalData == null)
                ? Column(
                    children: <Widget>[
                      SizedBox(
                        height: 30,
                      ),
                      Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Colors.blueGrey[400]
                                    : Colors.white,
                            boxShadow: [
                              BoxShadow(
                                offset: Offset(0, 4),
                                blurRadius: 30,
                                color: kShadowColor,
                              ),
                            ],
                          ),
                          child: CupertinoActivityIndicator()),
                    ],
                  )
                : Expanded(
                    child: charts.TimeSeriesChart(
                    linebar,
                    animate: true,
                    animationDuration: Duration(seconds: 1),
                  ))
          ],
        ),
      ),
    );
  }
}
