import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get total number of users
  Stream<int> getTotalUsers() {
    return _firestore.collection('users').snapshots().map((snapshot) {
      return snapshot.docs.length;
    });
  }
}
