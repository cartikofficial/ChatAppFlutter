import 'package:flutter/material.dart';
import 'package:groupie/widgets/widget.dart';
import 'package:groupie/shared/constants.dart';
import 'package:groupie/screens/home_screen.dart';
import 'package:groupie/services/auth_services.dart';
import 'package:groupie/screens/profile_screen.dart';
import 'package:groupie/screens/login_in_screen.dart';

class Userdrawer extends StatelessWidget {
  final String title;
  final String propic;
  final String username;
  final String useremail;

  Userdrawer({
    super.key,
    required this.title,
    required this.propic,
    required this.useremail,
    required this.username,
  });

  final Authservices authservices = Authservices();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: const EdgeInsets.all(0),
        children: [
          UserAccountsDrawerHeader(
            currentAccountPictureSize: const Size.fromRadius(40),
            currentAccountPicture: ClipRRect(
              borderRadius: BorderRadius.circular(40),
              child: propic != ""
                  ? Image(image: NetworkImage(propic))
                  : const CircleAvatar(
                      backgroundColor: Colors.grey,
                      child: Icon(Icons.person, size: 65, color: Colors.white),
                    ),
            ),
            accountName: Text(username),
            accountEmail: Text(useremail),
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/backimage.png"),
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
          ListTile(
            onTap: () => title == "Profile"
                ? nextpage(context, const HomeScreen())
                : null,
            selected: title == "Groups",
            leading: const Icon(Icons.group),
            selectedColor: primarycolor,
            title: const Text("Group", style: TextStyle(color: Colors.black)),
          ),
          const Divider(height: 2),
          ListTile(
            onTap: () => title == "Groups"
                ? nextpage(
                    context,
                    Profilescreen(
                      username: username,
                      useremail: useremail,
                      profilepick:propic,
                    ),
                  )
                : null,
            selected: title == "Profile",
            selectedColor: primarycolor,
            leading: const Icon(Icons.account_box_sharp),
            title: const Text("Profile", style: TextStyle(color: Colors.black)),
          ),
          const Divider(height: 2),
          ListTile(
            onTap: () async {
              showDialog(
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
