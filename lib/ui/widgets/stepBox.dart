import 'package:flutter/material.dart';

class StepBox extends StatelessWidget {
  final int number;
  final String title;
  final Color activeBox;
  final Color activeText;
  final TextStyle style;

  const StepBox(
      {Key? key,
      required this.number,
      required this.title,
      required this.activeBox,
      required this.activeText,
      required this.style})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(color: activeBox),
          width: 40,
          height: 40,
          child: Align(
            alignment: Alignment.center,
            child: Text(
              number.toString(),
              style: TextStyle(color: activeText, fontSize: 25),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        SizedBox(width: 10),
        Text(
          title,
          style: style,
        ),
      ],
    );
  }
}
