import 'package:flutter/material.dart';
import 'package:dz_project/screens/email_sign_in_form.dart';
import 'package:dz_project/services/auth.dart';

// Custom the Emial Sign In page
class EmailSignInPage extends StatelessWidget {
  EmailSignInPage({@required this.auth});
  final AuthBase auth;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff6604c2),
        title: Text('Sign in'),
        elevation: 2.0,
      ),
      //Add Emial Sign in Form Below
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          child: EmailSignInForm(auth: auth),
        ),
      ),
      backgroundColor: Colors.grey[200],
    );
  }
}
