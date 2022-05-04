import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/products_overview_screen.dart';
import './screens/product_detail_screen.dart';
import './providers/products.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    /*ChangeNotifierProvider dùng để attach Provider (nơi chứa data cần listen) vào trong widget,
    cụ thể ở đây là widget root. Lý do là vì để các widget listen được provider thì provider cần
    được attach vào widget cha hoặc ông nội ông cố nội tổ tiên của widget đó.*/
    return ChangeNotifierProvider(
      /*cái create này là method của ChangeNotifierProvider dùng để attach provider vào widget
      này, ở đây provider là Products*/
      create: (ctx) => Products(),
      child: MaterialApp(
          title: 'MyShop',
          theme: ThemeData(
            primarySwatch: Colors.purple,
            //accentColor: Colors.deepOrange,
            fontFamily: 'Lato',
          ),
          /*thằng home và thằng routes này là con của root, nên nó có thể được gắn listener của provider Products*/
          home: ProductsOverviewScreen(),
          routes: {
            ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
          }),
    );
  }
}
