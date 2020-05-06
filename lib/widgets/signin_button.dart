import 'package:flutter/material.dart';
import 'package:dz_project/widgets/custom_button.dart';

// Custom ordinary signin Button
class SignInButton extends CustomButton {
  SignInButton({
    @required String text,
    Color color,
    Color textColor,
    VoidCallback onPressed,
  }) : assert(text != null),
        super(
        child: Text(
          text,
          style: TextStyle(color: textColor, fontSize: 15.0),
        ),
        color: color,
        onPressed: onPressed,
      );
}
