import 'package:debby/features/view_models/product_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductsView extends StatelessWidget {
  const ProductsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductViewModel>(
      builder: (context, productModel, child) {
        return Scaffold(
          appBar: AppBar(),
          body: productModel.productsLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : ListView.separated(
                  itemCount: productModel.products.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: CircleAvatar(
                          child: Image.network(
                              productModel.products[index].image[0])),
                      title: Text(
                          'Product name : ${productModel.products[index].name}'),
                      subtitle: Text(
                          'Store name: ${productModel.products[index].store.name}'),
                      trailing: Text('${productModel.products[index].price}'),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      const SizedBox(height: 10),
                ),
        );
      },
    );
  }
}
