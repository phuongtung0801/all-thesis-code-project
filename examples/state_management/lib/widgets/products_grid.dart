import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import './product_item.dart';

class ProductsGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //cục này là data lấy từ Provider Products
    final productsData = Provider.of<Products>(context);
    //có thể bốc các property ra luôn
    final products = productsData.items2;
    final testString = productsData.testString;
    print(testString);
    //khi nào provider thay đổi thì chỉ cục này listen nên sẽ thay đổi,
    //không ảnh hưởng đến cái khác
    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: products.length,
      itemBuilder: (ctx, i) => ChangeNotifierProvider(
        //mỗi object Product sẽ có một ChangeNotifierProvider!
        //vì vậy cho nên một tí mới pass id của nó vào được.
        create: (c) => products[i],
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
