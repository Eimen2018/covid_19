import 'package:carousel_slider/carousel_slider.dart';
import 'package:covid_19/constant.dart';
import 'package:covid_19/ui/views/home/home_viewmodel.dart';
import 'package:covid_19/widgets/mostaffected.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked_hooks/stacked_hooks.dart';

class MostAffectedCases extends HookViewModelWidget<HomeViewModel>{
   MostAffectedCases({
    Key key,
    
  }) : super(key: key,reactive:true);

  

  @override
  Widget buildViewModelWidget(BuildContext context,HomeViewModel model) {
    return Column(
      children: <Widget>[
        CarouselSlider(
          options: CarouselOptions(
              height: 340.0,
              aspectRatio: 1.0,
              viewportFraction: 1.2,
              initialPage: 0,
              scrollDirection:
                  Axis.horizontal,
              enableInfiniteScroll: false,
              onPageChanged: (index, reason) {
               model.changePageindicator(index, 2);
              }),
          items: (model.mostAffectedCases ==
                  null)
              ? [
                  Container(
                      width: MediaQuery.of(
                              context)
                          .size
                          .width,
                      padding:
                          EdgeInsets.all(20),
                      decoration:
                          BoxDecoration(
                        borderRadius:
                            BorderRadius
                                .circular(20),
                        boxShadow: [
                          BoxShadow(
                            offset:
                                Offset(0, 4),
                            blurRadius: 30,
                            color:
                                kShadowColor,
                          ),
                        ],
                      ),
                      child:
                          CupertinoActivityIndicator())
                ]
              : [
                  MostAffected(
                    type:
                        "Highest Case By\nCountry",
                    name: "Cases",
                    color: Colors.green,
                    countryData: model
                        .mostAffectedCases,
                    setCountry:
                        model.setcountry,
                    updateData: model
                        .fetchcountryData,
                    date: 'Today',
                  ),
                  MostAffected(
                    type:
                        "Highest Case By\nCountry",
                    name: "Cases",
                    color: Colors.green,
                    countryData: model
                        .mostAffectedCasesYesterday,
                    setCountry:
                        model.setcountry,
                    updateData: model
                        .fetchcountryData,
                    date: 'Yesterday',
                  ),
                ].map((i) {
                  return Builder(
                    builder: (BuildContext
                        context) {
                      return i;
                    },
                  );
                }).toList(),
        ),
        Row(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [1, 2].map((url) {
            int index = [1, 2].indexOf(url);
            return Container(
              width: 8.0,
              height: 8.0,
              margin: EdgeInsets.symmetric(
                  horizontal: 2.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: model.pageIndicator2 == index
                    ? Theme.of(context)
                                .brightness ==
                            Brightness.light
                        ? Color.fromRGBO(
                            0, 0, 0, 0.9)
                        : Colors.white
                    : Theme.of(context)
                                .brightness ==
                            Brightness.light
                        ? Color.fromRGBO(
                            0, 0, 0, 0.4)
                        : Colors.grey,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

