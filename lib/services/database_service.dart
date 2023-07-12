import 'package:groupie/models/chat_model.dart';
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
    String? name,
    String? email,
    String? profilepick,
  ) async {
    Usermodel usermodel = Usermodel(
      uid: uid!,
      name: name!,
      email: email!,
      profilepick: profilepick!,
      groups: [],
    );

    await usercollection.doc(uid).set({usermodel.tojson()});
  }

  // **************************************************
  // ******* Getting the User data from Database ******
  Future gettinguserdata(String email) async {
    var snapshot = await usercollection.where("Email", isEqualTo: email).get();
    return snapshot;
  }

  // **************************************************
  // ************** Getting User Groups ***************
  Future getusergroups() async {
    return usercollection.doc(uid).snapshots();
  }

  // **************************************************
  // **************** Creating Groups *****************
  Future creategroup(String username, String id, String groupname) async {
    Chatmodel chatmodel = Chatmodel(
      groupId: "${username}_$id",
      groupName: groupname,
      adminName: "${username}_$id",
      recentMessage: "",
      recentMessageSender: "",
      members: [],
    );

    DocumentReference groupdocumentReference = await groupcollection.add({
      chatmodel.tojson(),
    });

    await groupdocumentReference.update({
      "Members": FieldValue.arrayUnion(["${uid}_$username"]),
      "Group-Id": groupdocumentReference.id,
    });

    DocumentReference userdocumentreference = usercollection.doc(uid);
    return await userdocumentreference.update({
      "Groups": FieldValue.arrayUnion([
        "${groupdocumentReference.id}_$groupname",
      ]),
    });
  }
 
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
    DocumentReference d = groupcollection.doc(groupId);
    return d.collection("Admin").snapshots();
  }

  // Get Group members
  Future getgroupmembers(groupId) async {
    return groupcollection.doc(groupId).snapshots();
  }

  // Search Groups
  Future searchgroupnames(String groupname) {
    return groupcollection.where("Groupname", isEqualTo: groupname).get();
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
