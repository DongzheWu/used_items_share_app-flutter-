import 'package:flutter/material.dart';
import 'package:dz_project/screens/signin_screen.dart';
import 'package:dz_project/screens/list_screen.dart';
import 'package:dz_project/services/auth.dart';
import 'package:dz_project/models/database.dart';
import 'package:provider/provider.dart';

//Landing page for checking the user login.
class LandingPage extends StatelessWidget{
  LandingPage({@required this.auth});
  final AuthBase auth;

  @override
  Widget build(BuildContext context){
    return StreamBuilder<User>(
      stream: auth.onAuthStateChanged,
      builder: (context, snapshot){
        if(snapshot.connectionState == ConnectionState.active) {
          User user = snapshot.data;
          if (user == null) {
            //if user hasn't login, it turns to sign in page
            return SigninScreen(
              auth: auth,
            );
          }
          //otherwise, it turns to list page to show the list of items
          return Provider<Database>(
            builder: (_) => FirestoreDatabase(uid: user.uid),
            child: ListScreen(
              auth: auth,
              user: user,
            ),
          );

        }else{
          return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
        }
      }
    );

  }
}

