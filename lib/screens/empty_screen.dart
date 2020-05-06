import 'package:flutter/material.dart';

//Show Empty Screen when there is any tiem.
class EmptyScreen extends StatelessWidget{
  const EmptyScreen({
    Key key,
    this.title = 'There is no any item',
    this.message = 'Add a new item to get started'
}): super(key: key);
  final String title;
  final String message;

  // Set the size and position
  @override
  Widget build(BuildContext context){
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontSize: 32.0, color: Colors.black87),
          ),
          Text(
            message,
            style: TextStyle(fontSize: 16.0, color: Colors.black87),
          )
        ],
      ),
    );
  }
}