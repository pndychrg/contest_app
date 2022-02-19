import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contest_app/models/user_data.dart';

class DatabaseService {
  final String? uid;
  DatabaseService({required this.uid});

  //collection reference (pointer)
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  //Updating User Data
  Future updateUserData(String name) async {
    return await userCollection.doc(uid).set({'name': name});
  }

  // user Data from snapshot
  UserSnapshotData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    dynamic snapshot_data = snapshot.data();
    return UserSnapshotData(uid: uid, name: snapshot_data['name']);
  }

  //get user doc stream
  Stream<UserSnapshotData> get user_data {
    return userCollection.doc(uid).snapshots().map(_userDataFromSnapshot);
  }
  //getting user Data

}
