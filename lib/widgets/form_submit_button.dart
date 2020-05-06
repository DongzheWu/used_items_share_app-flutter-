import 'package:flutter/material.dart';
import 'package:dz_project/widgets/custom_button.dart';

//Set the Form Sumit Button to submit the Email form
class FormSubmitButton extends CustomButton {
  FormSubmitButton({
    @required String text,
    VoidCallback onPressed,
  }) : super(
    child: Text(
      text,
      style: TextStyle(color: Colors.white, fontSize: 20.0),
    ),
    height: 44.0,
    color: Color(0xffc77ef7),
    borderRadius: 4.0,
    onPressed: onPressed,
  );
}
