import 'package:firebase_auth/firebase_auth.dart';

//interface for singin
class AuthInf {
  Future<void> anonymousSignIn() async {}
  Future<void> anonymousSignOut() async {}
  Future<UserCredential?> googleSignIn() async {}
  Future<void> googleSignOut() async {}
  bool? isSignedIn() {}
}
