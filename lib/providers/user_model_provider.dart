import 'package:flutter/foundation.dart';
import 'package:groupie/models/user_model.dart';
import 'package:groupie/services/database_service.dart';

class UserModelProvider extends ChangeNotifier {
  Usermodel? _usermodel;

  Usermodel get getusermodeldata => _usermodel!;

  Future<Usermodel> getuserdata() async {
    Usermodel usermodel = await Databaseservice().gettinguserdata();

    _usermodel = usermodel;
    notifyListeners();

    return usermodel;
  }
}
