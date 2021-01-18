import 'package:stripe_payment/stripe_payment.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import '../models/PlanDetail.dart';

class Payments extends StatefulWidget {
  PlanName plandetails;
  Payments({this.plandetails});
  @override
  _PaymentsState createState() => new _PaymentsState();
}

class _PaymentsState extends State<Payments> {
  Token _paymentToken;
  PaymentMethod _paymentMethod;
  String _error;
  final String _currentSecret =
      "sk_test_51IAWW6HpwMJhGfYrD1LC6dZb2cZ7RbMPFHHlqql2XbfDaP1lI8OTEZq0x1QrsctJUI2xtVjode9POKOe8trBNDqM00wzU3Iovi";
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
    setState(() {
      _error = error.toString();
    });
  }

  void successfulPaid() {
    //...
    // FirebaseDatabase
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: new Scaffold(
          key: _scaffoldKey,
          body: ListView(
            controller: _controller,
            padding: const EdgeInsets.all(20),
            children: <Widget>[
              RaisedButton(
                child: Text("Create Payment Online"),
                onPressed: () {
                  StripePayment.createSourceWithParams(SourceParams(
                    type: 'ideal',
                    amount: int.parse(widget.plandetails.amount) * 100,
                    currency: 'USD',
                    returnURL: 'example://stripe-redirect',
                  )).then((source) {
                    // ignore: deprecated_member_use
                    _scaffoldKey.currentState.showSnackBar(
                        SnackBar(content: Text('Received ${source.sourceId}')));
                    setState(() {
                      _source = source;
                    });
                  }).catchError(setError);
                },
              ),
              RaisedButton(
                child: Text("Pay With Card"),
                onPressed: () {
                  StripePayment.createTokenWithCard(
                    testCard,
                  ).then((token) {
                    // ignore: deprecated_member_use
                    _scaffoldKey.currentState.showSnackBar(
                        SnackBar(content: Text('Received ${token.tokenId}')));
                    setState(() {
                      _paymentToken = token;
                    });

                    //... payment started

                    StripePayment.createPaymentMethod(
                      PaymentMethodRequest(
                        card: CreditCard(
                          token: _paymentToken.tokenId,
                        ),
                      ),
                    ).then((paymentMethod) {
                      print(paymentMethod.billingDetails.phone);
                      print(paymentMethod.card.brand);
                      print(paymentMethod.type);

                      _scaffoldKey.currentState.showSnackBar(SnackBar(
                          content: Text('Received ${paymentMethod.id}')));
                      setState(() {
                        _paymentMethod = paymentMethod;
                      });
                    }).catchError(setError);

                    //... payment finished
                  }).catchError(setError);
                },
              ),
              Divider(),
              RaisedButton(
                child: Text(
                  Platform.isIOS ? "Pay With Apple Pay" : "Pay With G-Pay",
                ),
                onPressed: () {
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
                      _scaffoldKey.currentState.showSnackBar(
                          SnackBar(content: Text('Received ${token.tokenId}')));
                      _paymentToken = token;
                    });
                  }).catchError(setError);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
