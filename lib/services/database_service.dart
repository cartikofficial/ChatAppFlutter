import 'package:cloud_firestore/cloud_firestore.dart';

class Databaseservice {
  final String? uid;
  Databaseservice({this.uid});

  // References of our collections
  CollectionReference usercollection =
      FirebaseFirestore.instance.collection("Users");
  CollectionReference groupcollection =
      FirebaseFirestore.instance.collection("User_groups");

  // Saving user data to Firestore Database
  Future savinguserdata(String name, String email) async {
    return await usercollection.doc(uid).set({
      "Name": name,
      "Email": email,
      "Groups": [],
      "Profilepic": "",
      "User-Id": uid,
    });
  }

  // Getting the User data from Firestore Database
  Future gettinguserdata(String email) async {
    QuerySnapshot snapshot =
        await usercollection.where("Email", isEqualTo: email).get();
    return snapshot;
  }

  // Getting Users group data
  getusergroups() async {
    return usercollection.doc(uid).snapshots();
  }

  // Creating Groups for User
  Future creategroup(String username, String id, String groupname) async {
    DocumentReference groupdocumentReference = await groupcollection.add({
      "Groupname": groupname,
      "Admin": "${id}_$username",
      "Group-Id": "",
      "Members": [],
      "Recent message": "",
      "Recent message sender": "",
    });

    await groupdocumentReference.update({
      "Members": FieldValue.arrayUnion(["${uid}_$username"]),
      "Group-Id": groupdocumentReference.id,
    });

    DocumentReference userdocumentreference = usercollection.doc(uid);
    return await userdocumentreference.update({
      "Groups": FieldValue.arrayUnion([
        ("${groupdocumentReference.id}_$groupname"),
      ]),
    });
  }

  // Get Chats from database
  getchat(String groupId) async {
    return groupcollection
        .doc(groupId)
        .collection("User_messages")
        .orderBy("Time")
        .snapshots();
  }

  // Get group Admin
  Future getgroupAdmin(String groupId) async {
    DocumentReference d = groupcollection.doc(groupId);
    return d.collection("Admin").snapshots();
  }

  // Get group members
  getgroupmembers(groupId) async {
    return groupcollection.doc(groupId).snapshots();
  }

  // Search Groups
  searchgroupnames(String groupname) {
    return groupcollection.where("Groupname", isEqualTo: groupname).get();
  }

  // Is-user joined?
  Future isuserjoined(String groupname, String groupid, String username) async {
    // DocumentReference userdocumnetreference = usercollection.doc(uid);
    DocumentSnapshot documendSnapshot = await usercollection.doc(uid).get();
    List<dynamic> groups = await documendSnapshot["Groups"];
    if (groups.contains("${groupid}_$groupname")) {
      return true;
    } else {
      return false;
    }
  }

  // Toggeling the group entry and exit
  Future togglejoingroup(
      String groupid, String username, String groupname) async {
    DocumentReference userdocumentreference = usercollection.doc(uid);
    DocumentReference groupdocumnetreference = groupcollection.doc(groupid);
    DocumentSnapshot documendSnapshot = await userdocumentreference.get();
    List<dynamic> groups = await documendSnapshot["Groups"];

    // If user is already in group
    if (groups.contains("${groupid}_$groupname")) {
      await userdocumentreference.update({
        "Groups": FieldValue.arrayRemove(["${groupid}_$groupname"])
      });
      await groupdocumnetreference.update({
        "Members": FieldValue.arrayRemove(["${uid}_$username"])
      });
    } else {
      await userdocumentreference.update({
        "Groups": FieldValue.arrayUnion(["${groupid}_$groupname"])
      });
      await groupdocumnetreference.update({
        "Members": FieldValue.arrayUnion(["${uid}_$username"])
      });
    }
  }

  // Sendmessage
  sendmessage(String groupid, Map<String, dynamic> chatmessagesdata) async {
    groupcollection
        .doc(groupid)
        .collection("User_messages")
        .add(chatmessagesdata);
    groupcollection.doc(groupid).update({
      "Recent message": chatmessagesdata["Message"],
      "Recent message sender": chatmessagesdata["Sender"],
      "Recent message time": chatmessagesdata["Time"].toString(),
    });
  }
}
