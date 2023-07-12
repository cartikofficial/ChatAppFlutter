import 'package:flutter/material.dart';
import 'package:groupie/widgets/widget.dart';
import 'package:groupie/shared/constants.dart';
import 'package:groupie/services/auth_services.dart';
import 'package:groupie/screens/profile_screen.dart';
import 'package:groupie/screens/login_in_screen.dart';

class Userdrawer extends StatefulWidget {
  final bool selectd;
  final String propic;
  final String username;
  final String useremail;
  const Userdrawer({
    super.key,
    required this.propic,
    required this.selectd,
    required this.username,
    required this.useremail,
  });

  @override
  State<Userdrawer> createState() => _UserdrawerState();
}

class _UserdrawerState extends State<Userdrawer> {
  final Authservices authservices = Authservices();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: const EdgeInsets.all(0),
        children: [
          UserAccountsDrawerHeader(
            currentAccountPictureSize: const Size.fromRadius(40),
            currentAccountPicture: const CircleAvatar(
                // backgroundImage: NetworkImage(widget.propic),
                ),
            accountName: Text(widget.username),
            accountEmail: Text(widget.useremail),
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/backimage.png"),
              ),
            ),
          ),
          ListTile(
            onTap: () {},
            selected: widget.selectd,
            leading: const Icon(Icons.group),
            selectedColor: primarycolor,
            title: const Text("Group", style: TextStyle(color: Colors.black)),
          ),
          const Divider(height: 2),
          ListTile(
            onTap: () => nextpage(
              context,
              Profilescreen(
                username: widget.username,
                useremail: widget.useremail,
              ),
            ),
            selected: !widget.selectd,
            selectedColor: primarycolor,
            leading: const Icon(Icons.account_box_sharp),
            title: const Text("Profile", style: TextStyle(color: Colors.black)),
          ),
          const Divider(height: 2),
          ListTile(
            onTap: () async {
              showDialog(
                //if we click outside the box the box will not disapperar becausebarrierDismissible is false
                context: context,
                barrierDismissible: false,
                builder: (context) {
                  return AlertDialog(
                    title: const Text("Logout"),
                    content: const Text("Are you sure, you want to logout!"),
                    actions: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(
                          Icons.cancel,
                          color: primarycolor,
                        ),
                      ),
                      IconButton(
                        onPressed: () async =>
                            await authservices.signout(context).then((value) {
                          if (value == true) {
                            nextpagereplacement(context, const Loginscreen());
                          }
                        }),
                        icon: const Icon(Icons.done, color: Colors.green),
                      ),
                    ],
                  );
                },
              );
            },
            leading: const Icon(Icons.logout),
            selectedColor: primarycolor,
            title: const Text("Logout", style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }
}
