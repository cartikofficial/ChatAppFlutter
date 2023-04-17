import 'package:flutter/material.dart';
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
