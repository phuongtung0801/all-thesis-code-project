import 'package:flutter/material.dart';

import './product.dart';

/*Thằng này là provider, tức là state cần được chú ý đến, ở đây flutter có hỗ trợ gói Provider để dùng
tính năng này. Thằng Products này mỗi khi thay đổi thì do nó có ChangeNotifier nên những thằng nào có 
Listener của nó sẽ được thông báo => rebuild widget*/
class Products with ChangeNotifier {
  String testString = 'tung';
  //list những object cần listen
  List<Product> _items = [
    Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    Product(
      id: 'p3',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl:
          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    Product(
      id: 'p4',
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ),
  ];
  List<Product> items2 = [
    Product(
      id: 'p1',
      title: 'Red Hat',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
      id: 'p2',
      title: 'Amelia',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    Product(
      id: 'p3',
      title: 'Luna',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl:
          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    Product(
      id: 'p4',
      title: 'Dana',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ),
  ];

  /*Do không muốn tác động trực tiếp đến biến ở trên cho nên ta sẽ dùng getter ở đây
  để tạo một list copy của list gốc, để các widget khác có dùng thì sẽ dùng list này,
  còn list gốc thì chỉ dùng cho chức năng provider, listener thôi. (chỗ này cũng chưa hiểu
  lắm nhưng cứ tạm hiểu là vậy đi). Thêm một lưu ý nữa là các biến, object trong flutter bản chất
  nó là con trỏ trỏ đến ô nhớ chứa giá trị chứ bản thân nó không phải là địa chỉ của ô nhớ đó.*/
  List<Product> get itemss {
    return [...items2];
  }

  Product findById(String id) {
    return items2.firstWhere((prod) => prod.id == id);
  }

  void addProduct() {
    // _items.add(value);
    notifyListeners();
  }
}
