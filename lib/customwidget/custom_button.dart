import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';

class CustomButton extends StatefulWidget {
  final String text;
  final double fontSize;
  final double bWidth;
  final Color color;
  final FontWeight fontWeight;
  final TextAlign textAlign;
  final Function() click;

  const CustomButton({
    required this.text,
    required this.click,
    this.fontSize = 20,
    this.bWidth = 0,
    this.color = Colors.white,
    this.textAlign = TextAlign.center,
    this.fontWeight = FontWeight.w700,
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10.h, bottom: 10.h),
      width: widget.bWidth > 0 ? widget.bWidth : MediaQuery.of(context).size.width * 0.7,
      height: 45.h,
      child: ElevatedButton(
        onPressed: widget.click,
        style: ElevatedButton.styleFrom(
          primary: colors_name.colorPrimary,
          padding: EdgeInsets.all(10.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 7.0,
        ),
        child: Text(
          widget.text,
          textAlign: widget.textAlign,
          style: TextStyle(fontSize: widget.fontSize, color: widget.color, fontWeight: widget.fontWeight),
        ),
      ),
    );
  }
}

class CustomButtonOutline extends StatefulWidget {
  final String text;
  final double fontSize;
  final double bWidth;
  final Color color;
  final FontWeight fontWeight;
  final TextAlign textAlign;
  final Function() click;

  const CustomButtonOutline({super.key, required this.text, required this.click, this.fontSize = 20, this.bWidth = 0, this.color = colors_name.colorPrimary, this.textAlign = TextAlign.center, this.fontWeight = FontWeight.w700});

  @override
  State<CustomButtonOutline> createState() => _CustomButtonOutlineState();
}

class _CustomButtonOutlineState extends State<CustomButtonOutline> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10.h, bottom: 10.h),
      width: widget.bWidth > 0 ? widget.bWidth : MediaQuery.of(context).size.width * 0.7,
      height: 45.h,
      child: ElevatedButton(
        onPressed: widget.click,
        style: ElevatedButton.styleFrom(
          primary: colors_name.colorWhite,
          padding: EdgeInsets.all(10.h),
          side: BorderSide(color: colors_name.colorPrimary, width: 2.w),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 7.0,
        ),
        child: Text(
          widget.text,
          textAlign: widget.textAlign,
          style: TextStyle(fontSize: widget.fontSize, color: widget.color, fontWeight: widget.fontWeight),
        ),
      ),
    );
  }
}
