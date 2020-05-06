import 'package:flutter/material.dart';
import 'package:dz_project/services/auth.dart';
import 'package:dz_project/widgets/signin_button.dart';
import 'package:dz_project/screens/email_sign_in_screen.dart';
import 'package:dz_project/widgets/social_sign_in_button.dart';

//Create the Signin Page
class SigninScreen extends StatelessWidget{
  SigninScreen({@required this.auth});
  final AuthBase auth;

  //Function for signing in as a guest
  Future<void> _signInAnonymously() async{
    try{
      await auth.signInAnonymously();
    }catch(e){
      print(e.toString());
    }
  }
//Function for signing in with Google account
  Future<void> _signInWithGoogle() async{
    try{
      await auth.signInWithGoogle();
    }catch(e){
      print(e.toString());
    }
  }
//Function for signing in with Email
  void _signInWithEmail(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (context) => EmailSignInPage(auth: auth),
      ),
    );
  }

  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff6604c2),
        title:  Text('HyperGarageSale'),
      ),

      body: _paddingFuction(context),
    );
  }
  @override
  Widget _paddingFuction(BuildContext context){
    return Padding(

      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
              'Sign in',

              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 32.0,
                fontWeight: FontWeight.w600,
                color: Color(0xffc77ef7),
              )
          ),
          SizedBox(height: 48.0),
          SocialSignInButton(
            assetName: 'images/google-logo.png',
            text: 'Sign in with Google account',
            textColor: Colors.black87,
            color: Colors.white,
            onPressed: _signInWithGoogle,
          ),
          SizedBox(height: 8.0),
          SignInButton(
            text: 'Sign in with email',
            textColor: Colors.white,
            color: Color(0xffc77ef7),
            onPressed: () => _signInWithEmail(context),
          ),
          SizedBox(height: 8.0),
          SignInButton(
            text:'Sign in as a guest',
            textColor: Colors.white,
            color: Color(0xffc77ef7),
            onPressed: _signInAnonymously,
          )


        ],

      ),
    );


//    return Scaffold(
//      appBar: AppBar(
//        title: Text("App"),
//      ),
//      body: Container(
//        child: RaisedButton(
//          onPressed: _signInAnonymously,
//
//        ),
//      )
//    );
  }

}