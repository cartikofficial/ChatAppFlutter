import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:groupie/widgets/widget.dart';
import 'package:groupie/Screens/drawer.dart';
import 'package:groupie/shared/constants.dart';
import 'package:groupie/widgets/group_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:groupie/screens/search_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:groupie/services/database_service.dart';
import 'package:groupie/providers/user_model_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String groupname = "";
  bool isloading = false;
  Stream? usercreatedgroups;
  Stream<QuerySnapshot<Map<String, dynamic>>>? s;
  final ValueNotifier<bool> toogle = ValueNotifier<bool>(true);

  @override
  void initState() {
    super.initState();
    getUserGroups();
    callingusermodelprovider(context);
  }

  Future getUserGroups() async {
    await Databaseservice().getUserGroups().then((snapshot) {
      setState(() => usercreatedgroups = snapshot);
    });
  }

  callingusermodelprovider(context) async {
    await Provider.of<UserModelProvider>(context, listen: false).getuserdata();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserModelProvider>(
      builder: (context, value, child) {
        return Scaffold(
          // Drawer
          drawer: Userdrawer(
            title: "Groups",
            propic: value.getusermodeldata.profilepick,
            useremail: value.getusermodeldata.email,
            username: value.getusermodeldata.name,
          ),

          // AppBar
          appBar: AppBar(
            backgroundColor: primarycolor,
            title: const Text(
              "Groups",
              style: TextStyle(fontSize: 28, color: Colors.white),
            ),
            centerTitle: true,
            actions: [
              IconButton(
                onPressed: () => nextpage(
                  context,
                  Searchpage(currentusername: value.getusermodeldata.name),
                ),
                icon: const Icon(Icons.search),
              ),
            ],
          ),

          // Body
          body: isloading
              ? Center(child: CircularProgressIndicator(color: primarycolor))
              : groupinfowidget(value.getusermodeldata.name),

          // Floating Action Button
          floatingActionButton: FloatingActionButton(
            elevation: 0,
            backgroundColor: primarycolor,
            child: const Icon(Icons.add, size: 35),
            onPressed: () => createyourgrouppopup(
              context,
              value.getusermodeldata.name,
            ),
          ),
        );
      },
    );
  }

  StreamBuilder<dynamic> groupinfowidget(String currentusername) {
    return StreamBuilder(
      stream: usercreatedgroups,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data["Groups"].length != 0) {
            return ListView.builder(
              shrinkWrap: true,
              physics: constbouncebehaviour,
              itemCount: snapshot.data["Groups"].length,
              itemBuilder: (context, index) {
                int rindex = snapshot.data["Groups"].length - index - 1;
                return Grouptile(
                  currentusername: currentusername,
                  groupid: snapshot.data["Groups"][rindex],
                );
              },
            );
          } else {
            return nongroupwidget(currentusername);
          }
        } else {
          return Center(child: CircularProgressIndicator(color: primarycolor));
        }
      },
    );
  }

  Center nongroupwidget(String currentusername) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () => createyourgrouppopup(context, currentusername),
              child: Icon(size: 80, Icons.add_circle, color: Colors.grey[700]),
            ),
            const SizedBox(height: 10),
            const Text(
              "you've not Joined any groups, tap on the add icon to creat a groups or you can also search from top search bar",
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void createyourgrouppopup(context, String currentusername) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text("Create a group", textAlign: TextAlign.left),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) => setState(() => groupname = value),
                cursorColor: primarycolor,
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: primarycolor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: primarycolor),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(color: Colors.red),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: primarycolor),
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancle"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: primarycolor),
              onPressed: () {
                if (groupname != "") {
                  setState(() => isloading = true);

                  Databaseservice(uid: FirebaseAuth.instance.currentUser!.uid)
                      .creategroup(currentusername, groupname.trim())
                      .whenComplete(() {
                    setState(() => isloading = false);
                  });

                  Navigator.of(context).pop();

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Group Created Sucessfully"),
                      backgroundColor: Colors.green,
                      duration: Duration(seconds: 4),
                    ),
                  );
                }
              },
              child: const Text("Create"),
            ),
          ],
        );
      },
    );
  }
}
