import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_game/screens/Auth/auth_inf.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuth implements AuthInf {
  final _googleSignIn = GoogleSignIn();
  final _auth = FirebaseAuth.instance;

  @override
  Future<void> anonymousSignIn() async {
    await _auth.signInAnonymously();
  }

  @override
  Future<void> googleSignOut() async {
    await _googleSignIn.disconnect();
    await _auth.signOut();
  }

  @override
  bool? isSignedIn() {
    return _auth.currentUser != null;
  }

  @override
  Future<UserCredential?> googleSignIn() async {
    final user = await _googleSignIn.signIn();

    final GoogleSignInAuthentication googleAuth = await user!.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    await _auth.signInWithCredential(credential);
  }

  @override
  Future<void> anonymousSignOut() async {
    if (_auth.currentUser!.isAnonymous) {
      _auth.signOut();
    }
  }
}
