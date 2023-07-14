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
  // **************** Creating Groups *****************
  Future creategroup(String username, String groupname) async {
    GroupModel groupmodel = GroupModel(
      adminName: "${username}_$uid",
      groupId: "${groupname}_$uid",
      groupName: groupname,
      recentMessage: "",
      recentMessageSender: "",
      recentmessagetime: "",
      members: [],
    );

    await groupcollection.doc("${groupname}_$uid").set(groupmodel.tojson());

    DocumentReference groupdocumentReference = groupcollection.doc(
      "${groupname}_$uid",
    );
    await groupdocumentReference.update({
      "Members": FieldValue.arrayUnion(["${username}_$uid"]),
    });

    DocumentReference userdocumentreference = usercollection.doc(uid);
    return await userdocumentreference.update({
      "Groups": FieldValue.arrayUnion(["${groupname}_$uid"]),
    });
  }

  // **************************************************
  // ************** Getting User Groups ***************
  Future getUserGroups() async {
    return usercollection
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .snapshots();
  }

  // **************************************************
  // *************** upload profilepick ***************
  Future uploadProfilePick(String pick) async {
    DocumentReference reference = usercollection.doc(
      FirebaseAuth.instance.currentUser!.uid,
    );

    reference.update({"Profile-pick": pick});
  }

  // **************************************************
  // ************** Getting all Groups ***************
  // Future<GroupModel> getallgroups() async {
  //   final DocumentSnapshot snapshot =
  //       await groupcollection.doc(FirebaseAuth.instance.currentUser!.uid).get();
  //   return GroupModel.datasnapshot(snapshot);
  // }

  // **************************************************
  // ************** Getting Group Admin ***************
  Future<String> getGroupAdmin(String groupid) async {
    DocumentSnapshot docsnapshot = await groupcollection.doc(groupid).get();
    return await docsnapshot["Admin-Name"];
  }

  // **************************************************
  // ************** Getting Group Members *************
  Future getGroupMembers(String groupid) async {
    return groupcollection.doc(groupid).snapshots();
  }

  // **************************************************
  // ***************** Search Groups ****************
  Future searchGroupName(String groupname) {
    return groupcollection.where("Group-Name", isEqualTo: groupname).get();
  }

  // **************************************************
  // ***************** Is-user joined? ****************
  Future isUserJoined(String groupid) async {
    DocumentSnapshot documendSnapshot = await usercollection.doc(uid).get();
    List<dynamic> groups = await documendSnapshot["Groups"];

    return groups.contains(groupid) ? true : false;
  }

  // **************************************************
  // ******* Toggeling the group entry and exit *******
  Future toggleJoinorLeaveGroup(
    String groupid,
    String username,
  ) async {
    print("😕🎉👽 $groupid");
    print("😕🎉👽 $username");

    DocumentReference groupdocumnetreference = groupcollection.doc(groupid);
    DocumentReference userdocumentreference = usercollection.doc(uid);
    DocumentSnapshot documendSnapshot = await userdocumentreference.get();
    List<dynamic> groups = await documendSnapshot["Groups"];

    // For Leaving and Joining the Group
    if (groups.contains(groupid)) {
      await userdocumentreference.update({
        "Groups": FieldValue.arrayRemove([groupid]),
      });
      await groupdocumnetreference.update({
        "Members": FieldValue.arrayRemove(["${username}_$uid"]),
      });
    } else {
      await userdocumentreference.update({
        "Groups": FieldValue.arrayUnion([groupid]),
      });
      await groupdocumnetreference.update({
        "Members": FieldValue.arrayUnion(["${username}_$uid"]),
      });
    }
  }

  // **************************************************
  // ****************** Send message ******************
  void sendMessage(
    String gname,
    String groupid,
    Map<String, dynamic> chatmessagesdata,
  ) async {
    groupcollection
        .doc(groupid)
        .collection("User_messages")
        .add(chatmessagesdata);

    groupcollection.doc(groupid).update({
      "Recent-Message": chatmessagesdata["Message"],
      "Recent-Message-Sender": chatmessagesdata["Sender"],
      "Recent-Message-Time": chatmessagesdata["Time"],
    });
  }

  // **************************************************
  // ***************** Getting Chats ******************
  Future getchat(String gid) async {
    return groupcollection
        .doc(gid)
        .collection("User_messages")
        .orderBy("Time")
        .snapshots();
  }
}
