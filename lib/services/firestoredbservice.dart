import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:education/models/User.dart' as usr;
import 'package:flutter/cupertino.dart';

class FirestoreDBService {
  final _instance = FirebaseFirestore.instance;

  Future<dynamic> getUsers() async {
    var list = [];
    var collectionReference = await _instance.collection('Users');
    var querySnapshot =
        await collectionReference.orderBy('point', descending: true).get();

    print(querySnapshot.docs.toString());
    for (var i = 0; i < querySnapshot.docs.length; ++i) {
      var map = {};
      map['point'] = querySnapshot.docs[i].data()['point'];
      map['fullname'] = querySnapshot.docs[i].data()['fullname'];
      map['level'] = querySnapshot.docs[i].data()['level'];
      list.add(map);
    }
    return list;
  }

  Future<dynamic> getCurrentUser() async {
    var auth = FirebaseAuth.instance;
    var user = auth.currentUser;
    var _user;
    try {
      var result = await _instance.collection('Users').doc('${user.uid}').get();
      if (result != null) {
        _user = usr.User.fromSnapshot(result);
      }
      return _user;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
