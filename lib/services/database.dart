import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  // collection reference
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  Future<void> createUserData(String uid, String name) async {
    try {
      await userCollection.doc(uid).set({
        'name': name,
      });
    } catch (e) {
      print('Error creating user data: $e');
    }
  }

  Future<void> updateUserData(String uid, String name) async {
    try {
      await userCollection.doc(uid).set({
        'name': name,
      });
    } catch (e) {
      print('Error updating user data: $e');
    }
  }
}
