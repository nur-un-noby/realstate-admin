import 'package:HomeQuest/controller/product_controller.dart';
import 'package:HomeQuest/repositpry/firebase_providers.dart';
import 'package:HomeQuest/repositpry/product_repository.dart';
import 'package:HomeQuest/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductListPage extends ConsumerWidget {
  const ProductListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productRepository =
        ProductRepository(firestore: ref.watch(firestoreProvider));

    return Scaffold(
        body: StreamBuilder(
            stream: productRepository.getAllProducts(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No products available.'));
              }
              final products = snapshot.data!;
              return ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return ListTile(
                      title: Text("hi"),
                    );
                  });
            }));
  }
}

/**
 * ref.watch(getAllProductsProvider).when(
          data: (data) {
            print(data.toString());
            if (data.isEmpty) {
              return Center(
                child: Text("No Data"),
              );
            }
            return ListView.builder(itemBuilder: (context, index) {
              return ListTile(
                title: Text(data[index].title),
              );
            });
          },
          error: (error, st) => const Center(
                child: Text("Error Happended"),
              ),
          loading: () => const Loader()),
    
 */
