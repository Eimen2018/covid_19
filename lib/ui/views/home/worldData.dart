import 'package:covid_19/constant.dart';
import 'package:covid_19/ui/views/home/home_viewmodel.dart';
import 'package:covid_19/widgets/counter.dart';
import 'package:covid_19/widgets/moreinfo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked_hooks/stacked_hooks.dart';

class WorldDataView extends HookViewModelWidget<HomeViewModel> {
  WorldDataView({
    Key key,
  }) : super(key: key, reactive: true);

  @override
  Widget buildViewModelWidget(BuildContext context, HomeViewModel model) {
    return Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.blueGrey[900]
              : Colors.white,
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 4),
              blurRadius: 30,
              color: kShadowColor,
            ),
          ],
        ),
        child: (model.worldData == null)
            ? CupertinoActivityIndicator()
            : Column(
                children: <Widget>[
                  AnimatedContainer(
                    duration: Duration(milliseconds: 500),
                    height: model.height,
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Counter(
                              color: kInfectedColor,
                              number: model.worldData['cases'],
                              title: "Infected",
                            ),
                            Counter(
                              color: kDeathColor,
                              number: model.worldData['deaths'],
                              title: "Deaths",
                            ),
                            Counter(
                              color: kRecovercolor,
                              number: model.worldData['recovered'],
                              title: "Recovered",
                            ),
                          ],
                        ),
                        (!model.moreInfo)
                            ? SizedBox.shrink()
                            : Column(
                                children: <Widget>[
                                  SizedBox(
                                    height: 20,
                                  ),
                                  MoreInfo(worldData: model.worldData),
                                ],
                              ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 30, vertical: 5),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(color: Colors.red)),
                            child: Column(
                              children: <Widget>[
                                Text(
                                  model.addcoma(model.worldData["todayCases"]),
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.red),
                                ),
                                Text(
                                  "Today Cases",
                                  style: kSubTextStyle.copyWith(fontSize: 15),
                                )
                              ],
                            ))
                      ],
                    ),
                  )
                ],
              ));
  }
}
