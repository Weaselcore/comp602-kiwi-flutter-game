import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_game/screens/Auth/auth_inf.dart';
import 'package:flutter_game/screens/Auth/google_auth.dart';
import 'package:flutter_game/screens/dao/local_score_dao.dart';
import 'package:google_sign_in/google_sign_in.dart';
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
      //authentication check
      AuthInf auth = new GoogleAuth();
      bool isAnonymous = false;
      if (auth.isSignedIn() == false) {
        await auth.anonymousSignIn();
        isAnonymous = true;
      }

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

      //if a user sign in as anonymous. Don't forget to sign out. Otherwise, user will be treated as sign in user on the setting screen.
      if (isAnonymous) {
        auth.anonymousSignOut();
      }

    } else {
      // no internet access
      return;
    }
  }
}