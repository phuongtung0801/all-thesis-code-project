import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';

class ProductDetailScreen extends StatelessWidget {
  // final String title;
  // final double price;

  // ProductDetailScreen(this.title, this.price);
  static const routeName = '/product-detail';

  @override
  Widget build(BuildContext context) {
    //cục này là lấy id từ trong navigator, do thằng product_item nó pass argument là id
    final productId =
        ModalRoute.of(context).settings.arguments as String; // is the id!
    //đây là cục data lấy từ Provider Products, nó trả về object là mỗi Product
    final loadedProduct = Provider.of<Products>(
      context,
      listen: false,
    ).findById(productId);
    return Scaffold(
      appBar: AppBar(
        title: Text(loadedProduct.title),
      ),
    );
  }
}
