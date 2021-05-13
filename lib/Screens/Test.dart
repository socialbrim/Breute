import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';

class EmailLinkSignInSection extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _EmailLinkSignInSectionState();
}

class _EmailLinkSignInSectionState extends State<EmailLinkSignInSection>
    with WidgetsBindingObserver {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  bool _success;
  String _userEmail;
  String _userID;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    _emailController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              child: const Text('Test sign in with email and link'),
              padding: const EdgeInsets.all(16),
              alignment: Alignment.center,
            ),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              validator: (String value) {
                if (value.isEmpty) {
                  return 'Please enter your email.';
                }
                return null;
              },
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              alignment: Alignment.center,
              child: RaisedButton(
                onPressed: () async {
                  _signInWithEmailAndLink();
                  if (_formKey.currentState.validate()) {}
                },
                child: const Text('Submit'),
              ),
            ),
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                _success == null
                    ? ''
                    : (_success
                        ? 'Successfully signed in, uid: ' + _userID
                        : 'Sign in failed'),
                style: TextStyle(color: Colors.red),
              ),
            )
          ],
        ),
      ),
    );
  }
}

Future<void> _signInWithEmailAndLink() async {
  return await FirebaseAuth.instance.sendSignInLinkToEmail(
    email: 'deveshgarg9829@gmail.com',
    actionCodeSettings: ActionCodeSettings(
      url: 'https://brueteapp.page.link',
      handleCodeInApp: true,
      androidMinimumVersion: "1",
      androidPackageName: "com.example.parentpreneur",
      androidInstallApp: true,
    ),
  );
}

void handleLink(Uri link) async {
  if (link != null) {
    final FirebaseUser user = (await FirebaseAuth.instance.signInWithEmailLink(
      email: "deveshgarg9829@gmail.com",
      emailLink: link.toString(),
    ))
        .user;
    if (user != null) {
      print("ddddddddddddddddddddddddddd");
    } else {
      print("ddddddddddddddddddddddddddd");
    }
  } else {
    print("ddddddddddddddddddddddddddd");
  }
}

@override
void didChangeAppLifecycleState(AppLifecycleState state) async {
  if (state == AppLifecycleState.resumed) {
    final PendingDynamicLinkData data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    if (data?.link != null) {
      handleLink(data?.link);
    }
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
      final Uri deepLink = dynamicLink?.link;
      handleLink(deepLink);
    }, onError: (OnLinkErrorException e) async {
      print('onLinkError');
      print(e.message);
    });
  }
}
