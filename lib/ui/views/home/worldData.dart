import 'package:carousel_slider/carousel_slider.dart';
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
        child: (model.worldData == null||model.worldDataYesterday==null)
            ? CupertinoActivityIndicator()
            : Column(
                children: <Widget>[
                  AnimatedContainer(
                    duration: Duration(milliseconds: 500),
                    height: model.height,
                    child: Column(
                      children: <Widget>[
                        Container(
                          // color: Colors.yellow,
                          child: Column(
                            children: <Widget>[
                              CarouselSlider(
                                options: CarouselOptions(
                                    height: 110.0,
                                    aspectRatio: 1.2,
                                    viewportFraction: 1.0,
                                    initialPage: 0,
                                    scrollDirection: Axis.horizontal,
                                    enableInfiniteScroll: false,
                                    onPageChanged: (index, reason) {
                                      model.changePageindicator(index, 3);
                                    }),
                                items: <Widget>[
                                  Container(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: <Widget>[
                                        Counter(
                                          color: kInfectedColor,
                                          number: model.worldData['todayCases'],
                                          title: "Today\n Cases",
                                        ),
                                        Counter(
                                          color: kDeathColor,
                                          number:
                                              model.worldData['todayDeaths'],
                                          title: "Today\nDeaths",
                                        ),
                                        Counter(
                                          color: kRecovercolor,
                                          number:
                                              model.worldData['todayRecovered'],
                                          title: "Today\nRecovered",
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: <Widget>[
                                        Counter(
                                          color: kInfectedColor,
                                          number: model.worldDataYesterday['todayCases'],
                                          title: "Yesterday\n Cases",
                                        ),
                                        Counter(
                                          color: kDeathColor,
                                          number:
                                              model.worldDataYesterday['todayDeaths'],
                                          title: "Yesterday\nDeaths",
                                        ),
                                        Counter(
                                          color: kRecovercolor,
                                          number:
                                              model.worldDataYesterday['todayRecovered'],
                                          title: "Yesterday\nRecovered",
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height:10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [1, 2].map((url) {
                                  int index = [1, 2].indexOf(url);
                                  return Container(
                                    width: 8.0,
                                    height: 8.0,
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 2.0),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: model.pageIndicator3 == index
                                          ? Theme.of(context).brightness ==
                                                  Brightness.light
                                              ? Color.fromRGBO(0, 0, 0, 0.9)
                                              : Colors.white
                                          : Theme.of(context).brightness ==
                                                  Brightness.light
                                              ? Color.fromRGBO(0, 0, 0, 0.4)
                                              : Colors.grey,
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
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
                ],
              ));
  }
}
