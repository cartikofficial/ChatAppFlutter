import 'package:flutter/material.dart';
import '../services/auth_services.dart';
import 'package:groupie/screens/drawer.dart';
import 'package:groupie/shared/constants.dart';

class Profilescreen extends StatefulWidget {
  final String username;
  final String useremail;

  const Profilescreen({
    super.key,
    required this.username,
    required this.useremail,
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
        propic: "",
        selectd: true,
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
            const CircleAvatar(
              radius: 70,
              backgroundImage: AssetImage("assets/images/jassmanak.png"),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text(
                  "Full Name: ",
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                ),
                Text(widget.username, style: const TextStyle(fontSize: 16)),
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
                Text(widget.useremail, style: const TextStyle(fontSize: 16)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
