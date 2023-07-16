import 'package:flutter/material.dart';
import '../services/auth_services.dart';
import 'package:flutter/foundation.dart';
import 'package:groupie/widgets/drawer.dart';
import 'package:groupie/shared/constants.dart';
import 'package:image_picker/image_picker.dart';
import 'package:groupie/services/image_picker.dart';
import 'package:groupie/services/cloud_storage.dart';
import 'package:groupie/services/database_service.dart';

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
  String? viewableimage;
  Uint8List? selectedimage;
  bool isimageselected = false;
  final Authservices authservices = Authservices();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Drawer
      drawer: selectedimage == null
          ? Userdrawer(
              title: "Profile",
              propic: widget.profilepick,
              useremail: widget.useremail,
              username: widget.username,
            )
          : null,

      // Appbar
      appBar: selectedimage == null
          ? AppBar(
              centerTitle: true,
              backgroundColor: primarycolor,
              title: const Text(
                "Profile",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
            )
          : AppBar(
              backgroundColor: Colors.black,
              actions: [
                InkWell(
                  onTap: () async {
                    await uploadProfiletoAccount(selectedimage!, context);
                  },
                  child: const Text(
                    "Upload",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 20),
              ],
            ),

      // Body
      body: selectedimage == null
          ? Container(
              width: double.infinity,
              padding: const EdgeInsets.all(25),
              child: Column(
                children: [
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: widget.profilepick != "" ||
                                isimageselected == true
                            ? isimageselected == true
                                ? Image(
                                    height: 100,
                                    fit: BoxFit.cover,
                                    image: NetworkImage(viewableimage!),
                                  )
                                : Image(
                                    height: 100,
                                    fit: BoxFit.cover,
                                    image: NetworkImage(widget.profilepick),
                                  )
                            : CircleAvatar(
                                radius: 50,
                                backgroundColor: Colors.grey.withOpacity(0.7),
                                child: const Icon(
                                  size: 75,
                                  Icons.person,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                      if (!kIsWeb)
                        Positioned(
                          bottom: 2,
                          right: 0,
                          child: GestureDetector(
                            onTap: () async => await selectingImage(context),
                            child: const Icon(
                              Icons.add_a_photo,
                              weight: 2,
                              color: Colors.black,
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
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
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
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
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
            )
          : Scaffold(
              backgroundColor: Colors.black,
              body: Center(
                child: AspectRatio(
                  aspectRatio: 1 / 1,
                  child: Image(image: MemoryImage(selectedimage!)),
                ),
              ),
            ),
    );
  }

  Future selectingImage(context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          alignment: Alignment.centerLeft,
          elevation: 10,
          title: const Text("Upload Profile"),
          children: [
            SimpleDialogOption(
              padding: const EdgeInsets.only(left: 20, top: 5),
              onPressed: () async {
                Navigator.of(context).pop();

                Uint8List? file = await pickimage(ImageSource.camera);

                setState(() => selectedimage = file);
              },
              child: const Text("Take a photo"),
            ),
            SimpleDialogOption(
              padding: const EdgeInsets.only(left: 20, top: 25),
              onPressed: () async {
                Navigator.of(context).pop();

                Uint8List? file = await pickimage(ImageSource.gallery);

                setState(() => selectedimage = file);
              },
              child: const Text("Choose from gallery"),
            ),
          ],
        );
      },
    );
  }

  Future uploadProfiletoAccount(Uint8List image, context) async {
    String uploadableurl = await CloudStorageMethods().uploadProfilePick(
      context,
      image,
    );

    await Databaseservice().uploadProfilePick(uploadableurl);

    setState(() {
      isimageselected = true;
      viewableimage = uploadableurl;
      selectedimage = null;
    });
  }
}
