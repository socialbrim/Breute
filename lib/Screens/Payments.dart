import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:parentpreneur/Providers/User.dart';
import 'package:parentpreneur/main.dart';
import 'package:provider/provider.dart';
import 'package:stripe_payment/stripe_payment.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import '../models/PlanDetail.dart';

// ignore: must_be_immutable
class Payments extends StatefulWidget {
  PlanName plandetails;
  Payments({this.plandetails});
  @override
  _PaymentsState createState() => new _PaymentsState();
}

class _PaymentsState extends State<Payments> {
  // ignore: unused_field
  PaymentMethod _paymentMethod;
  // ignore: unused_field
  final String _currentSecret =
      "sk_test_51IAWW6HpwMJhGfYrD1LC6dZb2cZ7RbMPFHHlqql2XbfDaP1lI8OTEZq0x1QrsctJUI2xtVjode9POKOe8trBNDqM00wzU3Iovi";
  // ignore: unused_field
  Source _source;

  ScrollController _controller = ScrollController();

  final CreditCard testCard = CreditCard(
    number: '4000002760003184',
    expMonth: 12,
    expYear: 21,
  );

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  initState() {
    super.initState();

    StripePayment.setOptions(StripeOptions(
        publishableKey:
            "pk_test_51IAWW6HpwMJhGfYrTky5UzFJhSHb4u6EwE0KQZP8tKhhxLUA4Ztq9xlOjVMqSMvJkTzldmtlZKeIVOnYXMkt3UhZ00x7xr9nOX",
        merchantId: "Test",
        androidPayMode: 'test'));
  }

  void setError(dynamic error) {
    _scaffoldKey.currentState
        // ignore: deprecated_member_use
        .showSnackBar(SnackBar(content: Text(error.toString())));
    setState(() {});
  }

  void successfulPaid(String transactionID) {
    final userInfo =
        Provider.of<UserProvider>(context, listen: false).userInformation;
    //...
    final user = FirebaseAuth.instance.currentUser;
    FirebaseDatabase.instance
        .reference()
        .child("Payments")
        .child(user.uid)
        .update({
      "uid": user.uid,
      "plan Name": widget.plandetails.name,
      "CustomerName": userInfo.name,
      "amountPaid": widget.plandetails.amount,
      "trxnID": transactionID,
      "DateTime": DateTime.now().toIso8601String(),
    });
    FirebaseDatabase.instance
        .reference()
        .child("User Information")
        .child(user.uid)
        .update({"PlanName": widget.plandetails.name});
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: new Scaffold(
          backgroundColor: theme.colorPrimary,
          appBar: AppBar(
            backgroundColor: theme.colorPrimary,
            elevation: 0,
            toolbarHeight: 100,
            title: Text('Payment Methods'),
            centerTitle: true,
          ),
          key: _scaffoldKey,
          body: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: height * 0.13,
                    child: Image.asset("assets/2.png"),
                  ),
                  Container(
                    height: height * 0.61,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                        color: theme.colorBackground),
                    child: ListView(
                      controller: _controller,
                      padding: const EdgeInsets.all(20),
                      children: <Widget>[
                        SizedBox(
                          height: height * 0.18,
                        ),
                        InkWell(
                          onTap: () async {
                            await showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text("Free Upgrade"),
                                  content: Text(
                                      "Please donate to expand Breute's AI capabilities in predicting ailments."),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          Navigator.of(context).pop();
                                        },
                                        child: Text(
                                          "Close",
                                          style: TextStyle(color: Colors.black),
                                        ))
                                  ],
                                );
                              },
                            );

                            StripePayment.createSourceWithParams(SourceParams(
                              type: 'ideal',
                              amount:
                                  int.parse(widget.plandetails.amount) * 100,
                              currency: 'USD',
                              returnURL: 'example://stripe-redirect',
                            )).then((source) {
                              // ignore: deprecated_member_use
                              _scaffoldKey.currentState.showSnackBar(SnackBar(
                                  content:
                                      Text('Received ${source.sourceId}')));
                              setState(() {
                                _source = source;
                              });
                            }).catchError(setError);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 5),
                            child: Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Container(
                                height: height * 0.07,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: theme.colorBackground,
                                  border: Border.all(
                                    color: theme.colorCompanion,
                                  ),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Text(
                                  "Donate",
                                  style: theme.text16bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: height * .01,
                        ),
                        InkWell(
                          onTap: () async {
                            // StripePayment.createTokenWithCard(
                            //   testCard,
                            // ).then((token) {
                            //   // ignore: deprecated_member_use
                            //   _scaffoldKey.currentState.showSnackBar(SnackBar(
                            //       content: Text('Received ${token.tokenId}')));
                            //   setState(() {
                            //     _paymentToken = token;
                            //   });

                            //   //... payment started

                            //   StripePayment.createPaymentMethod(
                            //     PaymentMethodRequest(
                            //       card: CreditCard(
                            //         token: _paymentToken.tokenId,
                            //       ),
                            //     ),
                            //   ).then((paymentMethod) {
                            //     print(paymentMethod.billingDetails.phone);
                            //     print(paymentMethod.card.brand);
                            //     print(paymentMethod.type);

                            //     // ignore: deprecated_member_use
                            //     _scaffoldKey.currentState.showSnackBar(SnackBar(
                            //         content:
                            //             Text('Received ${paymentMethod.id}')));
                            //     setState(() {
                            //       _paymentMethod = paymentMethod;
                            //     });
                            //   }).catchError(setError);

                            //   //... payment finished
                            // }).catchError(setError);
                            await showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text("Congratulation 👏"),
                                  content: Text(
                                      "You've successfully upgraded your plan."),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          Navigator.of(context).pop();
                                        },
                                        child: Text(
                                          "Close",
                                          style: TextStyle(color: Colors.black),
                                        ))
                                  ],
                                );
                              },
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 5),
                            child: Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Container(
                                height: height * 0.07,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: theme.colorBackground,
                                  border:
                                      Border.all(color: theme.colorCompanion2),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Text(
                                  "Free Access",
                                  style: theme.text16bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: height * 0.02,
                        ),
                        Divider(thickness: 2),
                        SizedBox(
                          height: height * 0.01,
                        ),
                        InkWell(
                          onTap: () {
                            if (Platform.isIOS) {
                              _controller.jumpTo(450);
                            }
                            StripePayment.paymentRequestWithNativePay(
                              androidPayOptions: AndroidPayPaymentRequest(
                                totalPrice: widget.plandetails.amount,
                                currencyCode: "USD",
                              ),
                              applePayOptions: ApplePayPaymentOptions(
                                countryCode: 'US',
                                currencyCode: 'USD',
                                items: [
                                  ApplePayItem(
                                    label: 'Switch to plan',
                                    amount: widget.plandetails.amount,
                                  )
                                ],
                              ),
                            ).then((token) {
                              setState(() {
                                // ignore: deprecated_member_use
                                _scaffoldKey.currentState.showSnackBar(SnackBar(
                                    content:
                                        Text('Received ${token.tokenId}')));
                              });
                            }).catchError(setError);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 5),
                            child: Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Container(
                                height: height * 0.07,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: theme.colorBackground,
                                  border: Border.all(color: theme.colorPrimary),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Text(
                                  Platform.isIOS
                                      ? "Donate With Apple Pay"
                                      : "Donate With G-Pay",
                                  style: theme.text16bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                height: height * 0.35,
                width: width,
                padding: const EdgeInsets.only(
                  right: 40,
                  left: 40,
                  top: 100,
                ),
                child: Card(
                  color: theme.colorBackground,
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: height * 0.0155,
                      ),
                      Container(
                        width: width,
                        padding: EdgeInsets.all(12),
                        child: Text(
                          'Selected Plan : ',
                          style: theme.text16Primary,
                        ),
                      ),
                      Text(
                        '\$ ${widget.plandetails.amount}',
                        style: theme.text20bold,
                      ),
                      SizedBox(
                        height: height * 0.01,
                      ),
                      Text(
                        '${widget.plandetails.name.toUpperCase()}',
                        style: theme.text16,
                      ),
                      Divider(
                        thickness: 1,
                        height: 30,
                        color: theme.colorGrey,
                      ),
                      Text(
                        'Upgrade to unlock premier features.',
                        style: theme.text16,
                      )
                    ],
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
