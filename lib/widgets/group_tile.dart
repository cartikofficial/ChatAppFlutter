import 'package:flutter/material.dart';
import 'package:groupie/Screens/chat_screen.dart';
import 'package:groupie/shared/constants.dart';
import 'package:groupie/widgets/widget.dart';

class Grouptile extends StatefulWidget {
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
  State<Grouptile> createState() => _GrouptileState();
}

class _GrouptileState extends State<Grouptile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        nextpage(
          context,
          Chatscreen(
            username: widget.username,
            groupId: widget.groupId,
            groupname: widget.groupname,
          ),
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Constants().primarycolor,
            radius: 25,
            child: Text(
              widget.groupname.substring(0, 1),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
          ),
          title: Text(
            widget.groupname,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text("Join the group as ${widget.username}"),
        ),
      ),
    );
  }
}
