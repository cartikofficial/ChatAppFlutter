// ignore_for_file: must_be_immutable

import 'package:groupie/Screens/home_screen.dart';
import 'package:groupie/Screens/login_in_screen.dart';
import '../widgets/widget.dart';
import 'package:flutter/material.dart';
import '../services/auth_services.dart';
import 'package:groupie/shared/constants.dart';

class Profilescreen extends StatelessWidget {
  String username;
  String useremail;
  Profilescreen({super.key, required this.username, required this.useremail});

  Authservices authservices = Authservices();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: const EdgeInsets.all(0),
          children: [
            UserAccountsDrawerHeader(
              currentAccountPictureSize: const Size.fromRadius(40),
              currentAccountPicture: const CircleAvatar(
                backgroundImage: AssetImage("assets/images/jassmanak.png"),
              ),
              accountName: Text(username),
              accountEmail: Text(useremail),
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/backimage.png"),
                ),
              ),
            ),
            ListTile(
              onTap: () {
                nextpagereplacement(context, const HomeScreen());
              },
              leading: const Icon(Icons.group),
              selectedColor: Constants().primarycolor,
              title: const Text(
                "Group",
                style: TextStyle(color: Colors.black),
              ),
            ),
            const Divider(height: 2),
            ListTile(
              onTap: () {},
              selected: true,
              leading: const Icon(Icons.account_box_sharp),
              selectedColor: Constants().primarycolor,
              title: const Text(
                "Profile",
                style: TextStyle(color: Colors.black),
              ),
            ),
            const Divider(height: 2),
            ListTile(
              onTap: () async {
                showDialog(
                  // if we click outside the box the box will not disapperar becausebarrierDismissible is false
                  barrierDismissible: false,
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text("Logout"),
                      content: const Text("Are you sure, you want to logout!"),
                      actions: [
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(
                            Icons.cancel,
                            color: Constants().primarycolor,
                          ),
                        ),
                        IconButton(
                          onPressed: () async {
                            await authservices
                                .signout(context)
                                .whenComplete(() {
                              nextpage(context, const Loginscreen());
                            });
                          },
                          icon: const Icon(
                            Icons.done,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
              leading: const Icon(Icons.logout),
              selectedColor: Constants().primarycolor,
              title: const Text(
                "Logout",
                style: TextStyle(color: Colors.black),
              ),
            )
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Constants().primarycolor,
        title: const Text(
          "Profile",
          style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(30),
        width: double.infinity,
        child: Column(
          children: [
            const CircleAvatar(
              backgroundImage: AssetImage("assets/images/jassmanak.png"),
              radius: 70,
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Full Name : ", style: TextStyle(fontSize: 17)),
                Text(username, style: const TextStyle(fontSize: 17)),
              ],
            ),
            const Divider(height: 20, thickness: 1.1),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Email : ", style: TextStyle(fontSize: 17)),
                Text(useremail, style: const TextStyle(fontSize: 17)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
