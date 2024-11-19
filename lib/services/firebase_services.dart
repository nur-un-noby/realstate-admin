import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserCredential> signIn(String email, String password) async {
    return await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> addProperty({
    required String sellerId,
    required String title,
    required double price,
    required String description,
    required String type,
    required List<String> images,
  }) async {
    await _firestore.collection('properties').add({
      'sellerId': sellerId,
      'title': title,
      'price': price,
      'description': description,
      'type': type,
      'images': images,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Stream<QuerySnapshot> getProperties() {
    return _firestore.collection('properties').snapshots();
  }
}

