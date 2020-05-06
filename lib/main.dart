import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dz_project/screens/landing_screen.dart';
import 'package:dz_project/services/auth.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context){
//Main page, return Landing page to check if user has login.
    return  MaterialApp(
          home:LandingPage(
            // Pass the Auth class to LandingPage
            auth: Auth(),
          ),
    );
  }
}