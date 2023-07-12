import 'package:flutter/material.dart';
import 'package:groupie/widgets/widget.dart';
import 'package:groupie/shared/constants.dart';
import 'package:groupie/screens/chat_screen.dart';

class Grouptile extends StatelessWidget {
  final String username;
  final String groupId;
  final String groupname;
  const Grouptile({
    super.key,
    required this.username,
    required this.groupId,
    required this.groupname,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => nextpage(
        context,
        ChatsScreen(
          username: username,
          groupId: groupId,
          groupname: groupname,
        ),
      ),
      child: Container(
        width: double.infinity,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 5),
        margin: const EdgeInsets.only(left: 8, right: 8, top: 10),
        decoration: BoxDecoration(
          color: primarycolor.withOpacity(0.15),
          borderRadius: BorderRadius.circular(25),
        ),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: primarycolor,
            radius: 25,
            child: const Text(
              textAlign: TextAlign.center,
              "G",
              style: TextStyle(
                fontSize: 25,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          title: Text(
            groupname,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: const Text(
            "Click, to see what they were Chatting",
            style: TextStyle(fontSize: 13),
            maxLines: 2,
          ),
        ),
      ),
    );
  }
}
