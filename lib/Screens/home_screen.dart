import 'package:flutter/material.dart';
import 'package:groupie/Screens/Drawer.dart';
import 'package:groupie/widgets/widget.dart';
import 'package:groupie/shared/constants.dart';
import 'package:groupie/widgets/group_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:groupie/Screens/search_screen.dart';
import 'package:groupie/services/database_service.dart';

import '../services/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Stream? groups;
  bool isloading = false;
  String groupname = "";
  String username = "";
  final ValueNotifier<bool> toogle = ValueNotifier<bool>(true);

  @override
  void initState() {
    super.initState();
    getuserdata();
    gettinguserdata();
  }

  String getid(String res) {
    return res.substring(0, res.indexOf("_"));
  }

  String getgrouopnamne(String res) {
    return res.substring(res.indexOf("_") + 1);
  }

  void getuserdata() async {
    await Sharedprefererncedata.getusername().then((value) {
      setState(() {
        username = value;
      });
    });
  }

  void gettinguserdata() async {
    await Databaseservice(uid: FirebaseAuth.instance.currentUser!.uid)
        .getusergroups()
        .then((snapshot) {
      setState(() {
        groups = snapshot;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Userdrawer(),
      appBar: AppBar(
        backgroundColor: Constants().primarycolor,
        title: const Text(
          "Groups",
          style: TextStyle(fontSize: 30, color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              nextpage(context, const Searchpage());
            },
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: isloading
          ? Center(
              child: CircularProgressIndicator(
                color: Constants().primarycolor,
              ),
            )
          : grouplist(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          popUpDialoge(context);
        },
        elevation: 0,
        backgroundColor: Constants().primarycolor,
        child: const Icon(Icons.add, size: 35),
      ),
    );
  }

  popUpDialoge(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            "Creat a groups",
            textAlign: TextAlign.left,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) {
                  setState(() {
                    groupname = value;
                  });
                },
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(
                      color: Constants().primarycolor,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(
                      color: Constants().primarycolor,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Constants().primarycolor,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancle"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Constants().primarycolor,
              ),
              onPressed: () {
                if (groupname != "") {
                  setState(() {
                    isloading = true;
                  });
                  Databaseservice(uid: FirebaseAuth.instance.currentUser!.uid)
                      .creategroup(
                    username,
                    FirebaseAuth.instance.currentUser!.uid,
                    groupname,
                  )
                      .whenComplete(() {
                    setState(() {
                      isloading = false;
                    });
                  });
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Group Create sucessfully"),
                      duration: Duration(seconds: 8),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              },
              child: const Text(
                "Creat",
              ),
            ),
          ],
        );
      },
    );
  }

  grouplist() {
    return StreamBuilder(
      stream: groups,
      initialData: null,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data["Groups"] != null) {
            if (snapshot.data["Groups"].length != 0) {
              return ListView.builder(
                itemCount: snapshot.data["Groups"].length,
                itemBuilder: (context, index) {
                  int reverseindex = snapshot.data['Groups'].length - index - 1;
                  return Grouptile(
                    username: snapshot.data["Name"],
                    groupId: getid(snapshot.data["Groups"][reverseindex]),
                    groupname:
                        getgrouopnamne(snapshot.data["Groups"][reverseindex]),
                  );
                },
              );
            } else {
              return nongroupwidget();
            }
          } else {
            return nongroupwidget();
          }
        } else {
          return Center(
            child: CircularProgressIndicator(
              color: Constants().primarycolor,
            ),
          );
        }
      },
    );
  }

  nongroupwidget() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              popUpDialoge(context);
            },
            child: Icon(
              Icons.add_circle,
              size: 80,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            "you've not Joined any groups, tap on the add icon to creat a groups or you can also search from top search bar",
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
