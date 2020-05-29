import 'dart:async';
import 'package:covid_19/constant.dart';
import 'package:covid_19/ui/views/setting/setting_viewmodel.dart';
import 'package:covid_19/widgets/my_header.dart';
import 'package:covid_19/widgets/settingsearch.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';

class SettingView extends StatefulWidget {
  @override
  _SettingViewState createState() => _SettingViewState();
}

class _SettingViewState extends State<SettingView> {
  final controller = ScrollController();
  double offset = 0;

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

  @override
  Widget build(BuildContext context) {
    // var connectionStatus = Provider.of<ConnectivityStatus>(context);
    return ViewModelBuilder<SettingViewModel>.reactive(
      onModelReady: (model) async {
        prefs = await SharedPreferences.getInstance();
        model.fetchAllcountries();
      },
      viewModelBuilder: () => SettingViewModel(),
      builder: (context, model, child) => Scaffold(
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
                              Icon(
                                Icons.arrow_back_ios,
                                color: Colors.white,
                              ),
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
                                onChanged: (value) {
                                  model.isSwitched = value;
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
                                          "Countries to Watch Data Change",
                                        ),
                                        (!model.checkSharedpreference(prefs))
                                            ? InkWell(
                                                onTap:
                                                    (model.checkcountryDataandLength(
                                                                prefs) ||
                                                            !model.isSwitched)
                                                        ? null
                                                        : () {
                                                            model.searchPage(
                                                                context, prefs);
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
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: <Widget>[
                                                    Text(model.getPrefLength(
                                                            prefs) +
                                                        "/4"),
                                                    SizedBox(width: 5),
                                                    Container(
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
                                                  ],
                                                ),
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
                                                                context, prefs);
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
                                                          onTap: () {
                                                            model.deleteNotificationCountry(
                                                                prefs.getStringList(
                                                                        'notificationcountry')[
                                                                    index],
                                                                prefs);
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
