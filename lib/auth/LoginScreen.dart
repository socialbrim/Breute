import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:lottie/lottie.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../Screens/HomeScreen.dart';
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
  bool _isGoogleLogging = false;
  bool _isFacebookLoggin = false;

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

// {name: Devesh Garg, email: deveshgarg9829@gmail.com, picture: {data: {height: 126, is_silhouette: true, url: https://scontent.fjai2-1.fna.fbcdn.net/v/t1.30497-1/s200x200/84628273_176159830277856_972693363922829312_n.jpg?_nc_cat=1&ccb=2&_nc_sid=12b3be&_nc_ohc=OkCTBOF_dxEAX9oSKhO&_nc_ht=scontent.fjai2-1.fna&tp=7&oh=70e2f655256aa4b01d3ba60b54fcffc1&oe=6017B3E5, width: 200}}, id: 425013675527056}

  Future<void> _loginWithFacebook() async {
    try {
      AccessToken accessToken = await FacebookAuth.instance.login();
      print(accessToken.toJson());
      FacebookAuthCredential _facebookcredentials =
          FacebookAuthProvider.credential(accessToken.token);
      final userData = await FacebookAuth.instance.getUserData();
      print(userData);
      try {
        final user = await FirebaseAuth.instance
            .signInWithCredential(_facebookcredentials);
        if (user != null) {
          await FirebaseDatabase.instance
              .reference()
              .child("User Information")
              .child(FirebaseAuth.instance.currentUser.uid)
              .update({
            "userName": userData['name'],
            "emial": userData['email'],
            "imageURL": userData['picture']['data']['url'],
          });
          Navigator.of(context).popUntil((route) => route.isFirst);
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => HomeScreen(
                isRedirectingFromLogin: true,
              ),
            ),
          );
        }
        print("==========================================================");
        print(user.user.uid); // get the user data
        print("==========================================================");
      } catch (e) {
        FirebaseAuthException error = e;
        Fluttertoast.showToast(msg: error.message);
      }
    } on FacebookAuthException catch (e) {
      switch (e.errorCode) {
        case FacebookAuthErrorCode.OPERATION_IN_PROGRESS:
          print("You have a previous login operation in progress");
          break;
        case FacebookAuthErrorCode.CANCELLED:
          print("login cancelled");
          break;
        case FacebookAuthErrorCode.FAILED:
          print("login failed");
          break;
      }
    }
  }

  void _signInWithGoogle() async {
    final googleSignIn = GoogleSignIn();
    final firebaseAuth = FirebaseAuth.instance;
    // try {
    final GoogleSignInAccount googleUser = await googleSignIn.signIn();

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    setState(() {
      _isGoogleLogging = true;
    });

    final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);
    final user = (await firebaseAuth.signInWithCredential(credential)).user;
    await FirebaseDatabase.instance
        .reference()
        .child("User Information")
        .child(FirebaseAuth.instance.currentUser.uid)
        .update({
      "userName": googleUser.displayName,
      "emial": googleUser.email,
      "imageURL": googleUser.photoUrl,
    });

    if (user != null) {
      setState(() {
        _isGoogleLogging = false;
      });

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => HomeScreen(),
        ),
      );
    } else {
      setState(() {
        _isGoogleLogging = false;
      });
      Fluttertoast.showToast(msg: "Something went wrong");
    }
    // } catch (e) {
    //   setState(() {
    //     _isGoogleLogging = false;
    //   });
    //   print("------------------------");
    //   print(e);
    //   print("------------------------");
    //   Fluttertoast.showToast(msg: "Something went wrong");
    // }
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
                              height: height * 0.01,
                            ),
                            GestureDetector(
                              onTap: () {
                                _signInWithGoogle();
                              },
                              child: Card(
                                color: HexColor('DD4B39'),
                                elevation: 3,
                                shadowColor: theme.colorCompanion,
                                child: Container(
                                  width: width * 0.6,
                                  height: height * 0.06,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: height * 0.045,
                                          child: Image.asset(
                                            'assets/google.png',
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        SizedBox(
                                          width: width * 0.01,
                                        ),
                                        Text(
                                          "Sign in with Google",
                                          style: GoogleFonts.roboto(
                                            fontSize: 16,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                _loginWithFacebook();
                              },
                              child: Card(
                                elevation: 3,
                                color: HexColor('3b5998'),
                                shadowColor: theme.colorCompanion,
                                child: Container(
                                  width: width * 0.6,
                                  height: height * 0.06,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: height * 0.035,
                                          child: Image.asset(
                                            'assets/fb.png',
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        SizedBox(
                                          width: width * 0.025,
                                        ),
                                        Text(
                                          "Sign in with Facebook",
                                          style: GoogleFonts.roboto(
                                            fontSize: 16,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: height * 0.04,
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
