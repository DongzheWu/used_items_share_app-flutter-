
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class User{
  User({@required this.uid});
  final String uid;
}
//Build the Auth base
abstract class AuthBase{
  Future<User> currentUser();
  Future<User> signInAnonymously();
  Future<void> signOut();
  Future<User> signInWithGoogle();
  Stream<User> get onAuthStateChanged;
  Future<User> signInWithEmailAndPassword(String email, String password);
  Future<User> createUserWithEmailAndPassword(String email, String password);
}
// Build the Auth class to check if the user has signed in
class Auth implements AuthBase{
  final _firebaseAuth = FirebaseAuth.instance;
  User _userFromFirebase(FirebaseUser user){
    if( user == null){
      return null;
    }
    return User(uid: user.uid);
  }
  @override
  Stream<User> get onAuthStateChanged{
    return _firebaseAuth.onAuthStateChanged.map(_userFromFirebase);
  }
// Check current User
  @override
  Future<User> currentUser() async{
    final user = await _firebaseAuth.currentUser();
    return _userFromFirebase(user);
  }
  // Sign in as a guest
  @override
  Future<User> signInAnonymously() async{
    final authResult = await _firebaseAuth.signInAnonymously();
    return _userFromFirebase(authResult.user);
  }
// Sigin in with the email
  @override
  Future<User> signInWithEmailAndPassword(String email, String password) async {
    final authResult = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    return _userFromFirebase(authResult.user);
  }
// Register with the email
  @override
  Future<User> createUserWithEmailAndPassword(
      String email, String password) async {
    final authResult = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    return _userFromFirebase(authResult.user);
  }
// Sigin in with the Google
  @override
  Future<User> signInWithGoogle() async{
    GoogleSignIn googleSignIn = GoogleSignIn();
    GoogleSignInAccount googleAccount = await googleSignIn.signIn();
    if(googleAccount != null){
      GoogleSignInAuthentication googleAuth = await googleAccount.authentication;
      if(googleAuth.accessToken != null && googleAuth.idToken != null) {
        final authResult = await _firebaseAuth.signInWithCredential(
            GoogleAuthProvider.getCredential(
                idToken: googleAuth.idToken,
                accessToken: googleAuth.accessToken
            )
        );
        return _userFromFirebase(authResult.user);
      }else{
        throw PlatformException(
          code: 'ERROR_MISSING_GOOGLE_AUTH_TOKEN',
          message: 'Missing Google Auth Token',
        );
      }
    }else{
      throw PlatformException(
        code: 'ERROR_ABORTED_BY_USER',
        message: 'Sign in aborted by user',
      );
    }
  }

  @override
  Future<void> signOut() async{
    final googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
    await _firebaseAuth.signOut();
  }
}