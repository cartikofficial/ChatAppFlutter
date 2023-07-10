import 'package:flutter/material.dart';
import 'package:groupie/widgets/widget.dart';
import 'package:groupie/shared/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:groupie/Screens/home_screen.dart';
import 'package:groupie/services/auth_services.dart';
import 'package:groupie/services/database_service.dart';

class Groupinfowidget extends StatefulWidget {
  final String adminname;
  final String groupId;
  final String groupname;
  const Groupinfowidget({
    super.key,
    required this.adminname,
    required this.groupId,
    required this.groupname,
  });

  @override
  State<Groupinfowidget> createState() => _GroupinfowidgetState();
}

class _GroupinfowidgetState extends State<Groupinfowidget> {
  Stream? members;
  Authservices authservices = Authservices();
  @override
  void initState() {
    super.initState();
    getgroupmembers();
  }

  void getgroupmembers() async {
    Databaseservice(
      uid: FirebaseAuth.instance.currentUser!.uid,
    ).getgroupmembers(widget.groupId).then((value) {
      setState(() => members = value);
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
        backgroundColor: Constants().primarycolor,
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
                          color: Constants().primarycolor,
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
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Constants().primarycolor.withOpacity(0.2),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Constants().primarycolor,
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
                        "Groups: ${widget.groupname}",
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 5),
                      Text("Admin: ${widget.adminname}")
                    ],
                  )
                ],
              ),
            ),
            memberlist(),
          ],
        ),
      ),
    );
  }

  StreamBuilder memberlist() {
    return StreamBuilder(
      stream: members,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data["Members"] != null) {
            if (snapshot.data["Members"].length != 0) {
              return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data["Members"].length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 20,
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 30,
                        backgroundColor: Constants().primarycolor,
                        child: Text(
                          widget.groupname.substring(0, 1).toUpperCase(),
                          style: const TextStyle(
                            fontSize: 25,
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
            child: CircularProgressIndicator(color: Constants().primarycolor),
          );
        }
      },
    );
  }
}
