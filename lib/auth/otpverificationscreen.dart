import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:parentpreneur/Screens/HomeScreen.dart';
import '../main.dart';
import 'otp.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String phoneno;
  final String fcmtoken;

  OtpVerificationScreen({this.phoneno, this.fcmtoken});

  @override
  _OtpVerificationScreenState createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  bool isCodeSent = false;
  bool _isLoading = false;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  String _verificationId;
  PinDecoration _pinDecoration = UnderlineDecoration(
    enteredColor: Colors.white,
    hintText: '123456',
    color: theme.colorCompanion,
  );
  TextEditingController _pinEditingController = TextEditingController();

  void _onformsubmitted() async {
    AuthCredential _authCredential = PhoneAuthProvider.credential(
        verificationId: _verificationId, smsCode: _pinEditingController.text);

    _firebaseAuth
        .signInWithCredential(_authCredential)
        .then((UserCredential value) async {
      if (value.user != null) {
        setState(() {
          _isLoading = true;
        });

        await FirebaseDatabase.instance
            .reference()
            .child("User Information")
            .child(value.user.uid)
            .update({
          'uid': value.user.uid,
          "isPhone": true,
          "phone": value.user.phoneNumber,
          "PlanName": "Peer Contributor",
          "fcmtoken": widget.fcmtoken,
        });
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).popUntil((route) => route.isFirst);
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => HomeScreen(
              isRedirectingFromLogin: true,
            ),
          ),
        );
        // Handle loogged in state

      } else {
        showToast("Error validating OTP, try again", Colors.red);
      }
    }).catchError((error) {
      showToast("Something went wrong", Colors.red);
    });
  }

  void showToast(message, Color color) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 2,
        backgroundColor: color,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  void _onVerifyCode() async {
    setState(() {
      isCodeSent = true;
    });
    final PhoneVerificationCompleted verificationCompleted =
        (AuthCredential phoneAuthCredential) {
      _firebaseAuth
          .signInWithCredential(phoneAuthCredential)
          .then((UserCredential value) async {
        if (value.user != null) {
          setState(() {
            _isLoading = true;
          });
          await FirebaseDatabase.instance
              .reference()
              .child("User Information")
              .child(value.user.uid)
              .update({
            'uid': value.user.uid,
            "phone": value.user.phoneNumber,
            "isPhone": true,
            "PlanName": "Peer Contributor",
            "fcmtoken": widget.fcmtoken,
          });
          setState(() {
            _isLoading = false;
          });
          Navigator.of(context).popUntil((route) => route.isFirst);
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => HomeScreen(
                isRedirectingFromLogin: true,
              ),
            ),
          );
        } else {
          showToast("Error validating OTP, try again", Colors.red);
        }
      }).catchError((error) {
        print(error);
        showToast("Try again in sometime", Colors.red);
      });
    };

    final PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException authException) {
      showToast(authException.message, Colors.red);
      setState(() {
        isCodeSent = false;
      });
    };

    final PhoneCodeSent codeSent =
        (String verificationId, [int forceResendingToken]) async {
      _verificationId = verificationId;
      setState(() {
        _verificationId = verificationId;
      });
    };
    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      _verificationId = verificationId;
      setState(() {
        _verificationId = verificationId;
      });
    };

    //Change country code

    await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: "${widget.phoneno}",
        timeout: const Duration(seconds: 60),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
  }

  @override
  void initState() {
    _onVerifyCode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    // ignore: unused_local_variable
    var width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        backgroundColor: theme.colorBackground,
        body: SingleChildScrollView(
          child: Container(
            // padding: EdgeInsets.only(top: 50, right: 30, left: 30),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: height * 0.08,
                    ),
                    Container(
                      height: height * 0.25,
                      child: Center(
                        child: Lottie.asset(
                          'assets/OTPverify.json',
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.04,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Card(
                        color: theme.colorPrimary,
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          children: [
                            SizedBox(
                              height: height * 0.025,
                            ),
                            Text(
                              'OTP Verification',
                              style: GoogleFonts.ptSans(
                                  textStyle: TextStyle(
                                      fontSize: 22, color: Colors.white),
                                  fontWeight: FontWeight.w600),
                            ),
                            SizedBox(
                              height: height * 0.04,
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 18),
                              child: Text(
                                'Please enter verification code sent to your mobile',
                                style: GoogleFonts.inter(
                                  textStyle: TextStyle(
                                      fontSize: 12, color: Colors.white),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(
                              height: height * 0.04,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: PinInputTextField(
                                pinLength: 6,
                                decoration: _pinDecoration,
                                controller: _pinEditingController,
                                autoFocus: true,
                                textInputAction: TextInputAction.done,
                                onSubmit: (pin) {
                                  if (pin.length == 6) {
                                    _onformsubmitted();
                                  } else {
                                    showToast("Invalid OTP", Colors.red);
                                  }
                                },
                              ),
                            ),
                            SizedBox(
                              height: height * 0.04,
                            ),
                            InkWell(
                              onTap: () {
                                if (_pinEditingController.text.length == 6) {
                                  _onformsubmitted();
                                } else {
                                  showToast("Invalid OTP", Colors.red);
                                }
                              },
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 50),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(40),
                                  child: Container(
                                    color: theme.colorCompanion,
                                    padding: EdgeInsets.symmetric(vertical: 12),
                                    child: Center(
                                      child: _isLoading
                                          ? SpinKitThreeBounce(
                                              color: Colors.white,
                                              size: 20,
                                            )
                                          : Text(
                                              'Continue',
                                              style: GoogleFonts.poppins(
                                                textStyle: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
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
