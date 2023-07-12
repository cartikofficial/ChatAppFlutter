// import 'package:flutter/material.dart';
// import 'package:groupie/models/group_model.dart';
// import 'package:groupie/services/database_service.dart';

// class GroupModelProvider extends ChangeNotifier {
//   GroupModel? _groupModel;

//   GroupModel get getchasgatsdata => _groupModel!;

//   Future<GroupModel> getchatsdata() async {
//     GroupModel groupModel = await Databaseservice().getallgroups();

//     _groupModel = groupModel;
//     notifyListeners();

//     return groupModel;
//   }
// }
