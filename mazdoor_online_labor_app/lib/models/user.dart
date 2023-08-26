import 'package:flutter/cupertino.dart';

class UserData with ChangeNotifier{

  static final UserData _singleton = UserData._internal();

  late String full_name;
  late String email;
  late int id;
  late String? profile_image_url;
  late String phone_number;
  late int role;
  late bool active;
  late String? profile_image_name;

  factory UserData() {
    return _singleton;
  }

  UserData._internal();

  update_values_from_json(Map json){
    id = json['id'];
    full_name = json['full_name'];
    email = json["email"];
    phone_number = json["phone_number"];
    role = json["role"];
    profile_image_name = json["profile_image_name"];
    profile_image_url = json["profile_image_url"];
    active = json["active"];
    notifyListeners();
  }
}