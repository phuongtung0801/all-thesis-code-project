import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import './product_item.dart';

class ProductsGrid extends StatelessWidget {
  final bool showFavs;

  ProductsGrid(this.showFavs);

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    //cái này là một list
    final products = showFavs ? productsData.favoriteItems : productsData.items;
    /*Hình dung chỗ này grid nó sẽ build ra rất nhiều object Product, do Products là
    một list gồm các Object Product. Cho nên khi dùng ChangeNotifierProvider ở đây,
    tức là với mỗi object Product, sẽ có một cái ChangeNotifierProvider để notify tới
    listener,, which is ProductItem, vậy nên object ProductItem, which is listen và có thể
    nhận vào state từ object Product (mỗi ProductItem sẽ listen theo một Product*/
    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      //length của grid
      itemCount: products.length,
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        // builder: (c) => products[i],
        value: products[i],
        child: ProductItem(
            // products[i].id,
            // products[i].title,
            // products[i].imageUrl,
            ),
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
    );
  }
}
