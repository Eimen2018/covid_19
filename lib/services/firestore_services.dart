import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class FirestoreServices {
  final CollectionReference _tokenCollectionReference =
      Firestore.instance.collection('tokens');
  final FirebaseMessaging fcm = FirebaseMessaging();

  Future addNotificationCountry(List<String> countries) async {
    String token = await fcm.getToken();
    await _tokenCollectionReference.document(token).setData({
      'token': token,
      'createdAt': FieldValue.serverTimestamp(),
      'platform': Platform.operatingSystem,
      "countries": FieldValue.arrayUnion(countries),
      "notificationToggle": false,
    });
  }

  Future updateNotificationCountry(List<String> countries) async {
    String token = await fcm.getToken();
    await _tokenCollectionReference.document(token).updateData({
      "countries": FieldValue.arrayUnion(countries),
    });
  }

  Future deleteNotificationCountry(List<String> countries) async {
    String token = await fcm.getToken();
    await _tokenCollectionReference.document(token).updateData({
      "countries": FieldValue.arrayRemove(countries),
    });
  }
  

  Future notificationToggle(bool value)async{
    String token = await fcm.getToken();
    await _tokenCollectionReference.document(token).updateData({
      "notificationToggle": value,
    });
  }

  // Future deleteNotificationCountry(List<String> countries) async {
  //   String token = await fcm.getToken();
  //   await _tokenCollectionReference.document(token).updateData({
  //     "countries": FieldValue.arrayUnion(countries),
  //   });
  // }

}
