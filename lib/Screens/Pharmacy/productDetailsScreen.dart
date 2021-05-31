import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';
import 'package:parentpreneur/Providers/cartProvider.dart';
import 'package:parentpreneur/Screens/Pharmacy/CartScreen.dart';
import 'package:parentpreneur/models/ProductDetails.dart';

import 'package:provider/provider.dart';

class ProductDetailsScreen extends StatefulWidget {
  final ProductModel product;

  ProductDetailsScreen({this.product});
  @override
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  String choosensizeIFANY;
  String choosenColorIFANY;
  int currentSizeIndex = 0;
  int currentColorIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  final _pageController = PageController();
  final _currentPageNotifier = ValueNotifier<int>(0);

  _buildCircleIndicator5() {
    return Positioned(
      bottom: 2,
      left: 140,
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CirclePageIndicator(
                size: 8,
                selectedSize: 12,
                dotColor: Colors.white,
                selectedDotColor: HexColor('2c3448'),
                itemCount: widget.product.images.length,
                currentPageNotifier: _currentPageNotifier,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: Container(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // ignore: deprecated_member_use
              InkWell(
                onTap: () async {
                  final ref = Provider.of<CartProvider>(context, listen: false);
                  final user = FirebaseAuth.instance.currentUser;
                  final database = FirebaseDatabase.instance
                      .reference()
                      .child("Add To Carts")
                      .child(user.uid);
                  bool _isExistFromServer = false;
                  ref.allProduct.forEach((key, value) {
                    if (key.productID == widget.product.productID) {
                      _isExistFromServer = true;
                    }
                  });
                  if (!_isExistFromServer) {
                    ProductModel tempProduct;
                    tempProduct = ProductModel(
                      category: widget.product.category,
                      description: widget.product.description,
                      images: widget.product.images,
                      pointReq: widget.product.pointReq,
                      productID: widget.product.productID,
                      stock: widget.product.stock,
                      title: widget.product.title,
                    );
                    ref.addItem(tempProduct, true);
                  }
                  Fluttertoast.showToast(msg: "Added To cart");

                  database.update(
                    {
                      "${widget.product.productID}": true,
                    },
                  );
                },
                child: Container(
                  width: width * 0.5,
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Center(
                    child: Text(
                      'Add to Cart',
                      style: GoogleFonts.poppins(
                        color: HexColor(
                          "091540",
                        ),
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ),
              // ignore: deprecated_member_use
              InkWell(
                onTap: () async {
                  final ref = Provider.of<CartProvider>(context, listen: false);
                  final user = FirebaseAuth.instance.currentUser;
                  final database = FirebaseDatabase.instance
                      .reference()
                      .child("Add To Carts")
                      .child(user.uid);
                  bool _isExistFromServer = false;
                  ref.allProduct.forEach((key, value) {
                    if (key.productID == widget.product.productID) {
                      _isExistFromServer = true;
                    }
                  });
                  if (!_isExistFromServer) {
                    ProductModel tempProduct;
                    tempProduct = ProductModel(
                      category: widget.product.category,
                      description: widget.product.description,
                      images: widget.product.images,
                      pointReq: widget.product.pointReq,
                      productID: widget.product.productID,
                      stock: widget.product.stock,
                      title: widget.product.title,
                    );
                    ref.addItem(tempProduct, true);
                  }
                  Fluttertoast.showToast(msg: "Added To cart");

                  database.update(
                    {
                      "${widget.product.productID}": true,
                    },
                  );

                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => CartScreen(
                        isAddTocart: true,
                      ),
                    ),
                  );
                },
                child: Container(
                  width: width * 0.5,
                  decoration: BoxDecoration(
                    color: HexColor(
                      "091540",
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'Checkout',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    height: 220,
                    child: PageView.builder(
                      onPageChanged: (int index) {
                        _currentPageNotifier.value = index;
                      },
                      itemCount: widget.product.images.length,
                      controller: _pageController,
                      itemBuilder: (context, index) {
                        return Container(
                          child: Image.network(
                            widget.product.images[index],
                            fit: BoxFit.cover,
                          ),
                        );
                      },
                    ),
                  ),
                  _buildCircleIndicator5(),
                  Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: Center(
                            child: IconButton(
                              icon: Icon(
                                Icons.arrow_back,
                                color: HexColor('FA163F'),
                              ),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                padding: EdgeInsets.only(left: 20),
                child: Text(
                  widget.product.title,
                  style: GoogleFonts.poppins(
                    color: HexColor(
                      "091540",
                    ),
                    fontSize: 24,
                  ),
                ),
              ),
              Divider(),
              Padding(
                padding: EdgeInsets.only(left: 40),
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: HexColor(
                      "F4F9F9",
                    ),
                  ),
                  child: Text(
                    "USD: " + "${widget.product.pointReq}",
                    style: GoogleFonts.poppins(
                      color: HexColor(
                        "008D8D",
                      ),
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              Divider(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "${widget.product.description}",
                  style: TextStyle(fontSize: 17),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
