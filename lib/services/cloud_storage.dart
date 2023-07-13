import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:groupie/widgets/widget.dart';

class CloudStorageMethods {
  final FirebaseStorage firebasestorage = FirebaseStorage.instance;

  // Upload profile pick
  Future<String> uploadProfilePick(context, Uint8List file) async {
    showpopuploadingdialouge("Posting...", context);

    Reference refe = firebasestorage
        .ref()
        .child("Profile_Pick")
        .child(FirebaseAuth.instance.currentUser!.uid);

    TaskSnapshot taskSnapshot = await refe.putData(file);
    String getdownloadableurl = await taskSnapshot.ref.getDownloadURL();

    Navigator.of(context).pop();

    return getdownloadableurl;
  }
}
