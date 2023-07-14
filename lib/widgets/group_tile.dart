import 'package:flutter/material.dart';
import 'package:groupie/widgets/widget.dart';
import 'package:groupie/shared/constants.dart';
import 'package:groupie/screens/chat_screen.dart';

class Grouptile extends StatelessWidget {
  final String currentusername;
  final String groupid;
  const Grouptile({
    super.key,
    required this.currentusername,
    required this.groupid,
  });

  String subStringGroupId(String s) {
    return s.substring(s.indexOf("_") + 1);
  }

  String subStringGroupName(String s) {
    return s.substring(0, s.indexOf("_"));
  }

  @override
  Widget build(BuildContext context) {
    print("Group Tile (●'◡'●)╰(*°▽°*)╯");
    print(currentusername);
    print(groupid);

    return GestureDetector(
      onTap: () => nextpage(
        context,
        ChatsScreen(
          currentusername: currentusername,
          groupId: groupid,
          groupname: groupid,
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
              subStringGroupName(groupid).substring(0, 1).toUpperCase(),
              style: const TextStyle(
                fontSize: 25,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          title: Text(
            subStringGroupName(groupid),
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
