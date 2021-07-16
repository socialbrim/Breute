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
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../Screens/HomeScreen.dart';
import '../main.dart';
import 'otpverificationscreen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  TextEditingController phone = new TextEditingController();
  var countrycode = "+1";
  final _formKey = GlobalKey<FormState>();
  AnimationController _controller;
  bool _isGoogleLogging = false;
  bool _isFacebookLoggin = false;

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  @override
  void initState() {
    super.initState();

    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(
            sound: true, badge: true, alert: true, provisional: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
    _firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      setState(() {
        this.tokenid = token;
        print("Push Messaging token: $token");
      });
    });
  }

  String tokenid;
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _loginWithFacebook() async {
    try {
      AccessToken accessToken = await FacebookAuth.instance.login();
      print(accessToken.toJson());
      FacebookAuthCredential _facebookcredentials =
          FacebookAuthProvider.credential(accessToken.token);
      final userData = await FacebookAuth.instance.getUserData();
      print(userData);
      try {
        setState(() {
          _isFacebookLoggin = true;
        });
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
            "PlanName": "Peer Contributor",
            "fcmtoken": tokenid,
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
        setState(() {
          _isFacebookLoggin = false;
        });

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
    try {
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
        "PlanName": "Peer Contributor",
        "fcmtoken": tokenid,
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
    } catch (e) {
      setState(() {
        _isGoogleLogging = false;
      });
      print("------------------------");
      print(e);
      print("------------------------");
      Fluttertoast.showToast(msg: "Something went wrong");
    }
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
                                'Login',
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
                                      initialSelection: 'US',
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
                                final data = await checkrefferal();

                                if (!_formKey.currentState.validate() &&
                                    !data) {
                                  return;
                                }
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => OtpVerificationScreen(
                                      phoneno: "$countrycode${phone.text}",
                                      fcmtoken: tokenid,
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
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.04,
                    ),
                    GestureDetector(
                      onTap: () {
                        _signInWithGoogle();
                      },
                      child: Card(
                        color: HexColor('DD4B39'),
                        elevation: 3,
                        child: Container(
                          width: width * 0.6,
                          height: height * 0.06,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: _isGoogleLogging
                                ? SpinKitThreeBounce(
                                    color: Colors.white,
                                    size: 20,
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
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
                        child: Container(
                          width: width * 0.6,
                          height: height * 0.06,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: _isFacebookLoggin
                                ? SpinKitThreeBounce(
                                    color: Colors.white,
                                    size: 20,
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextEditingController _ctrl = new TextEditingController();
  Future<bool> checkrefferal() async {
    bool reutnringbool = false;

    await showDialog(
      context: context,
      builder: (context) {
        return WillPopScope(
          onWillPop: () {
            Fluttertoast.showToast(msg: "must important to enter in field");
            return Future.delayed(Duration(seconds: 0)).then((value) => false);
          },
          child: AlertDialog(
            content: Container(
              height: 250,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                          icon: Icon(MdiIcons.closeCircle),
                          onPressed: () {
                            Navigator.of(context).pop();
                          })
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text("Please Enter your referral code"),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12,
                      // vertical: 5,
                    ),
                    // height: height * 0.06,
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: theme.colorCompanion,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      controller: _ctrl,
                      style: GoogleFonts.inter(
                        color: theme.colorPrimary,
                      ),
                      validator: (val) {
                        if (val.isEmpty) {
                          return "Enter in Field";
                        } else
                          return null;
                      },
                      decoration: InputDecoration(
                        prefixIcon: Icon(MdiIcons.share),
                        hintText: 'Refferal Code',
                        hintStyle: theme.text16Primary,
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  GestureDetector(
                    onTap: () async {
                      final data = await FirebaseDatabase.instance
                          .reference()
                          .child("User Information")
                          .orderByValue()
                          .startAt(_ctrl.text)
                          .once();
                      if (data.value != null) {
                        Fluttertoast.showToast(msg: "Code Accepted");
                        Navigator.of(context).pop();
                        reutnringbool = true;
                      } else {
                        Fluttertoast.showToast(msg: "Code Not found");
                        Navigator.of(context).pop();
                      }
                      print(data.value);
                    },
                    child: Container(
                      height: 50,
                      width: 100,
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
                ],
              ),
            ),
          ),
        );
      },
    );

    return reutnringbool;
  }
}
