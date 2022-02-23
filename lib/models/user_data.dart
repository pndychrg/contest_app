import 'package:firebase_auth/firebase_auth.dart';

class UserData {
  //getting uid as a object
  final String uid;

  UserData({required this.uid});
}

class UserSnapshotData {
  final String? uid;
  final String name;
  final List<dynamic> websitesList;
  final List<dynamic> contestList;
  UserSnapshotData(
      {required this.uid,
      required this.name,
      required this.websitesList,
      required this.contestList});
}
