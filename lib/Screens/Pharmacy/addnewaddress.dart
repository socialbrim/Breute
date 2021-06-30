import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:parentpreneur/Screens/Pharmacy/Address.dart';
import 'package:parentpreneur/models/UserModel.dart';

class AddNewAddress extends StatefulWidget {
  final UserInformation userinfo;
  final bool isEdit;
  final AddressModel editModel;
  AddNewAddress({this.userinfo, this.editModel, this.isEdit});
  @override
  _AddNewAddressState createState() => _AddNewAddressState();
}

class _AddNewAddressState extends State<AddNewAddress> {
  int nickName = 1;
  TextEditingController _firstname = new TextEditingController();
  TextEditingController _lastname = new TextEditingController();
  TextEditingController _addressDetails = new TextEditingController();
  TextEditingController _mobile = new TextEditingController();
  TextEditingController _zipCode = new TextEditingController();
  TextEditingController _streetNo = new TextEditingController();
  TextEditingController _city = new TextEditingController();
  TextEditingController _region = new TextEditingController();
  TextEditingController _country = new TextEditingController();
  final _key = GlobalKey<FormState>();

  @override
  void initState() {
    _firstname.text = widget.userinfo.name.split(" ")[0];
    _lastname.text = widget.userinfo.name.split(" ")[1];
    _mobile.text = widget.userinfo.phone;
    if (widget.isEdit) {
      _firstname.text = widget.editModel.firstName;
      _lastname.text = widget.editModel.lastName;
      _mobile.text = widget.editModel.mobile;
      _addressDetails.text = widget.editModel.address;
      _zipCode.text = widget.editModel.pin;
      _streetNo.text = widget.editModel.streetNo;
      _city.text = widget.editModel.city;
      _region.text = widget.editModel.state;
      _country.text = widget.editModel.country;
      nickName = widget.editModel.nickName == "Home" ? 1 : 2;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.isEdit ? "Edit Address" : "Add New Address",
            overflow: TextOverflow.ellipsis,
          ),
        ),
        bottomNavigationBar: Container(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  //...
                  if (_key.currentState.validate()) {
                    FirebaseDatabase.instance
                        .reference()
                        .child("User Information")
                        .child(widget.userinfo.id)
                        .child("Addresses")
                        .child(nickName == 1 ? "Home" : "Office")
                        .update({
                      "Name":
                          "${_firstname.text.trim()} ${_lastname.text.trim()}",
                      "Address": "${_addressDetails.text}",
                      "Mobile": "${_mobile.text}",
                      "zipCode": "${_zipCode.text}",
                      "StreetNO": "${_streetNo.text}",
                      "City": "${_city.text}",
                      "Region": "${_region.text}",
                      "Country": "${_country.text}",
                      "updatedData": DateTime.now().toIso8601String(),
                    });
                    Navigator.of(context).pop();
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
                      'Save and continue',
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
          child: Form(
            key: _key,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: height * 0.02,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: HexColor("97ADB6"),
                      ),
                      borderRadius: BorderRadius.circular(6),
                      color: HexColor('F7F8F9'),
                    ),
                    child: TextFormField(
                      validator: (val) {
                        if (val.isEmpty) {
                          return "Enter In Field";
                        } else
                          return null;
                      },
                      controller: _firstname,
                      onSaved: (newValue) {},
                      enableSuggestions: true,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        hintText: 'First Name',
                        hintStyle: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            color: HexColor('3A3B3F'),
                          ),
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: HexColor("97ADB6"),
                      ),
                      borderRadius: BorderRadius.circular(6),
                      color: HexColor('F7F8F9'),
                    ),
                    child: TextFormField(
                      validator: (val) {
                        if (val.isEmpty) {
                          return "Enter In Field";
                        } else
                          return null;
                      },
                      controller: _lastname,
                      onSaved: (newValue) {},
                      enableSuggestions: true,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        hintText: 'Last Name',
                        hintStyle: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            color: HexColor('3A3B3F'),
                          ),
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: HexColor("97ADB6"),
                      ),
                      borderRadius: BorderRadius.circular(6),
                      color: HexColor('F7F8F9'),
                    ),
                    child: TextFormField(
                      validator: (val) {
                        if (val.isEmpty) {
                          return "Enter In Field";
                        } else
                          return null;
                      },
                      controller: _mobile,
                      onSaved: (newValue) {},
                      enableSuggestions: true,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        hintText: "Mobile Number",
                        hintStyle: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            color: HexColor('3A3B3F'),
                          ),
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: HexColor("97ADB6"),
                      ),
                      borderRadius: BorderRadius.circular(6),
                      color: HexColor('F7F8F9'),
                    ),
                    child: TextFormField(
                      validator: (val) {
                        if (val.isEmpty) {
                          return "Enter In Field";
                        } else
                          return null;
                      },
                      controller: _addressDetails,
                      onSaved: (newValue) {},
                      enableSuggestions: true,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        hintText: 'Address Detail',
                        hintStyle: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            color: HexColor('3A3B3F'),
                          ),
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: HexColor("97ADB6"),
                      ),
                      borderRadius: BorderRadius.circular(6),
                      color: HexColor('F7F8F9'),
                    ),
                    child: TextFormField(
                      validator: (val) {
                        if (val.isEmpty) {
                          return "Enter In Field";
                        } else
                          return null;
                      },
                      controller: _zipCode,
                      onSaved: (newValue) {},
                      enableSuggestions: true,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'Zip Code',
                        hintStyle: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            color: HexColor('3A3B3F'),
                          ),
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: HexColor("97ADB6"),
                      ),
                      borderRadius: BorderRadius.circular(6),
                      color: HexColor('F7F8F9'),
                    ),
                    child: TextFormField(
                      validator: (val) {
                        if (val.isEmpty) {
                          return "Enter In Field";
                        } else
                          return null;
                      },
                      controller: _streetNo,
                      onSaved: (newValue) {},
                      enableSuggestions: true,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'Street No',
                        hintStyle: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            color: HexColor('3A3B3F'),
                          ),
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: HexColor("97ADB6"),
                      ),
                      borderRadius: BorderRadius.circular(6),
                      color: HexColor('F7F8F9'),
                    ),
                    child: TextFormField(
                      validator: (val) {
                        if (val.isEmpty) {
                          return "Enter In Field";
                        } else
                          return null;
                      },
                      controller: _city,
                      onSaved: (newValue) {},
                      enableSuggestions: true,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        hintText: 'City',
                        hintStyle: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            color: HexColor('3A3B3F'),
                          ),
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: HexColor("97ADB6"),
                      ),
                      borderRadius: BorderRadius.circular(6),
                      color: HexColor('F7F8F9'),
                    ),
                    child: TextFormField(
                      validator: (val) {
                        if (val.isEmpty) {
                          return "Enter In Field";
                        } else
                          return null;
                      },
                      controller: _region,
                      onSaved: (newValue) {},
                      enableSuggestions: true,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        hintText: 'Region/State',
                        hintStyle: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            color: HexColor('3A3B3F'),
                          ),
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: HexColor("97ADB6"),
                      ),
                      borderRadius: BorderRadius.circular(6),
                      color: HexColor('F7F8F9'),
                    ),
                    child: TextFormField(
                      validator: (val) {
                        if (val.isEmpty) {
                          return "Enter In Field";
                        } else
                          return null;
                      },
                      controller: _country,
                      onSaved: (newValue) {},
                      enableSuggestions: true,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        hintText: 'Country',
                        hintStyle: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            color: HexColor('3A3B3F'),
                          ),
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Type of Address',
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      color: HexColor(
                        "091540",
                      ),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.1,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: RadioListTile(
                          controlAffinity: ListTileControlAffinity.platform,
                          title: Text(
                            'Home',
                          ),
                          value: 1,
                          groupValue: nickName,
                          activeColor: Colors.red,
                          onChanged: (val) {
                            setState(() {
                              nickName = val;
                            });
                          },
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: RadioListTile(
                          title: Text(
                            'Office',
                          ),
                          value: 2,
                          groupValue: nickName,
                          activeColor: Colors.red,
                          onChanged: (val) {
                            setState(() {
                              nickName = val;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
