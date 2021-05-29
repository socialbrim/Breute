import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:parentpreneur/models/ProductDetails.dart';

class MarketProvider with ChangeNotifier {
  List<ProductModel> _productList = [];
  int lastValidIndex = 10;
  List<ProductModel> get products {
    return [..._productList];
  }

  Future<void> fetchProductData() async {
    _productList = [];
    final data = await FirebaseDatabase.instance
        .reference()
        .child("RewardProducts")
        .orderByChild("Enabled")
        .equalTo(true)
        .limitToFirst(lastValidIndex)
        .once();
    if (data.value != null) {
      final mapped = data.value as Map;
      mapped.forEach((key, value) {
        _productList.add(
          ProductModel(
            category: value['categories'],
            description: value['description'],
            images: value['images'],
            pointReq:
                double.parse(value['points'] == null ? "0" : value['points']),
            productID: key,
            stock: int.parse(value['stock'] == null ? "0" : value['stock']),
            title: value['Title'],
          ),
        );
      });
    }
  }

  void setNewIndex() {
    lastValidIndex += 10;
    notifyListeners();
  }
}
