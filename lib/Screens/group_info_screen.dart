import 'package:flutter/material.dart';
import 'package:groupie/shared/constants.dart';
import 'package:groupie/widgets/widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:groupie/screens/home_screen.dart';
import 'package:groupie/services/auth_services.dart';
import 'package:groupie/services/database_service.dart';

class GroupInformationScreen extends StatefulWidget {
  final String adminname;
  final String groupId;
  final String groupname;
  const GroupInformationScreen({
    super.key,
    required this.adminname,
    required this.groupId,
    required this.groupname,
  });

  @override
  State<GroupInformationScreen> createState() => _GroupinfowidgetState();
}

class _GroupinfowidgetState extends State<GroupInformationScreen> {
  Stream? groupmembers;
  final Authservices authservices = Authservices();

  @override
  void initState() {
    super.initState();
    getGroupMembers();
  }

  void getGroupMembers() async {
    Databaseservice(
      uid: FirebaseAuth.instance.currentUser!.uid,
    ).getGroupMembers(widget.groupId).then((value) {
      setState(() => groupmembers = value);
    });
  }

  String getName(String r) {
    return r.substring(r.indexOf("_") + 1);
  }

  String getId(String id) {
    return id.substring(0, id.indexOf("_"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Group Info"),
        centerTitle: true,
        backgroundColor: primarycolor,
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text("Exit"),
                    content: const Text(
                      "Are you sure, you want to Exit from Group!",
                    ),
                    actions: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(
                          Icons.cancel,
                          color: primarycolor,
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          await Databaseservice(
                            uid: FirebaseAuth.instance.currentUser!.uid,
                          )
                              .togglejoingroup(
                            widget.groupId,
                            getName(widget.adminname),
                            widget.groupname,
                          )
                              .whenComplete(() {
                            nextpagereplacement(context, const HomeScreen());
                          });
                        },
                        icon: const Icon(Icons.done, color: Colors.green),
                      ),
                    ],
                  );
                },
              );
            },
            icon: const Icon(Icons.exit_to_app),
          )
        ],
      ),

      // Body
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: primarycolor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: primarycolor,
                    child: Text(
                      widget.groupname.substring(0, 1).toUpperCase(),
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        fontSize: 25,
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Group: ${widget.groupname}",
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 5),
                      Text("Admin: ${widget.adminname}")
                    ],
                  )
                ],
              ),
            ),
            membersList(),
          ],
        ),
      ),
    );
  }

  StreamBuilder membersList() {
    return StreamBuilder(
      stream: groupmembers,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data["Members"] != null) {
            if (snapshot.data["Members"].length != 0) {
              return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data["Members"].length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 22,
                        backgroundColor: primarycolor,
                        child: Text(
                          widget.groupname.substring(0, 1).toUpperCase(),
                          style: const TextStyle(
                            fontSize: 22,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      title: Text(getName(snapshot.data["Members"][index])),
                      subtitle: Text(getId(snapshot.data["Members"][index])),
                    ),
                  );
                },
              );
            } else {
              return const Center(child: Text("No Members"));
            }
          } else {
            return const Center(child: Text("No Members"));
          }
        } else {
          return Center(
            child: CircularProgressIndicator(color: primarycolor),
          );
        }
      },
    );
  }
}
