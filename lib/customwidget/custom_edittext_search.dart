import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';

import '../values/text_styles.dart';

// ignore: must_be_immutable
class CustomEditTextSearch extends StatefulWidget {
  final String hintText;
  final Color color;
  final TextInputType type;
  final TextInputAction textInputAction;
  final TextEditingController controller;
  final double size;
  final FontWeight fontWeight;
  String prefixIcon;
  final Function(String)? onChanges;

  CustomEditTextSearch(
      {super.key,
      this.hintText = "Search here..",
      this.color = Colors.black,
      required this.type,
      required this.textInputAction,
      required this.controller,
      this.size = 18,
      this.fontWeight = FontWeight.w700,
      this.onChanges,
      this.prefixIcon = ""});

  @override
  State<CustomEditTextSearch> createState() => _CustomState();
}

class _CustomState extends State<CustomEditTextSearch> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      height: 35.w,
      alignment: Alignment.center,
      child: TextFormField(
          keyboardType: widget.type,
          textInputAction: widget.textInputAction,
          controller: widget.controller,
          textAlignVertical: TextAlignVertical.center,
          textAlign: TextAlign.start,
          maxLines: 1,
          cursorColor: colors_name.colorPrimary,
          minLines: 1,
          onChanged: widget.onChanges,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.black12,
            border: OutlineInputBorder(
              borderRadius: const BorderRadius.all(
                const Radius.circular(10.0),
              ),
              borderSide: BorderSide(
                width: 0,
                style: BorderStyle.none,
              ),
            ),
            prefixIconColor: Colors.black87,
            prefixIcon: IconButton(onPressed: () {}, icon: Icon(Icons.search)),
            prefixIconConstraints: BoxConstraints(maxWidth: 35),
            contentPadding: EdgeInsets.zero,
            hintText: widget.hintText,
          )),
    );
  }
}
