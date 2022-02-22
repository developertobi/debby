import 'package:debby/services/network_service.dart';
import 'package:flutter/material.dart';

import '../../repositories/app_repository.dart';
import '../models/product_model.dart';

class ProductViewModel extends ChangeNotifier {
  final appRepository = Repository();
  bool _productsLoading = false;
  bool get productsLoading => _productsLoading;

  List<ProductModel> products = [];

  Future<void> fetchAllProducts() async {
    try {
      _productsLoading = true;

      products = await appRepository.fetchProducts();
      print('Name of the first product ${products.first.name}');
      print('All products $products');

      _productsLoading = false;
      notifyListeners();
    } on NetworkException catch (e) {
      _productsLoading = false;
      // Do something else here e.g show a snackbar or something.

      print('Error message ${e.message}');
    }
  }
}
