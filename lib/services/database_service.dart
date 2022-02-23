import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contest_app/models/user_data.dart';

class DatabaseService {
  final String? uid;
  DatabaseService({required this.uid});

  //collection reference (pointer)
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  //Updating User Data
  Future updateUserData(String? name, List<dynamic>? websites_list,
      List<dynamic>? contest_list) async {
    return await userCollection.doc(uid).set({
      'name': name,
      'websites_list': websites_list,
      'contest_list': contest_list
    });
  }

  // user Data from snapshot
  UserSnapshotData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    dynamic snapshot_data = snapshot.data();
    return UserSnapshotData(
        uid: uid,
        name: snapshot_data['name'],
        websitesList: snapshot_data['websites_list'],
        contestList: snapshot_data['contest_list']);
  }

  //get user doc stream
  Stream<UserSnapshotData> get user_data {
    return userCollection.doc(uid).snapshots().map(_userDataFromSnapshot);
  }

  //getting user Data as a Map
  Future getUserDataMap() async {
    dynamic userData =
        await FirebaseFirestore.instance.collection("users").doc(uid).get();
    userData = userData.data();
    return userData;
  }
}
