import 'dart:developer';

import 'package:HomeQuest/model/product_model.dart';
import 'package:HomeQuest/repositpry/product_repository.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

final productControllerProvider = StateNotifierProvider((ref) {
  final productrepository = ref.watch(productRepositoryProvider);
  return ProductController(productrepository: productrepository, ref: ref);
});

final getAllProductsProvider = StreamProvider((ref) {
  final controller = ref.watch(productControllerProvider.notifier);
  return controller.getAllProducts();
});

class ProductController extends StateNotifier<bool> {
  final ProductRepository _productRepository;
  final Ref _ref;
  ProductController(
      {required ProductRepository productrepository, required Ref ref})
      : _productRepository = productrepository,
        _ref = ref,
        super(false);

  Stream<List<ProductModel>> getAllProducts() {
    final res = _productRepository.getAllProducts();
    log(res.toString());
    return res;
  }
}
