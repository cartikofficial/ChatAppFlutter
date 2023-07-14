import 'package:flutter/material.dart';
import 'package:groupie/screens/chat_screen.dart';
import 'package:groupie/shared/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:groupie/services/database_service.dart';
import 'package:groupie/widgets/widget.dart';

class Searchpage extends StatefulWidget {
  final String currentusername;
  const Searchpage({super.key, required this.currentusername});

  @override
  State<Searchpage> createState() => _SearchpageState();
}

class _SearchpageState extends State<Searchpage> {
  bool isjoined = false;
  bool isloading = false;
  String currentusername = "";
  bool hasusersearched = false;
  QuerySnapshot? searchsnapshot;
  final User user = FirebaseAuth.instance.currentUser!;
  // final ValueNotifier<bool> toogle = ValueNotifier<bool>(true);
  final TextEditingController searchcontroller = TextEditingController();

  // @override
  // void initState() {
  //   super.initState();
  //   // getusernameandId();
  // }
  // void getusernameandId() async {
  //   user = FirebaseAuth.instance.currentUser;
  // }

  String subStringGroupId(String s) {
    return s.substring(s.indexOf("_") + 1);
  }

  String subStringAdminName(String s) {
    return s.substring(0, s.indexOf("_"));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SafeArea(
        child: Scaffold(
          // AppBar
          appBar: AppBar(
            elevation: 0,
            backgroundColor: primarycolor,
            title: const Text(
              "Search",
              style: TextStyle(
                fontSize: 25,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Body
          body: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: primarycolor,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(25),
                    bottomRight: Radius.circular(25),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: searchcontroller,
                        cursorColor: Colors.white,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          hintText: "Search Groups....",
                          hintStyle: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => iniatiatesearchmethod(),
                      child: Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(Icons.search, color: Colors.white),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 20),
              isloading
                  ? Center(
                      child: CircularProgressIndicator(color: primarycolor),
                    )
                  : hasusersearched
                      ? grouplist()
                      : Text(
                          textAlign: TextAlign.center,
                          "Search your Group",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey.withOpacity(0.8),
                          ),
                        ),
            ],
          ),
        ),
      ),
    );
  }

  void iniatiatesearchmethod() async {
    if (searchcontroller.text.toString().trim().isNotEmpty) {
      setState(() => isloading = true);

      await Databaseservice()
          .searchGroupName(searchcontroller.text.toString().trim())
          .then((snapshot) {
        setState(() {
          isloading = false;
          hasusersearched = true;
          searchsnapshot = snapshot;
        });
      });
    }
  }

  Widget grouplist() {
    return searchsnapshot!.docs.isNotEmpty
        ? ListView.builder(
            shrinkWrap: true,
            physics: constbouncebehaviour,
            itemCount: searchsnapshot!.docs.length,
            itemBuilder: (BuildContext context, int index) {
              print("search screen 🤩🤩");
              print(searchsnapshot!.docs[index]["Group-Id"]);
              print(searchsnapshot!.docs[index]["Group-Name"]);
              print(searchsnapshot!.docs[index]["Admin-Name"]);

              // Function to checking that the user has alredy logined or not
              joinedornot(searchsnapshot!.docs[index]["Group-Id"]);

              return groupTile(
                currentusername,
                searchsnapshot!.docs[index]["Group-Id"],
                searchsnapshot!.docs[index]["Group-Name"],
                searchsnapshot!.docs[index]["Admin-Name"],
              );
            })
        : Text(
            textAlign: TextAlign.center,
            "Group not found, please check the group name",
            style: TextStyle(fontSize: 18, color: Colors.grey.withOpacity(0.8)),
          );
  }

  Widget groupTile(
    String currentusername,
    String groupid,
    String groupname,
    String adminname,
  ) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      leading: CircleAvatar(
        radius: 25,
        backgroundColor: primarycolor,
        child: Text(
          groupname.substring(0, 1).toUpperCase(),
          style: const TextStyle(color: Colors.white),
        ),
      ),
      title: Text(
        groupname,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
      ),
      subtitle: Text(
        "Admin: ${subStringAdminName(adminname)}",
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontSize: 13),
      ),
      trailing: InkWell(
        onTap: () async {
          await Databaseservice(uid: user.uid).toggleJoinorLeaveGroup(
            groupid,
            widget.currentusername,
          );

          if (isjoined == false) {
            setState(() {
              isjoined = !isjoined;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Left the group $groupname"),
                  duration: const Duration(milliseconds: 1500),
                  backgroundColor: Colors.red,
                ),
              );
            });
          } else {
            setState(() {
              isjoined != isjoined;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Sucessfully joined the group"),
                  duration: Duration(milliseconds: 1500),
                  backgroundColor: Colors.green,
                ),
              );
            });
            Future.delayed(
              const Duration(seconds: 1),
              () {
                Navigator.of(context).pop();
                nextpage(
                  context,
                  ChatsScreen(
                    currentusername: currentusername,
                    groupId: groupid,
                    groupname: groupid,
                  ),
                );
              },
            );
          }
        },
        child: isjoined
            ? Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 12,
                ),
                child: const Text(
                  "Joined",
                  style: TextStyle(color: Colors.white),
                ),
              )
            : Container(
                decoration: BoxDecoration(
                  color: primarycolor,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 12,
                ),
                child: const Text(
                  "Join now",
                  style: TextStyle(color: Colors.white),
                ),
              ),
      ),
    );
  }

  void joinedornot(String groupid) async {
    await Databaseservice(uid: user.uid).isUserJoined(groupid).then((value) {
      setState(() => isjoined = value);
    });
  }
}
