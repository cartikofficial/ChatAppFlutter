import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:groupie/widgets/widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:groupie/services/database_service.dart';
import 'package:groupie/services/shared_preferences.dart';

class Authservices {
  FirebaseAuth firebaseauath = FirebaseAuth.instance;

  // Register
  Future registeruserwithemailandpassword(
      String name, String email, String password, context) async {
    try {
      // A user credential is a Username and Password authentication token that is bound to a particular user
      UserCredential userCredential =
          await firebaseauath.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await Databaseservice(uid: userCredential.user?.uid)
          .savinguserdata(name, email);
      return true;
    } on FirebaseAuthException catch (e) {
      showsnackbar(context, Colors.red, e);
    }
  }

  // Login
  Future signinuserwithemailandpassword(
      String email, String password, context) async {
    try {
      // UserCredential userCredential =
      await firebaseauath.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return true;
    } on FirebaseAuthException catch (e) {
      showsnackbar(context, Colors.red, e);
    }
  }

  // Google Signin
  Future signinwithgoogle() async {
    try {
      final GoogleSignInAccount? googleuser = await GoogleSignIn().signIn();
      if (googleuser != null) {
        GoogleSignInAuthentication googleauth = await googleuser.authentication;
        final OAuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleauth.accessToken,
          idToken: googleauth.idToken,
        );
        // UserCredential userCredential = await auth.signInWithCredential(
        //   credential,
        // );
        // We can also write code in this way
        // UserCredential userCredential = await auth.signInWithCredential(
        //   GoogleAuthProvider.credential(
        //     accessToken: googleauth.accessToken,
        //     idToken: googleauth.idToken,
        //   ),
        // );
        return true;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return null;
  }

  // Sign-out
  Future signout(context) async {
    try {
      await Sharedprefererncedata.saveuserlogedinstatus(false);
      await Sharedprefererncedata.saveuseremail("");
      await Sharedprefererncedata.saveusername("");
      await firebaseauath.signOut();
    } catch (e) {
      showsnackbar(context, Colors.red, e);
    }
  }
}
