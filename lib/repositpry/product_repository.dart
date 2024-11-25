import 'dart:developer';

import 'package:HomeQuest/model/product_model.dart';
import 'package:HomeQuest/repositpry/firebase_providers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final productRepositoryProvider = Provider((ref) {
  return ProductRepository(firestore: ref.watch(firestoreProvider));
});

class ProductRepository {
  final FirebaseFirestore _firestore;
  ProductRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;
  CollectionReference get _products => _firestore.collection('products');
// List<ProductModel>
  Stream<List<ProductModel>> getAllProducts() {
    try {
      List<ProductModel> products = [];

      return _products.snapshots().map((data) {
        for (var d in data.docs) {
          products.add(ProductModel.fromJson(d as Map<String, dynamic>));
        }
        return products;
      });
    } catch (e) {
      log(e.toString());
      return Stream.value([]);
    }
  }
}
