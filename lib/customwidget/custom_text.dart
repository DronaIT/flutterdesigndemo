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

  custom_text({required this.text, this.color = Colors.black,
    this.size = 30, this.fontWeight = FontWeight.bold, this.alignment = Alignment.topLeft, this.textStyles = centerTextStyle,
    this.maxLines = 1, this.topValue = 10.0, this.leftValue = 10.0, this.rightValue = 10.0, this.bottomValue = 10.0, this.textAlign = TextAlign.start,this.margin});

  @override
  State<custom_text> createState() => _custom_textState();

}

class _custom_textState extends State<custom_text> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.margin ?? EdgeInsets.only(top: widget.topValue, left: widget.leftValue, right: widget.rightValue, bottom: widget.bottomValue),
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
