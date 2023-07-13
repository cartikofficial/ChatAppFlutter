// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:groupie/services/cloud_storage.dart';
// import 'package:groupie/services/database_service.dart';

// class ViewProfilePipck extends StatelessWidget {
//   final Uint8List image;
//   const ViewProfilePipck({super.key, required this.image});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         backgroundColor: Colors.black,
//         actions: [
//           InkWell(
//             onTap: () {},
//             child: const Text(
//               "Upload",
//               style: TextStyle(
//                 fontSize: 16,
//                 color: Colors.blue,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//           const SizedBox(width: 20),
//         ],
//       ),
//       body: Center(
//         child: AspectRatio(
//           aspectRatio: 1 / 1,
//           child: Image(image: MemoryImage(image)),
//         ),
//       ),
//     );
//   }

//   Future uploadProfiletoAccount(Uint8List? selectedimage) async {
//     if (selectedimage != null) {
//       String uploadableurl =
//           await CloudStorageMethods().uploadProfilePick(selectedimage);
//       Databaseservice().uploadProfilePick(uploadableurl);
//       // setState(() {
//       //   widget.profilepick = uploadableurl;
//       // });
//     }
//   }
// }
