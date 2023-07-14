import 'package:flutter/material.dart';
import 'package:groupie/widgets/widget.dart';
import 'package:groupie/shared/constants.dart';
import 'package:groupie/widgets/message_tile.dart';
import 'package:groupie/screens/group_info_screen.dart';
import 'package:groupie/services/database_service.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ChatsScreen extends StatefulWidget {
  final String currentusername;
  final String groupId;
  final String groupname;
  const ChatsScreen({
    super.key,
    required this.currentusername,
    required this.groupId,
    required this.groupname,
  });

  @override
  State<ChatsScreen> createState() => _ChatscreenState();
}

class _ChatscreenState extends State<ChatsScreen> {
  Stream? chats;
  String? admin;
  final TextEditingController messagecontroller = TextEditingController();

  @override
  void initState() {
    super.initState();
    getadminandchats();
  }

  void getadminandchats() async {
    Databaseservice().getchat(widget.groupId).then((value) {
      setState(() => chats = value);
    });
    await Databaseservice().getGroupAdmin(widget.groupId).then((value) {
      setState(() => admin = value);
    });
  }

  String subStringGroupName(String s) {
    return s.substring(0, s.indexOf("_"));
  }

  @override
  Widget build(BuildContext context) {
    print(admin);
    print(admin);
    print(widget.groupId);
    print(widget.groupId);

    ValueNotifier<bool> toggle = ValueNotifier<bool>(true);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(subStringGroupName(widget.groupname)),
          centerTitle: true,
          elevation: 0,
          backgroundColor: primarycolor,
          actions: [
            IconButton(
              onPressed: () async => nextpage(
                context,
                GroupInformationScreen(
                  groupadminname: admin!,
                  currentusername: widget.currentusername,
                  groupId: widget.groupId,
                  groupname: widget.groupname,
                ),
              ),
              icon: const Icon(Icons.info),
            ),
          ],
        ),
        body: Column(
          children: [
            // Chats
            Expanded(child: chatsandmessage()),

            //
            Container(
              width: double.infinity,
              alignment: Alignment.bottomCenter,
              child: Container(
                color: Colors.grey[700],
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 15,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: messagecontroller,
                        cursorColor: primarycolor,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "Send a message...",
                          hintStyle: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    toggle.value
                        ? IconButton(
                            onPressed: () {},
                            icon: FaIcon(
                              FontAwesomeIcons.paperclip,
                              color: primarycolor,
                            ),
                          )
                        : const SizedBox(),
                    GestureDetector(
                      onTap: () => sendmessage(),
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: primarycolor,
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
      ),
    );
  }

  StreamBuilder chatsandmessage() {
    return StreamBuilder(
      stream: chats,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          color: primarycolor.withOpacity(0.1),
          child: snapshot.hasData
              ? ListView.builder(
                  physics: constbouncebehaviour,
                  shrinkWrap: true,
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (BuildContext context, int index) => Messagetile(
                    message: snapshot.data.docs[index]["Message"],
                    sender: snapshot.data.docs[index]["Sender"],
                    sendedbyme: widget.currentusername.trim() ==
                        snapshot.data.docs[index]['Sender'],
                  ),
                )
              : null,
        );
      },
    );
  }

  void sendmessage() {
    if (messagecontroller.text.trim().isNotEmpty) {
      Map<String, dynamic> chatmessagemap = {
        "Message": messagecontroller.text.toString().trim(),
        "Sender": widget.currentusername.trim(),
        "Time": DateTime.now().microsecondsSinceEpoch.toString().trim(),
      };

      Databaseservice().sendMessage(
        widget.groupname,
        widget.groupId,
        chatmessagemap,
      );

      setState(() => messagecontroller.clear());
    }
  }
}
