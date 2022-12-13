import 'package:flutter/material.dart';

import '../values/text_styles.dart';

class custom_text extends StatefulWidget {
  final String text;
  final Color color;
  final double size;
  final double topValue;
  final FontWeight fontWeight;
  final Alignment alignment;
  final TextStyle textStyles;
  final double leftValue;
  final double rightValue;

  custom_text(
      {required this.text,
      this.color = Colors.black,
      this.size = 30,
      this.fontWeight = FontWeight.bold,
      this.alignment = Alignment.topLeft,
      this.textStyles = centerTextStyle,
      this.topValue = 10.0,
        this.leftValue = 10.0,
        this.rightValue = 10.0});

  @override
  State<custom_text> createState() => _custom_textState();
}

class _custom_textState extends State<custom_text> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: widget.topValue, left: widget.leftValue, right:widget.rightValue),
      alignment: widget.alignment,
      child: Text(
        widget.text,
        style: widget.textStyles,
      ),
    );
  }
}
