import 'package:cloud_firestore/cloud_firestore.dart';

class Usermodel {
  final String uid;
  final String name;
  final String email;
  final String profilepick;
  final List groups;

  const Usermodel({
    required this.uid,
    required this.name,
    required this.email,
    required this.profilepick,
    required this.groups,
  });

  Map<String, dynamic> tojson() => {
        "User-Id": uid,
        "Name": name,
        "Email": email,
        "Profile-pick": profilepick,
        "Groups": [],
      };

  factory Usermodel.datasnapshot(DocumentSnapshot snapshot) {
    final Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return Usermodel(
      uid: data["User-Id"],
      name: data["Name"],
      email: data["Email"],
      profilepick: data["Profile-pick"],
      groups: data["Groups"],
    );
  }
}
