import 'package:flutter/material.dart';
import 'package:groupie/widgets/widget.dart';
import 'package:groupie/shared/constants.dart';
import 'package:groupie/screens/chat_screen.dart';

class Grouptile extends StatelessWidget {
  final String currentusername;
  final String groupid;
  final String groupname;
  const Grouptile({
    super.key,
    required this.currentusername,
    required this.groupid,
    required this.groupname,
  });

  @override
  Widget build(BuildContext context) {
    String gid = groupid.substring(0);
    String gname = groupname.substring(groupname.indexOf("_") + 1);
    print(gid);
    print(currentusername);

    return GestureDetector(
      onTap: () => nextpage(
        context,
        ChatsScreen(
          currentusername: currentusername,
          groupId: groupid,
          groupname: gname,
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
            child: Text(
              textAlign: TextAlign.center,
              gname.substring(0, 1).toUpperCase(),
              style: const TextStyle(
                fontSize: 25,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          title: Text(
            groupname.substring(groupname.indexOf("_") + 1),
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
