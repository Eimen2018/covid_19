import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:connectivity/connectivity.dart';
import 'package:covid_19/enums/connectivity_status.dart';
import 'package:covid_19/ui/views/home/home_viewmodel.dart';
import 'package:covid_19/ui/views/home/mostaffectedcases.dart';
import 'package:covid_19/ui/views/home/mostaffecteddeaths.dart';
import 'package:covid_19/ui/views/home/worldData.dart';
import 'package:covid_19/ui/views/info/info_view.dart';
import 'package:covid_19/widgets/analysisgraph.dart';
import 'package:covid_19/widgets/counter.dart';
import 'package:covid_19/widgets/moreinfo.dart';
import 'package:covid_19/widgets/mostaffected.dart';
import 'package:covid_19/widgets/my_header.dart';
import 'package:covid_19/widgets/recent.dart';
import 'package:covid_19/widgets/search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_hooks/stacked_hooks.dart';
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
  void dispose() {
    controller.dispose();
    super.dispose();
    subscription.cancel();
  }

  void onScroll() {
    setState(() {
      offset = (controller.hasClients) ? controller.offset : 0;
    });
  }

  SharedPreferences prefs;
  StreamSubscription<ConnectivityResult> subscription;

  @override
  void initState() {
    super.initState();
    controller.addListener(onScroll);
  }

  @override
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  int _current2 = 0;

  @override
  Widget build(BuildContext context) {
    var connectionStatus = Provider.of<ConnectivityStatus>(context);
    return ViewModelBuilder<HomeViewModel>.reactive(
      // createNewModelOnInsert: true,
      onModelReady: (model) async {
        prefs = await SharedPreferences.getInstance();
        subscription = Connectivity()
            .onConnectivityChanged
            .listen((ConnectivityResult result) {
          if (result != ConnectivityResult.none) {
            model.setcountry("Global");
            model.fetchWorldData();
            model.fetchAllcountries();
            model.fetchMostAffected();
            model.fetchMostAffectedCases();
          }
        });
      },
      viewModelBuilder: () => HomeViewModel(),
      builder: (context, model, child) => Scaffold(
        endDrawer: InfoView(),
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
                      child: Lottie.asset(
                        'assets/networkLost.json',
                        fit: BoxFit.fill,
                      ),
                    )
                  : Column(children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.blueGrey[900]
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(7),
                              border: Border.all(
                                color: Color(0xFFE5E5E5),
                              ),
                            ),
                            child: GestureDetector(
                              onLongPress: () {
                                model.setcountry('Global');
                                prefs.clear();
                                model.fetchWorldData();
                              },
                              onTap: () {
                                model.setcountry('Global');
                                model.fetchWorldData();
                              },
                              child: Image.asset(
                                "assets/icons/globe.png",
                                width: 20,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: (model.countryData == null)
                                ? null
                                : () {
                                    showSearch(
                                        context: context,
                                        delegate: Search(
                                            countryList: model.countryData,
                                            setCountry: model.setcountry,
                                            updateWorlddata:
                                                model.fetchcountryData,
                                            prefs: prefs));
                                    Future.delayed(Duration(milliseconds: 600),
                                        () {
                                      FlutterStatusbarcolor
                                          .setStatusBarWhiteForeground(false);
                                    });
                                  },
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 10),
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 20),
                              height: 60,
                              width: MediaQuery.of(context).size.width - 100,
                              decoration: BoxDecoration(
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.blueGrey[900]
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: Color(0xFFE5E5E5),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    model.country,
                                    style: kSubTextStyle.copyWith(
                                        color: Theme.of(context).brightness ==
                                                Brightness.light
                                            ? Colors.black87
                                            : Colors.white),
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.search,
                                      color: Theme.of(context).brightness ==
                                              Brightness.light
                                          ? Colors.black87
                                          : Colors.white54,
                                    ),
                                    onPressed: (model.countryData == null)
                                        ? null
                                        : () {
                                            showSearch(
                                                context: context,
                                                delegate: Search(
                                                    countryList:
                                                        model.countryData,
                                                    setCountry:
                                                        model.setcountry,
                                                    updateWorlddata:
                                                        model.fetchcountryData,
                                                    prefs: prefs));
                                            Future.delayed(
                                                Duration(milliseconds: 600),
                                                () {
                                              FlutterStatusbarcolor
                                                  .setStatusBarWhiteForeground(
                                                      false);
                                            });
                                          },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      (prefs.getStringList('country') != null)
                          ? Recent(
                              prefs: prefs,
                              setCountry: model.setcountry,
                              updateData: model.fetchcountryData)
                          : SizedBox.shrink(),
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
                            WorldDataView(),
                            SizedBox(height: 20),
                            (model.country == 'Global')
                                ? Column(
                                    children: <Widget>[
                                      MostAffectedDeaths(),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      MostAffectedCases(),
                                    ],
                                  )
                                : (model.allhistoricalData == null)
                                    ? Container(
                                        padding: EdgeInsets.all(20),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
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
                                        child: CupertinoActivityIndicator())
                                    : AnalysisGraph(
                                        allhistoricalData:
                                            model.allhistoricalData,
                                        linebar: model.linebar)
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
