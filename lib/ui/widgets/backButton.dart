import 'package:flutter/material.dart';

class MyBackButton extends StatelessWidget {
  final Color color;

  const MyBackButton({Key? key, required this.color}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'backButton',
        child: GestureDetector(
        onTap: (){
          Navigator.pop(context);
        },
          child: Align(
          alignment: Alignment.centerLeft,
          child: Icon(
            Icons.arrow_back_ios,
            size: 40,
            color: color,
          ),
        ),
      ),
    );
  }
}