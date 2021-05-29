import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:parentpreneur/Providers/User.dart';
import 'package:parentpreneur/Providers/cartProvider.dart';
import 'package:parentpreneur/Screens/Pharmacy/Address.dart';
import 'package:parentpreneur/models/ProductDetails.dart';
import 'package:parentpreneur/models/UserModel.dart';
import 'package:provider/provider.dart';

import 'addnewaddress.dart';

class AddressSaver extends StatefulWidget {
  final bool isAddTocart;
  AddressSaver({this.isAddTocart});
  @override
  _AddressSaverState createState() => _AddressSaverState();
}

class _AddressSaverState extends State<AddressSaver> {
  List<AddressModel> address = [];
  FirebaseUser user;
  void fetchAddress() async {
    user = FirebaseAuth.instance.currentUser;
    FirebaseDatabase.instance
        .reference()
        .child("CustomerInformation")
        .child(user.uid)
        .child("Addresses")
        .onValue
        .listen((event) {
      if (event.snapshot.value != null) {
        address = [];
        final mapped = event.snapshot.value as Map;
        mapped.forEach((key, value) {
          address.add(AddressModel(
            address: value['Address'],
            city: value['City'],
            nickName: key,
            pin: value['zipCode'],
            updatedDate: DateTime.parse(value['updatedData'] == null
                ? DateTime.now().toIso8601String()
                : value['updatedData']),
            country: value['Country'],
            firstName: value['Name'].toString().split(" ")[0],
            lastName: value['Name'].toString().split(" ")[1],
            mobile: value['Mobile'],
            state: value['Region'],
            streetNo: value['StreetNO'],
          ));
        });
      }
      if (this.mounted) {
        setState(() {
          address.sort((a, b) => a.updatedDate.compareTo(b.updatedDate));
        });
      }
    });
  }

  UserInformation userinfo;
  void fetchCustomerInfo() async {
    userinfo =
        Provider.of<UserProvider>(context, listen: false).userInformation;
  }

  int nickName = 0;
  @override
  void initState() {
    super.initState();
    fetchAddress();
    fetchCustomerInfo();
  }

  Map<ProductModel, int> orders = {};

  void fetchData() {
    if (widget.isAddTocart == null) {
      return;
    }
    if (!widget.isAddTocart) {
      orders = Provider.of<CartProvider>(context).orderNow;
    } else {
      orders = Provider.of<CartProvider>(context).allProduct;
    }
  }

  @override
  void didChangeDependencies() {
    fetchData();
    super.didChangeDependencies();
  }

  String formatDate(DateTime date) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formatted = formatter.format(date);
    return formatted;
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Address",
            overflow: TextOverflow.ellipsis,
          ),
        ),
        bottomNavigationBar: widget.isAddTocart == null
            ? null
            : Container(
                height: 60,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        if (address == null || address.isEmpty) {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => AddNewAddress(
                              userinfo: userinfo,
                              isEdit: false,
                              editModel: null,
                            ),
                          ));
                        } else {
                          // Navigator.of(context).push(
                          //   MaterialPageRoute(
                          //     builder: (context) => FinalCheckOut(
                          //       postalAddress: address[nickName],
                          //       orderDetails: orders,
                          //       userInfo: userinfo,
                          //     ),
                          //   ),
                          // );
                        }
                      },
                      child: Container(
                        width: width,
                        decoration: BoxDecoration(
                          color: HexColor(
                            "091540",
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'Continue',
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
            children: [
              SizedBox(
                height: height * 0.02,
              ),
              Container(
                height: address.length *
                    height *
                    0.18, //dynamic rkhna hai! multiply with length
                child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: address.length,
                  itemBuilder: (context, index) => Card(
                    margin: EdgeInsets.all(10),
                    child: RadioListTile(
                        title: Row(
                          children: [
                            Container(
                              width: width * .55,
                              child: Text(
                                "${address[index].firstName} ${address[index].lastName}",
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => AddNewAddress(
                                      editModel: address[index],
                                      isEdit: true,
                                      userinfo: userinfo,
                                    ),
                                  ),
                                );
                              },
                              child: Icon(
                                Icons.edit,
                                color: Colors.grey,
                                size: 20,
                              ),
                            ),
                            SizedBox(
                              width: width * 0.03,
                            ),
                            InkWell(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text("Are you sure?"),
                                    content:
                                        Text("you want to delete this address"),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text("No"),
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          await FirebaseDatabase.instance
                                              .reference()
                                              .child("CustomerInformation")
                                              .child(user.uid)
                                              .child("Addresses")
                                              .child(address[index].nickName)
                                              .remove();
                                          setState(() {
                                            address.remove(address[index]);
                                          });

                                          Navigator.of(context).pop();
                                        },
                                        child: Text("Yes"),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              child: Icon(
                                Icons.delete,
                                color: Colors.red,
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: width * .8,
                              child: Text(
                                "Mobile Number - ${address[index].mobile}",
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            Container(
                              width: width * .8,
                              child: Text(
                                "${address[index].address}",
                                softWrap: true,
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            Container(
                              width: width * .8,
                              child: Text(
                                "${address[index].pin}, St ${address[index].streetNo}",
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            Container(
                              width: width * .8,
                              child: Text(
                                "${address[index].state}",
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            Container(
                              width: width * .8,
                              child: Text(
                                "${address[index].country}",
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                        value: index,
                        groupValue: nickName,
                        activeColor: HexColor("FA163F"),
                        isThreeLine: true,
                        onChanged: (val) {
                          print("Radio $val");
                          setState(() {
                            nickName = val;
                          });
                        }),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => AddNewAddress(
                      userinfo: userinfo,
                      isEdit: false,
                      editModel: null,
                    ),
                  ));
                },
                child: Card(
                  elevation: 8,
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Icon(
                          MdiIcons.mapMarker,
                          color: Colors.grey,
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          'Add New Address',
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
