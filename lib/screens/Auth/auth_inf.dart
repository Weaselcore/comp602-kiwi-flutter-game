import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_game/screens/Auth/auth_inf.dart';
import 'package:google_sign_in/google_sign_in.dart';

//interface for singin
class AuthInf {
  Future<void> anonymousSignIn () async {}
  Future<void> anonymousSignOut() async {}
  Future<UserCredential?> googleSignIn () async {}
  Future<void> googleSignOut() async {}
  bool? isSignedIn() {}
}