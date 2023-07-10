import 'package:flutter/material.dart';
import 'package:groupie/widgets/widget.dart';
import 'package:groupie/shared/constants.dart';
import 'package:groupie/widgets/message_tile.dart';
import 'package:groupie/Screens/group_info_screen.dart';
import 'package:groupie/services/database_service.dart';

class Chatscreen extends StatefulWidget {
  final String username;
  final String groupId;
  final String groupname;
  const Chatscreen({
    super.key,
    required this.username,
    required this.groupId,
    required this.groupname,
  });

  @override
  State<Chatscreen> createState() => _ChatscreenState();
}

class _ChatscreenState extends State<Chatscreen> {
  Stream? chats;
  String admin = "";
  final TextEditingController messagecontroller = TextEditingController();

  @override
  void initState() {
    super.initState();
    getadminandchats();
  }

  void getadminandchats() {
    Databaseservice().getchat(widget.groupId).then((value) {
      setState(() {
        chats = value;
      });
    });
    Databaseservice().getgroupAdmin(widget.groupId).then((value) {
      setState(() {
        admin = value.toString();
      });
    });
  }

  // void firebaseshownotification() {
  //   if (kDebugMode) print("Notification Sended");

  //   flutterLocalNotificationsPlugin.show(
  //     1,
  //     "this notificatio is sended by $admin",
  //     "How's your day",
  //     NotificationDetails(
  //       android: AndroidNotificationDetails(
  //         chanel.id,
  //         chanel.name,
  //         importance: Importance.high,
  //         color: Colors.redAccent,
  //         playSound: true,
  //         icon: "assets/images/Logo.png",
  //       ),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.groupname),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Constants().primarycolor,
        actions: [
          IconButton(
            onPressed: () => nextpage(
              context,
              Groupinfowidget(
                groupId: widget.groupId,
                adminname: widget.username,
                groupname: widget.groupname,
              ),
            ),
            icon: const Icon(Icons.info),
          ),
        ],
      ),
      body: Column(
        children: [
          // *************************************************
          // **************** Chats/Messages *****************
          Expanded(
            child: chatsandmessage(),
          ),
          Container(
            width: double.infinity,
            alignment: Alignment.bottomCenter,
            child: Container(
              color: Colors.grey[700],
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 15),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: messagecontroller,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Send a message...",
                        hintStyle: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  GestureDetector(
                    onTap: () => sendmessage(),
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Constants().primarycolor,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Center(
                        child: Icon(Icons.send, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  StreamBuilder chatsandmessage() {
    return StreamBuilder(
      stream: chats,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          color: Constants().primarycolor.withOpacity(0.1),
          child: snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (BuildContext context, int index) => Messagetile(
                    message: snapshot.data.docs[index]["Message"],
                    sender: snapshot.data.docs[index]["Sender"],
                    sendedbyme: widget.username.trim() ==
                        snapshot.data.docs[index]['Sender'],
                  ),
                )
              : Container(),
        );
      },
    );
  }

  void sendmessage() {
    if (messagecontroller.text.isNotEmpty) {
      Map<String, dynamic> chatmessagemap = {
        "Message": messagecontroller.text.toString().trim(),
        "Sender": widget.username.trim(),
        "Time": DateTime.now().microsecondsSinceEpoch.toString().trim(),
      };

      Databaseservice().sendmessage(widget.groupId, chatmessagemap);

      setState(() {
        messagecontroller.clear();
      });
    }
  }
}
