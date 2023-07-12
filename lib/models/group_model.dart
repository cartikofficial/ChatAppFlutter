import 'package:cloud_firestore/cloud_firestore.dart';

class GroupModel {
  final String groupId;
  final String groupName;
  final String adminName;
  final String recentMessage;
  final String recentMessageSender;
  final List members;

  const GroupModel({
    required this.groupId,
    required this.groupName,
    required this.adminName,
    required this.recentMessage,
    required this.recentMessageSender,
    required this.members,
  });

  Map<String, dynamic> tojson() => {
        "Group-Id": groupId,
        "Group-Name": groupName,
        "Admin-Name": adminName,
        "Recent-Message": "",
        "Recent-Message-Sender": "",
        "Members": [],
      };

  factory GroupModel.datasnapshot(DocumentSnapshot snapshot) {
    final Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return GroupModel(
      groupId: data["Group-Id"],
      groupName: data["Group-Name"],
      adminName: data["Admin-Name"],
      recentMessage: data["Recent-Message"],
      recentMessageSender: data["Recent-Message-Sender"],
      members: data["Members"],
    );
  }
}
