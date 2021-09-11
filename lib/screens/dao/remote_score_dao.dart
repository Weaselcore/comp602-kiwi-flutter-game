import 'dart:collection';
import 'dart:ffi';

import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_game/screens/dao/local_score_dao.dart';
import 'package:hive/hive.dart';

import '../score_item.dart';

class RemoteScoreDao {

  late String _documentID;
  final String _BOXNAME = "documentID";
  late LocalScoreDao _localDao;

  RemoteScoreDao() {
    _localDao = new LocalScoreDao();
    _documentID = Hive.box(_BOXNAME).get(_BOXNAME);
  }

  void register() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
      // have internet access
      //TODO google authentication check
      //fetch local data
      List<ScoreItem> scores = _localDao.getAll();
      var data = [];
      //convert the list to object that firestore accepts.
      scores.forEach((ScoreItem item) {
        data.add({item.userNm : item.score});
      });
      //register local data to firestore
      await FirebaseFirestore.instance
          .collection('leaderboards').doc(_documentID).set({'ranking': data}, SetOptions(merge: true));
    } else {
      // no internet access
      return;
    }
  }
}