import '../features/models/product_model.dart';
import '../services/network_service.dart';

class Repository {
  final networkService = NetworkService();

  var headers = {
    "Accept": "application/json",
    "Content-Type": "application/json",
  };

  Future<List<ProductModel>> fetchProducts() async {
    var response = await networkService.get('load-products/2');

    List<ProductModel> products = [];

    for (var data in response['response']) {
      print('Response: ${data}');
      products.add(ProductModel.fromJson(data));
    }

    return products;
  }

  // Future<void> deleteStudent({
  //   required String studentId,
  // }) async {
  //   print('Delete student params sent to server $studentId');
  //   // final userToke = await storageService.readSecureData(userToken);
  //
  //   var response = await networkService.delete(
  //     'student/$studentId',
  //     headers: {'Authorization': '$userToke', ...headers},
  //   );
  //
  //   print('Delete student response $response');
  // }
}
