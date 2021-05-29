import 'package:flutter/cupertino.dart';
import '../models/ProductDetails.dart';

class CartProvider with ChangeNotifier {
  Map<ProductModel, int> allProduct = {};
  Map<ProductModel, int> orderNow = {};

  void addItem(ProductModel item, bool addTocart) {
    if (addTocart) {
      allProduct.putIfAbsent(item, () => 1);

      notifyListeners();
    } else {
      orderNow = {};
      orderNow.putIfAbsent(item, () => 1);

      notifyListeners();
    }
    print(allProduct);
    print(orderNow);
    print("--------------------");
  }

  void removeItem(ProductModel item, bool addTocart) {
    if (addTocart) {
      allProduct.remove(item);

      notifyListeners();
    } else {
      orderNow.remove(item);

      notifyListeners();
    }
  }

  void addQuantity(ProductModel item, bool addTocart) {
    if (addTocart) {
      allProduct.update(item, (value) => value + 1);

      notifyListeners();
    } else {
      orderNow.update(item, (value) => value + 1);

      notifyListeners();
    }
  }

  void decreaseQuantity(ProductModel item, bool addTocart) {
    if (addTocart) {
      allProduct.update(item, (value) {
        if (value < 1) {
          removeItem(item, addTocart);
          notifyListeners();
          return null;
        }

        return value - 1;
      });
      notifyListeners();
    } else {
      orderNow.update(item, (value) {
        if (value < 1) {
          removeItem(item, addTocart);
          notifyListeners();

          return null;
        }

        return value - 1;
      });
      notifyListeners();
    }
  }
}
