import 'package:country_code_picker/country_code_picker.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import '../main.dart';
import 'otpverificationscreen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  TextEditingController phone = new TextEditingController();
  var countrycode = "+91";
  final _formKey = GlobalKey<FormState>();
  AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        backgroundColor: theme.colorBackground,
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Stack(
              children: [
                Column(
                  children: [
                    SizedBox(
                      height: height * 0.08,
                    ),
                    Container(
                      height: height * 0.2,
                      child: Lottie.asset(
                        'assets/OTPverify.json',
                      ),
                    ),
                    SizedBox(
                      height: height * 0.03,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Card(
                        color: theme.colorPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 10,
                        child: Column(
                          children: [
                            SizedBox(
                              height: height * 0.05,
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Text(
                                'Enter Your Mobile Number To Login',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.ptSans(
                                  color: Colors.white,
                                  fontSize: 25,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: height * 0.05,
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12,
                                // vertical: 5,
                              ),
                              // height: height * 0.06,
                              width: width * 0.78,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: theme.colorCompanion,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: TextFormField(
                                keyboardType: TextInputType.phone,
                                controller: phone,
                                style: GoogleFonts.inter(
                                  color: Colors.white,
                                ),
                                validator: (val) {
                                  if (val.isEmpty) {
                                    return "Enter in Field";
                                  } else
                                    return null;
                                },
                                decoration: InputDecoration(
                                  prefixIcon: Container(
                                    // padding: EdgeInsets.only(top: 5),
                                    child: CountryCodePicker(
                                      barrierColor: Colors.black,
                                      textStyle: GoogleFonts.inter(
                                        color: Colors.white,
                                      ),
                                      onChanged: (val) {
                                        countrycode = val.dialCode;
                                      },
                                      initialSelection: 'IN',
                                      showCountryOnly: false,
                                      showOnlyCountryWhenClosed: false,
                                      alignLeft: false,
                                    ),
                                  ),
                                  hintText: 'Phone Number',
                                  hintStyle: theme.text14boldWhite,
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: height * 0.04,
                            ),
                            GestureDetector(
                              onTap: () async {
                                //..
                                if (!_formKey.currentState.validate()) {
                                  return;
                                }
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => OtpVerificationScreen(
                                      phoneno: "$countrycode${phone.text}",
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                height: height * 0.06,
                                width: width * 0.7,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: theme.colorCompanion,
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  'Submit',
                                  // textAlign: TextAlign.center,
                                  style: theme.text20boldWhite,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: height * 0.02,
                            ),
                            Container(
                              height: height * 0.05,
                              width: width,
                              child: Text(
                                'You will recieve a 6 digit OTP',
                                textAlign: TextAlign.center,
                                style: theme.text14boldWhite,
                              ),
                            ),
                            SizedBox(
                              height: height * 0.06,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
