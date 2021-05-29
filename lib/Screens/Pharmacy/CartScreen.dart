import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:parentpreneur/Providers/User.dart';
import 'package:parentpreneur/Providers/cartProvider.dart';
import 'package:parentpreneur/Screens/Pharmacy/addressSaver.dart';
import 'package:parentpreneur/models/ProductDetails.dart';
import 'package:parentpreneur/models/UserModel.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  final bool isAddTocart;
  CartScreen({this.isAddTocart});
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  Map<ProductModel, int> orders = {};
  double sub;
  void fetchData() {
    if (!widget.isAddTocart) {
      orders = Provider.of<CartProvider>(context).orderNow;
    } else {
      orders = Provider.of<CartProvider>(context).allProduct;
      print(orders);
    }
  }

  @override
  void didChangeDependencies() {
    fetchData();
    super.didChangeDependencies();
  }

  String fetchSubTotal() {
    double subtotal = 0;
    final ref = Provider.of<CartProvider>(context, listen: false);

    if (widget.isAddTocart) {
      ref.allProduct.forEach((key, value) {
        subtotal += key.pointReq * value;
      });
    } else {
      ref.orderNow.forEach((key, value) {
        subtotal += key.pointReq * value;
      });
    }
    sub = subtotal;
    return subtotal.toString();
  }

  UserInformation userinfo;

  @override
  void initState() {
    userinfo =
        Provider.of<UserProvider>(context, listen: false).userInformation;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(orders.isEmpty);
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: orders.isEmpty
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: height * 0.2,
                    child: Image.asset(
                      "assets/Group 538.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(
                    height: height * 0.1,
                  ),
                  Container(
                    child: Center(
                      child: Text(
                        'Your Cart is empty',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          // fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  height: height * 0.25,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Items',
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(
                              color: Colors.grey,
                              fontSize: 12,
                              // fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            'Pts: ${fetchSubTotal()}',
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(
                              color: HexColor(
                                "091540",
                              ),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Shipping',
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(
                              color: Colors.grey,
                              fontSize: 12,
                              // fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            'Pts: 50',
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(
                              color: HexColor(
                                "091540",
                              ),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total',
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(
                              color: HexColor(
                                "091540",
                              ),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            'Pts: ${double.parse(fetchSubTotal()).toInt() + 50}',
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(
                              color: HexColor(
                                "091540",
                              ),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: height * 0.025,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => AddressSaver(
                              isAddTocart: widget.isAddTocart,
                            ),
                          ));
                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: height * 0.05,
                          width: width * 0.7,
                          decoration: BoxDecoration(
                            color: HexColor("091540"),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(),
                          ),
                          child: Text(
                            "Checkout",
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
        body: orders.isEmpty
            ? Center(
                child: SpinKitChasingDots(
                  color: Colors.red,
                ),
              )
            : SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: height * 0.02,
                    ),
                    Container(
                      height: height * 0.06,
                      child: Row(
                        children: [
                          SizedBox(
                            width: width * 0.04,
                          ),
                          Icon(
                            MdiIcons.cartOutline,
                            size: 25,
                          ),
                          SizedBox(
                            width: width * 0.02,
                          ),
                          Container(
                            child: Text(
                              "Your Cart",
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.poppins(
                                color: HexColor(
                                  "091540",
                                ),
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(),
                    SizedBox(
                      height: height * 0.01,
                    ),
                    Container(
                      height: height * 0.7,
                      width: width,
                      child: ListView(
                        physics: NeverScrollableScrollPhysics(),
                        children: mappedData(),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  List<Widget> mappedData() {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    List<Widget> returningValue = [];
    orders.forEach((key, value) {
      returningValue.add(Padding(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        child: Container(
          height: height * 0.15,
          width: width,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 4,
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                  ),
                  child: Container(
                    height: height * 0.15,
                    width: width * 0.3,
                    child: Image.network(
                      '${key.images.first}',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(
                  width: width * 0.03,
                ),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: height * 0.01,
                      ),
                      Container(
                        padding: EdgeInsets.all(4),
                        child: Text(
                          key.title,
                          style: GoogleFonts.poppins(
                            color: HexColor(
                              "091540",
                            ),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: HexColor(
                            "F4F9F9",
                          ),
                        ),
                        child: Text(
                          "Points: " + "${key.pointReq}",
                          style: GoogleFonts.poppins(
                            color: HexColor(
                              "008D8D",
                            ),
                            fontSize: 10,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: width * .28),
                        decoration: BoxDecoration(
                          border: Border.all(width: 2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        width: width * 0.25,
                        height: height * .037,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            InkWell(
                              onTap: () {
                                Provider.of<CartProvider>(context,
                                        listen: false)
                                    .addQuantity(key, widget.isAddTocart);
                              },
                              child: Icon(
                                MdiIcons.plus,
                              ),
                            ),
                            SizedBox(
                              width: width * 0.01,
                            ),
                            Container(
                              width: width * .07,
                              child: Text(
                                '$value',
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(
                              width: width * 0.01,
                            ),
                            InkWell(
                              onTap: () async {
                                if (value == 1) {
                                  final user =
                                      FirebaseAuth.instance.currentUser;
                                  final database = FirebaseDatabase.instance
                                      .reference()
                                      .child("Add To Carts")
                                      .child(user.uid);
                                  database.child(key.productID).remove();
                                  Provider.of<CartProvider>(context,
                                          listen: false)
                                      .removeItem(key, widget.isAddTocart);
                                  return;
                                }
                                Provider.of<CartProvider>(context,
                                        listen: false)
                                    .decreaseQuantity(key, widget.isAddTocart);
                              },
                              child: Icon(
                                MdiIcons.minus,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ));
    });
    return returningValue;
  }
}
