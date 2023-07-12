import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:groupie/models/group_model.dart';
import 'package:groupie/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Databaseservice {
  final String? uid;
  Databaseservice({this.uid});

  // **************************************************
  // ********* References of our collections **********
  CollectionReference usercollection = FirebaseFirestore.instance.collection(
    "Users",
  );
  CollectionReference groupcollection = FirebaseFirestore.instance.collection(
    "User_groups",
  );

  // **************************************************
  // ********** Saving user data to Database **********
  Future savinguserdata(
    String name,
    String email,
    String profilepick,
  ) async {
    Usermodel usermodel = Usermodel(
      uid: uid!,
      name: name,
      email: email,
      profilepick: profilepick,
      groups: [],
    );

    await usercollection.doc(uid).set(usermodel.tojson());
  }

  // **************************************************
  // **************** Getting User data ***************
  Future<Usermodel> gettinguserdata() async {
    final DocumentSnapshot snapshot =
        await usercollection.doc(FirebaseAuth.instance.currentUser!.uid).get();

    if (kDebugMode) print(snapshot.data().toString());
    if (kDebugMode) print("Sucessfully getted userdata🤩");

    return Usermodel.getdatasnapshot(snapshot);
  }

  // **************************************************
  // ************** Getting User Groups ***************
  Future gettingusergroup() async {
    return usercollection
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .snapshots();
  }

  // **************************************************
  // **************** Creating Groups *****************
  Future creategroup(String username, String groupname) async {
    GroupModel groupmodel = GroupModel(
      adminName: "${username}_$uid",
      groupId: "${username}_$uid",
      groupName: groupname,
      recentMessage: "",
      recentMessageSender: "",
      members: [],
    );

    DocumentReference groupdocumentReference = await groupcollection.add(
      groupmodel.tojson(),
    );

    await groupdocumentReference.update({
      "Members": FieldValue.arrayUnion(["${username}_$uid"]),
    });

    DocumentReference userdocumentreference = usercollection.doc(uid);
    return await userdocumentreference.update({
      "Groups": FieldValue.arrayUnion([
        "${groupdocumentReference.id}_$groupname",
      ]),
    });
  }

  // **************************************************
  // ************** Getting all Groups ***************
  // Future<GroupModel> getallgroups() async {
  //   final DocumentSnapshot snapshot =
  //       await groupcollection.doc(FirebaseAuth.instance.currentUser!.uid).get();
  //   return GroupModel.datasnapshot(snapshot);
  // }

  // **************************************************
  // ***************** Getting Chats ******************
  Future getchat(String groupId) async {
    return groupcollection
        .doc(groupId)
        .collection("User_messages")
        .orderBy("Time")
        .snapshots();
  }

  // **************************************************
  // ************** Getting Group Admin ***************
  Future getgroupAdmin(String groupId) async {
    DocumentReference reference = groupcollection.doc(groupId);
    return reference.collection("Admin").snapshots();
  }

  // Get Group members
  Future getgroupmembers(groupId) async {
    return groupcollection.doc(groupId).snapshots();
  }

  // Search Groups
  Future searchGroupName(String groupname) {
    return groupcollection.where("Group-Name", isEqualTo: groupname).get();
  }

  // Is-user joined?
  Future isuserjoined(String groupname, String groupid, String username) async {
    DocumentSnapshot documendSnapshot = await usercollection.doc(uid).get();
    List<dynamic> groups = await documendSnapshot["Groups"];
    return groups.contains("${groupid}_$groupname") ? true : false;
  }

  // Toggeling the group entry and exit
  Future togglejoingroup(
    String groupid,
    String username,
    String groupname,
  ) async {
    DocumentReference userdocumentreference = usercollection.doc(uid);
    DocumentReference groupdocumnetreference = groupcollection.doc(groupid);
    DocumentSnapshot documendSnapshot = await userdocumentreference.get();
    List<dynamic> groups = await documendSnapshot["Groups"];

    // For Leaving the Group
    if (groups.contains("${groupid}_$groupname")) {
      await userdocumentreference.update({
        "Groups": FieldValue.arrayRemove(["${groupid}_$groupname"])
      });

      await groupdocumnetreference.update({
        "Members": FieldValue.arrayRemove(["${uid}_$username"])
      });
    }
    // For Joining the Group
    else {
      await userdocumentreference.update({
        "Groups": FieldValue.arrayUnion(["${groupid}_$groupname"])
      });

      await groupdocumnetreference.update({
        "Members": FieldValue.arrayUnion(["${uid}_$username"])
      });
    }
  }

  // **************************************************
  // ****************** Sendmessage *******************
  void sendmessage(
    String groupid,
    Map<String, dynamic> chatmessagesdata,
  ) async {
    groupcollection
        .doc(groupid)
        .collection("User_messages")
        .add(chatmessagesdata);
    groupcollection.doc(groupid).update({
      "Recent message": chatmessagesdata["Message"],
      "Recent message sender": chatmessagesdata["Sender"],
      "Recent message time": chatmessagesdata["Time"],
    });
  }
}
