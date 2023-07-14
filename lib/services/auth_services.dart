import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:groupie/widgets/widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:groupie/services/database_service.dart';
import 'package:groupie/services/shared_preferences.dart';

class Authservices {
  final FirebaseAuth firebaseauath = FirebaseAuth.instance;

  // Register
  Future<bool> createuserwithemailandpassword(
    String name,
    String email,
    String password,
    context,
  ) async {
    try {
      // UserCredential is a Username and Password authentication token that is bound to a particular user
      UserCredential userCredential =
          await firebaseauath.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await Databaseservice(uid: userCredential.user!.uid).savinguserdata(
        name,
        email,
        "",
      );

      return true;
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) print("${e.toString()} ☹️☹️");
      snackbarmessage(context, Colors.red, e);
      Navigator.of(context).pop();
    }
    return false;
  }

  // Login
  Future<bool> signinuserwithemailandpassword(
    String email,
    String password,
    context,
  ) async {
    try {
      await firebaseauath.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return true;
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) print("${e.toString()} ☹️☹️");
      snackbarmessage(context, Colors.red, e);
      Navigator.of(context).pop();
    }
    return false;
  }

  // Google Signin
  Future<bool> signinwithgoogle(context) async {
    try {
      final GoogleSignInAccount? googleuser = await GoogleSignIn().signIn();

      if (googleuser != null) {
        showpopuploadingdialouge("Loading...", context);

        GoogleSignInAuthentication gauth = await googleuser.authentication;

        final OAuthCredential credential = GoogleAuthProvider.credential(
          accessToken: gauth.accessToken,
          idToken: gauth.idToken,
        );

        UserCredential usercredential =
            await firebaseauath.signInWithCredential(credential);

        if (usercredential.user != null) {
          await Databaseservice(uid: usercredential.user!.uid).savinguserdata(
            usercredential.user!.displayName!,
            usercredential.user!.email!,
            usercredential.user!.photoURL!,
          );
        }

        await Sharedprefererncedata.saveuseremail(usercredential.user!.email!);
        await Sharedprefererncedata.saveusername(
          usercredential.user!.displayName!,
        );
        await Sharedprefererncedata.saveuserlogedinstatus(true);

        return true;
      }
    } catch (e) {
      if (kDebugMode) print("${e.toString()} ☹️☹️");
      snackbarmessage(context, Colors.red, e);
      Navigator.of(context).pop();
    }
    return false;
  }

  // Sign-out
  Future signout(context) async {
    try {
      showpopuploadingdialouge("Loading...", context);

      await Sharedprefererncedata.saveuserlogedinstatus(false);
      await Sharedprefererncedata.saveuseremail("");
      await Sharedprefererncedata.saveusername("");
      await GoogleSignIn().signOut();
      await firebaseauath.signOut();

      Navigator.of(context).pop();

      return true;
    } catch (e) {
      if (kDebugMode) print("${e.toString()} ☹️☹️");
      snackbarmessage(context, Colors.red, e);
      Navigator.of(context).pop();
    }
  }
}
