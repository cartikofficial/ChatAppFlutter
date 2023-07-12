import 'package:flutter/material.dart';
import '../services/auth_services.dart';
import 'package:groupie/screens/drawer.dart';
import 'package:groupie/shared/constants.dart';

class Profilescreen extends StatefulWidget {
  final String username;
  final String useremail;
  final String profilepick;

  const Profilescreen({
    super.key,
    required this.username,
    required this.useremail,
    required this.profilepick,
  });

  @override
  State<Profilescreen> createState() => _ProfilescreenState();
}

class _ProfilescreenState extends State<Profilescreen> {
  final Authservices authservices = Authservices();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Drawer
      drawer: Userdrawer(
        title: "Profile",
        propic: widget.profilepick,
        useremail: widget.useremail,
        username: widget.username,
      ),

      // Appbar
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: primarycolor,
        title: const Text(
          "Profile",
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: widget.profilepick != ""
                      ? Image(
                          height: 100,
                          image: NetworkImage(widget.profilepick),
                        )
                      : const CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.grey,
                          child: Icon(
                            size: 75,
                            Icons.person,
                            color: Colors.white,
                          ),
                        ),
                ),
                Positioned(
                  bottom: 10,
                  right: 0,
                  child: GestureDetector(
                    onTap: () {},
                    child: const Icon(
                      Icons.add,
                      color: Colors.black,
                      weight: 2,
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text(
                  "Full Name: ",
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                ),
                Expanded(
                  child: Text(
                    widget.username,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
            const Divider(height: 20, thickness: 1),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text(
                  "Email: ",
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                ),
                Expanded(
                  child: Text(
                    widget.useremail,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
