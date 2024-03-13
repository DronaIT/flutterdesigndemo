import 'package:flutter/foundation.dart';
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
  final double bottomValue;
  final int maxLines;
  final TextAlign textAlign;
  final EdgeInsetsGeometry? margin;

  const custom_text(
      {super.key,
      required this.text,
      this.color = Colors.black,
      this.size = 30,
      this.fontWeight = FontWeight.bold,
      this.alignment = Alignment.topLeft,
      this.textStyles = centerTextStyle,
      this.maxLines = 1,
      this.topValue = 10.0,
      this.leftValue = 10.0,
      this.rightValue = 10.0,
      this.bottomValue = 10.0,
      this.textAlign = TextAlign.start,
      this.margin});

  @override
  State<custom_text> createState() => CustomTextState();
}

class CustomTextState extends State<custom_text> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.margin ??
          EdgeInsets.only(
              top: kIsWeb ? widget.topValue : widget.topValue,
              left: kIsWeb ? widget.leftValue : widget.leftValue,
              right: kIsWeb ? widget.rightValue : widget.rightValue,
              bottom: kIsWeb ? widget.bottomValue : widget.bottomValue),
      alignment: widget.alignment,
      child: Text(
        widget.text,
        style: widget.textStyles,
        maxLines: widget.maxLines,
        textAlign: widget.textAlign,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
