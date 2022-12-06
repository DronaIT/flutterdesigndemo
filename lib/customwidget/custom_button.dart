import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutter/material.dart';



class CustomButton extends StatefulWidget {
  final String text;
  final double fontSize;
  final Color color;
  final FontWeight fontWeight;
  final TextAlign textAlign;
  final Function() click;

  const CustomButton(
      {required this.text,
      required this.click,
      this.fontSize = 20,
      this.color = Colors.white,
      this.textAlign = TextAlign.center,
      this.fontWeight = FontWeight.w700});

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10, bottom: 10),
      width: MediaQuery.of(context).size.width * 0.7,
      child: ElevatedButton(
        onPressed: widget.click,
        style: ElevatedButton.styleFrom(
          primary:colors_name.colorPrimary,
          padding: const EdgeInsets.all(13),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 7.0,
        ),
        child: Text(
          widget.text,
          textAlign: widget.textAlign,
          style: TextStyle(fontSize: 20, color: widget.color, fontWeight: widget.fontWeight),
        ),
      ),
    );
  }
}
