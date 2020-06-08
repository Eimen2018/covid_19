import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covid_19/app/locator.dart';
import 'package:covid_19/app/router.gr.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';

class MessageHandler extends StatefulWidget {
  final Widget child;

  const MessageHandler({Key key, this.child}) : super(key: key);
  @override
  _MessageHandlerState createState() => _MessageHandlerState();
}

class _MessageHandlerState extends State<MessageHandler> {
  final Firestore db = Firestore.instance;
  final FirebaseMessaging fcm = FirebaseMessaging();
  final NavigationService _navigationService = locator<NavigationService>();
  @override
  void initState() {
    super.initState();
    print("initiated");
    if (Platform.isIOS) {
      fcm.requestNotificationPermissions(IosNotificationSettings());
    } else {
      saveDeviceToken();
    }
    fcm.configure(onMessage: (Map<String, dynamic> message) async {
      print("message: OnMessage");
      print(message);
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                content: ListTile(
                    title:
                        Text(message['notification']['title'] ?? "ddnt come"),
                    subtitle:
                        Text(message['notification']['body'] ?? "ddnt come")),
                actions: <Widget>[
                  FlatButton.icon(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.close, color: Colors.red),
                      label:
                          Text("Close", style: TextStyle(color: Colors.red))),
                ],
              ));
    }, onResume: (Map<String, dynamic> message) async {
      print("message: OnResume");
      print(message);
      // _navigationService.navigateTo(Routes.homeView);
      await showDialog(
          context: context,
          builder: (context) => AlertDialog(
                content: ListTile(
                    title: Text(message['data']['title'] ?? "ddn't come"),
                    subtitle: Text(message['data']['body'] ?? "ddnt come")),
                actions: <Widget>[
                  FlatButton.icon(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.close, color: Colors.red),
                      label:
                          Text("Close", style: TextStyle(color: Colors.red))),
                ],
              ));
    }, onLaunch: (Map<String, dynamic> message) async {
      print("message: OnLaunch");
      print(message);
      // _navigationService.navigateTo(Routes.homeView);
      await showDialog(
          context: context,
          builder: (context) => AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(5.0)),
                content: ListTile(
                    title: Text(message['data']['title'] ?? "ddnt come"),
                    subtitle: Text(message['data']['body'] ?? "ddnt come")),
                actions: <Widget>[
                  FlatButton.icon(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.close, color: Colors.red),
                      label:
                          Text("Close", style: TextStyle(color: Colors.red))),
                ],
              ));
    });
  }

  saveDeviceToken() async {
    String fcmToken = await fcm.getToken();
    if (fcmToken != null) {
      var tokenRef = db.collection('tokens').document(fcmToken);
      tokenRef.get().then((docSnapshot) async {
        if (!docSnapshot.exists) {
          await tokenRef.setData({
            'token': fcmToken,
            'createdAt': FieldValue.serverTimestamp(),
            'platform': Platform.operatingSystem,
            'notificationToggle': false,
          });
          print("Device Added");
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
