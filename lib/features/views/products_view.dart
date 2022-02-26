import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:debby/features/view_models/product_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductsView extends StatefulWidget {
  const ProductsView({Key? key}) : super(key: key);

  @override
  State<ProductsView> createState() => _ProductsViewState();
}

class _ProductsViewState extends State<ProductsView> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<ProductViewModel>(context, listen: false).fetchAllProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductViewModel>(
      builder: (context, productModel, child) {
        return Scaffold(
          appBar: AppBar(title: const Text('Products')),
          body: productModel.productsLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : ListView.separated(
                  itemCount: productModel.products.length,
                  itemBuilder: (context, index) {
                    return StaggeredGrid.count(
                      crossAxisCount: 4,
                      mainAxisSpacing: 4,
                      crossAxisSpacing: 4,
                      children: [
                        StaggeredGridTile.count(
                          crossAxisCellCount: 2,
                          mainAxisCellCount: 2,
                          child: CircleAvatar(
                              child: Image.network(
                                  productModel.products[index].image[0])),
                        ),
                        const StaggeredGridTile.count(
                          crossAxisCellCount: 2,
                          mainAxisCellCount: 1,
                          child: CircleAvatar(),
                        ),
                        const StaggeredGridTile.count(
                          crossAxisCellCount: 1,
                          mainAxisCellCount: 1,
                          child: CircleAvatar(),
                        ),
                        const StaggeredGridTile.count(
                          crossAxisCellCount: 1,
                          mainAxisCellCount: 1,
                          child: CircleAvatar(),
                        ),
                        const StaggeredGridTile.count(
                          crossAxisCellCount: 4,
                          mainAxisCellCount: 2,
                          child: CircleAvatar(),
                        ),
                      ],
                    );
                    ;
// return ListTile(
//                       leading: CircleAvatar(
//                           child: Image.network(
//                               productModel.products[index].image[0])),
//                       title: Text(
//                           'Product name : ${productModel.products[index].name}'),
//                       subtitle: Text(
//                           'Store name: ${productModel.products[index].store.name}'),
//                       trailing: Text('${productModel.products[index].price}'),
//                     );
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      const SizedBox(height: 10),
                ),
        );
      },
    );
  }
}
