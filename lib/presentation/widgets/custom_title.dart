import 'package:flutter/material.dart';

class CustomTitle extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final TextAlign textAlign;

  const CustomTitle({
    Key? key,
    required this.text,
    this.fontSize = 24,
    this.fontWeight = FontWeight.bold,
    this.textAlign = TextAlign.start,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: Color.fromARGB(255, 126, 99, 76),
      ),
    );
  }
}
