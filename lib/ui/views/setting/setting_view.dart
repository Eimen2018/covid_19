import 'dart:async';
import 'package:background_fetch/background_fetch.dart';
import 'package:covid_19/constant.dart';
import 'package:covid_19/services/notification_service.dart';
import 'package:covid_19/ui/views/setting/setting_viewmodel.dart';
import 'package:covid_19/widgets/my_header.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';

class SettingView extends StatefulWidget {
  final NotificationService notificationService;
  const SettingView({
    Key key,
    this.notificationService,
  }) : super(key: key);
  @override
  _SettingViewState createState() => _SettingViewState();
}

class _SettingViewState extends State<SettingView> {
  final controller = ScrollController();
  double offset = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  void onScroll() {
    setState(() {
      offset = (controller.hasClients) ? controller.offset : 0;
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    controller.addListener(onScroll);
  }

  SharedPreferences prefs;
  // Stream stream;
  // StreamSubscription<dynamic> streamSubscription;
  @override
  Widget build(BuildContext context) {
    // var connectionStatus = Provider.of<ConnectivityStatus>(context);
    return ViewModelBuilder<SettingViewModel>.reactive(
      onModelReady: (model) async {
        // stream = model.controller.stream;
        prefs = await SharedPreferences.getInstance();
        model.fetchAllcountries();
        if (prefs.getBool("isSwitched") != null)
          model.isSwitched = prefs.getBool("isSwitched");
      },
      viewModelBuilder: () => SettingViewModel(),
      builder: (context, model, child) => Scaffold(
        key: _scaffoldKey,
        body: SingleChildScrollView(
          controller: controller,
          child: Column(
            children: <Widget>[
              ClipPath(
                clipper: MyClipper(),
                child: Container(
                  padding: EdgeInsets.only(left: 40, top: 50, right: 20),
                  height: 350,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: Theme.of(context).brightness == Brightness.dark
                            ? [
                                Color(0xff0B186E),
                                Color(0xFF11249F),
                              ]
                            : [
                                Color(0xFF3383CD),
                                Color(0xFF11249F),
                              ]),
                    image: DecorationImage(
                      image: AssetImage("assets/images/virus.png"),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Icon(Icons.close, color: Colors.white, size: 30),
                            ],
                          )),
                      SizedBox(height: 20),
                      Expanded(
                        child: Stack(
                          children: <Widget>[
                            Positioned(
                              top: (offset < 0) ? 0 : offset,
                              child: SvgPicture.asset(
                                "assets/icons/settings.svg",
                                width: 200,
                                fit: BoxFit.fitWidth,
                                alignment: Alignment.bottomCenter,
                              ),
                            ),
                            Positioned(
                              top: 70 - offset / 2,
                              left: 170,
                              child: Text(
                                "Settings",
                                style: kHeadingTextStyle.copyWith(
                                    color: Colors.white, fontSize: 22),
                              ),
                            ), // I dont know why it can't work without container
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              (prefs == null)
                  ? CupertinoActivityIndicator()
                  : Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                "Show Notification When a Specific \nCountry's Data Change",
                                style: kHeadingTextStyle.copyWith(fontSize: 14),
                              ),
                              Switch(
                                value: model.isSwitched,
                                onChanged: (value) async {
                                  model.changeisSwitched(value, prefs);
                                  if (value) {
                                    BackgroundFetch.start().then((int status) {
                                      print(
                                          '[BackgroundFetch] start success: $status');
                                    }).catchError((e) {
                                      print(
                                          '[BackgroundFetch] start FAILURE: $e');
                                    });
                                    print("Notification Start...");
                                  } else {
                                    BackgroundFetch.stop().then((int status) {
                                      print(
                                          '[BackgroundFetch] stop success: $status');
                                    });

                                    print("Notification Cancelled");
                                  }
                                },
                                activeTrackColor: Color(0xFF3383CD),
                                activeColor: Color(0xFF11249F),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: AbsorbPointer(
                            absorbing: !model.isSwitched,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                padding: EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
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
                                child: Column(
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          (!model.checkSharedpreference(prefs))
                                              ? MainAxisAlignment.spaceBetween
                                              : MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          "Countries to Watch \nData Change",
                                        ),
                                        (!model.checkSharedpreference(prefs))
                                            ? Row(
                                                children: <Widget>[
                                                  Text(model.getPrefLength(
                                                          prefs) +
                                                      "/4"),
                                                  SizedBox(width: 15),
                                                  InkWell(
                                                    onTap: (model
                                                                .checkcountryDataandLength(
                                                                    prefs) ||
                                                            !model.isSwitched)
                                                        ? null
                                                        : () async {
                                                            String length = model
                                                                .getPrefLength(
                                                                    prefs);
                                                            await model.searchPage(
                                                                context,
                                                                prefs,
                                                                widget
                                                                    .notificationService);
                                                            Future.delayed(
                                                                Duration(
                                                                    milliseconds:
                                                                        600),
                                                                () {
                                                              FlutterStatusbarcolor
                                                                  .setStatusBarWhiteForeground(
                                                                      false);
                                                            });
                                                            if (length !=
                                                                model.getPrefLength(
                                                                    prefs)) {
                                                              _scaffoldKey
                                                                  .currentState
                                                                  .showSnackBar(
                                                                      SnackBar(
                                                                content: Text(
                                                                  "Country Added to Notification Set",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white),
                                                                ),
                                                                duration:
                                                                    Duration(
                                                                        seconds:
                                                                            2),
                                                                backgroundColor:
                                                                    Colors
                                                                        .black87,
                                                              ));
                                                            }
                                                          },
                                                    child: Container(
                                                      width: 30,
                                                      height: 30,
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                              color: (DynamicTheme.of(
                                                                              context)
                                                                          .brightness ==
                                                                      Brightness
                                                                          .dark)
                                                                  ? Colors.white
                                                                  : Colors
                                                                      .black),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5)),
                                                      child: Icon(Icons.add,
                                                          size: 20,
                                                          color: (model.checkcountryDataandLength(
                                                                      prefs) ||
                                                                  !model
                                                                      .isSwitched)
                                                              ? Colors.grey
                                                              : null),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            : SizedBox.shrink()
                                      ],
                                    ),
                                    SizedBox(height: 15),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        (model.checkSharedpreference(prefs))
                                            ? FlatButton(
                                                color: Color(0xFF3383CD),
                                                textColor: Colors.white,
                                                onPressed:
                                                    (model.checkcountryDataandLength(
                                                                prefs) ||
                                                            !model.isSwitched)
                                                        ? null
                                                        : () {
                                                            model.searchPage(
                                                                context,
                                                                prefs,
                                                                widget
                                                                    .notificationService);
                                                            Future.delayed(
                                                                Duration(
                                                                    milliseconds:
                                                                        600),
                                                                () {
                                                              FlutterStatusbarcolor
                                                                  .setStatusBarWhiteForeground(
                                                                      false);
                                                            });
                                                          },
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        new BorderRadius
                                                            .circular(5.0)),
                                                child: Text(
                                                  "Select a country",
                                                ))
                                            : SizedBox.shrink(),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Container(
                                        child: model
                                                .checkSharedpreference(prefs)
                                            ? SizedBox.shrink()
                                            : Wrap(
                                                children: prefs
                                                    .getStringList(
                                                        'notificationcountry')
                                                    .asMap()
                                                    .entries
                                                    .map((entry) {
                                                  int index = entry.key;
                                                  return Container(
                                                    width: (prefs
                                                                .getStringList('notificationcountry')[
                                                                    index]
                                                                .length >
                                                            8)
                                                        ? (prefs
                                                                    .getStringList(
                                                                        'notificationcountry')[index]
                                                                    .length *
                                                                17)
                                                            .toDouble()
                                                        : 100,
                                                    margin: EdgeInsets.all(5),
                                                    padding: EdgeInsets.all(10),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                      border: Border.all(
                                                          color: (model
                                                                  .isSwitched)
                                                              ? model.borderColors[
                                                                  index]
                                                              : Colors.grey),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          offset: Offset(0, 4),
                                                          blurRadius: 30,
                                                          color: kShadowColor,
                                                        ),
                                                      ],
                                                    ),
                                                    child: Center(
                                                        child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: <Widget>[
                                                        Text(prefs.getStringList(
                                                                'notificationcountry')[
                                                            index]),
                                                        // SizedBox(width: 5),
                                                        GestureDetector(
                                                          onTap: () async {
                                                            await model.deleteNotificationCountry(
                                                                prefs.getStringList(
                                                                        'notificationcountry')[
                                                                    index],
                                                                prefs);
                                                            _scaffoldKey
                                                                .currentState
                                                                .showSnackBar(
                                                                    SnackBar(
                                                              content: Text(
                                                                "Country Removed From Notification Set",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                              duration:
                                                                  Duration(
                                                                      seconds:
                                                                          2),
                                                              backgroundColor:
                                                                  Colors
                                                                      .black87,
                                                            ));

                                                            print(
                                                                "Notification Canceled...");
                                                          },
                                                          child: Icon(
                                                            Icons.close,
                                                            size: 17,
                                                            color: (model
                                                                    .isSwitched)
                                                                ? Colors.red
                                                                : Colors.grey,
                                                          ),
                                                        )
                                                      ],
                                                    )),
                                                  );
                                                }).toList(),
                                              )),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
