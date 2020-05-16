import 'package:carousel_slider/carousel_slider.dart';
import 'package:connectivity/connectivity.dart';
import 'package:covid_19/enums/connectivity_status.dart';
import 'package:covid_19/ui/views/home/home_viewmodel.dart';
import 'package:covid_19/widgets/analysisgraph.dart';
import 'package:covid_19/widgets/counter.dart';
import 'package:covid_19/widgets/moreinfo.dart';
import 'package:covid_19/widgets/mostaffected.dart';
import 'package:covid_19/widgets/my_header.dart';
import 'package:covid_19/widgets/search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';
import 'package:time_formatter/time_formatter.dart';
import '../../../constant.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final controller = ScrollController();
  double offset = 0;

  @override
  void initState() {
    super.initState();
    controller.addListener(onScroll);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void onScroll() {
    setState(() {
      offset = (controller.hasClients) ? controller.offset : 0;
    });
  }

  int _current = 0;

  @override
  Widget build(BuildContext context) {
    var connectionStatus = Provider.of<ConnectivityStatus>(context);
    return ViewModelBuilder<HomeViewModel>.reactive(
      // createNewModelOnInsert: true,
      onModelReady: (model) {},
      viewModelBuilder: () => HomeViewModel(),
      builder: (context, model, child) => Scaffold(
        body: SingleChildScrollView(
          controller: controller,
          child: Column(
            children: <Widget>[
              MyHeader(
                image: "assets/icons/Drcorona.svg",
                textTop: "All you need is",
                textBottom: "to stay at home.",
                offset: offset,
                page: "Home",
              ),
              (connectionStatus == ConnectivityStatus.Offline ||
                      connectionStatus == null)
                  ? Center(
                      child: Text("No Internet Connection"),
                    )
                  : Column(children: <Widget>[
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        height: 60,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.blueGrey[900]
                              : Colors.white,
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(
                            color: Color(0xFFE5E5E5),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                model.setcountry('Global');
                              },
                              child: Image.asset(
                                "assets/icons/globe.png",
                                width: 20,
                              ),
                            ),
                            Text(
                              model.country,
                              style: kSubTextStyle.copyWith(
                                  color: Theme.of(context).brightness ==
                                          Brightness.light
                                      ? Colors.black87
                                      : Colors.white),
                            ),
                            FutureBuilder(
                                future: model.fetchAllcountries(),
                                builder: (context, snapshot) {
                                  return IconButton(
                                      icon: Icon(
                                        Icons.search,
                                        color: Theme.of(context).brightness ==
                                                Brightness.light
                                            ? Colors.black87
                                            : Colors.white54,
                                      ),
                                      onPressed: (!snapshot.hasData)
                                          ? null
                                          : () {
                                              showSearch(
                                                  context: context,
                                                  delegate: Search(
                                                      model.countryData,
                                                      model.setcountry,
                                                      model.fetchcountryData));
                                              Future.delayed(
                                                  Duration(milliseconds: 600),
                                                  () {
                                                FlutterStatusbarcolor
                                                    .setStatusBarWhiteForeground(
                                                        false);
                                              });
                                            });
                                }),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: "Case Update\n",
                                        style: Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? kTitleTextstyle.copyWith(
                                                color: Colors.white70)
                                            : kTitleTextstyle,
                                      ),
                                      TextSpan(
                                        text: (model.timeStamp == null)
                                            ? "..."
                                            : "Last Update " +
                                                formatTime(model.timeStamp),
                                        style: TextStyle(
                                          color: kTextLightColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Spacer(),
                                GestureDetector(
                                  onTap: () async {
                                    model.showHide();
                                  },
                                  child: model.height == 90
                                      ? Text(
                                          "See details",
                                          style: TextStyle(
                                            color: kPrimaryColor,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        )
                                      : Text(
                                          "Hide details",
                                          style: TextStyle(
                                            color: kPrimaryColor,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            Container(
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
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
                              child: FutureBuilder(
                                  future: (model.country == 'Global')
                                      ? model.fetchWorldData()
                                      : model.fetchcountryData(),
                                  builder: (context, snapshot) {
                                    return (!snapshot.hasData ||
                                            model.worldData == null)
                                        ? CupertinoActivityIndicator()
                                        : AnimatedContainer(
                                            height: model.height,
                                            child: Column(
                                              children: <Widget>[
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: <Widget>[
                                                    Counter(
                                                      color: kInfectedColor,
                                                      number: snapshot
                                                          .data['cases'],
                                                      title: "Infected",
                                                    ),
                                                    Counter(
                                                      color: kDeathColor,
                                                      number: snapshot
                                                          .data['deaths'],
                                                      title: "Deaths",
                                                    ),
                                                    Counter(
                                                      color: kRecovercolor,
                                                      number: snapshot
                                                          .data['recovered'],
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
                                                          MoreInfo(
                                                            worldData:
                                                                snapshot.data,
                                                          ),
                                                        ],
                                                      ),
                                              ],
                                            ),
                                            duration:
                                                Duration(milliseconds: 500),
                                          );
                                  }),
                            ),
                            SizedBox(height: 20),
                            (model.country == 'Global')
                                ? Column(
                                    children: <Widget>[
                                      FutureBuilder(
                                          future: model.fetchMostAffected(),
                                          builder: (context, snapshot) {
                                            if (!snapshot.hasData) {
                                              return Container(
                                                  padding: EdgeInsets.all(20),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    color: Theme.of(context)
                                                                .brightness ==
                                                            Brightness.dark
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
                                                  child:
                                                      CupertinoActivityIndicator());
                                            }
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
                                                      enableInfiniteScroll:
                                                          false,
                                                      onPageChanged:
                                                          (index, reason) {
                                                        setState(() {
                                                          _current = index;
                                                        });
                                                      }),
                                                  items: [
                                                    MostAffected(
                                                      countryData:
                                                          snapshot.data,
                                                      setCountry:
                                                          model.setcountry,
                                                      updateData: model
                                                          .fetchcountryData,
                                                      date: 'Today',
                                                    ),
                                                    MostAffected(
                                                      countryData: model
                                                          .mostAffectedYesterday,
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
                                                    int index =
                                                        [1, 2].indexOf(url);
                                                    return Container(
                                                      width: 8.0,
                                                      height: 8.0,
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 2.0),
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: _current == index
                                                            ? Theme.of(context)
                                                                        .brightness ==
                                                                    Brightness
                                                                        .light
                                                                ? Color.fromRGBO(
                                                                    0,
                                                                    0,
                                                                    0,
                                                                    0.9)
                                                                : Colors.white
                                                            : Theme.of(context)
                                                                        .brightness ==
                                                                    Brightness
                                                                        .light
                                                                ? Color
                                                                    .fromRGBO(
                                                                        0,
                                                                        0,
                                                                        0,
                                                                        0.4)
                                                                : Colors.grey,
                                                      ),
                                                    );
                                                  }).toList(),
                                                ),
                                              ],
                                            );
                                          })
                                    ],
                                  )
                                : FutureBuilder(
                                    future:
                                        model.fetchHistoricalDatacountries(),
                                    builder: (context, snapshot) {
                                      return (!snapshot.hasData)
                                          ? Container(
                                              padding: EdgeInsets.all(20),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                color: Theme.of(context)
                                                            .brightness ==
                                                        Brightness.dark
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
                                              child:
                                                  CupertinoActivityIndicator())
                                          : AnalysisGraph(
                                              allhistoricalData:
                                                  snapshot.data[0],
                                              linebar: model.linebar);
                                    }),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.all(10),
                            child: Text(
                              "WE ARE TOGETHER IN THIS FIGHT",
                              style: TextStyle(
                                color: Theme.of(context).brightness ==
                                        Brightness.light
                                    ? Colors.black87
                                    : Colors.white54,
                              ),
                            ),
                          )
                        ],
                      )
                    ])
            ],
          ),
        ),
      ),
    );
  }
}
