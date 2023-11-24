import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';

class custom_edittext extends StatefulWidget {
  final bool enabled;
  final bool readOnly;
  final String labelText;
  final String hintText;
  final Color color;
  final double topValue;
  final Alignment alignment;
  final TextInputType type;
  final TextInputAction textInputAction;
  bool obscure;
  final TextEditingController controller;
  final double size;
  final FontWeight fontWeight;
  final int maxLength;
  final int maxLines;
  final int minLines;
  final bool isPassword;
  final TextCapitalization capitalization;
  final TextAlign textalign;
  final EdgeInsetsGeometry? margin;

  custom_edittext(
      {super.key,
      this.labelText = "",
      this.hintText = "",
      this.color = Colors.black,
      this.alignment = Alignment.topLeft,
      this.topValue = 10.0,
      required this.type,
      required this.textInputAction,
      this.obscure = false,
      required this.controller,
      this.size = 18,
      this.enabled = true,
      this.readOnly = false,
      this.isPassword = false,
      this.maxLength = 100,
      this.maxLines = 1,
      this.minLines = 1,
      this.capitalization = TextCapitalization.sentences,
      this.fontWeight = FontWeight.w700,
      this.textalign = TextAlign.start,
      this.margin});

  @override
  State<custom_edittext> createState() => _customState();
}

class _customState extends State<custom_edittext> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.margin ?? EdgeInsets.only(left: 10, right: 10, top: widget.topValue),
      alignment: widget.alignment,
      child: TextFormField(
        keyboardType: widget.type,
        textInputAction: widget.textInputAction,
        obscureText: widget.obscure,
        controller: widget.controller,
        enabled: widget.enabled,
        readOnly: widget.readOnly,
        maxLines: widget.maxLines,
        textAlign: widget.textalign,
        textCapitalization: widget.capitalization,
        cursorColor: colors_name.colorPrimary,
        inputFormatters: [
          LengthLimitingTextInputFormatter(widget.maxLength), // for mobile
        ],
        minLines: widget.minLines,
        decoration: InputDecoration(
            suffixIcon: widget.isPassword
                ? IconButton(
                    icon: Icon(
                      widget.obscure ? Icons.visibility : Icons.visibility_off,
                      color: colors_name.colorPrimary,
                    ),
                    onPressed: () {
                      setState(() {
                        widget.obscure = !widget.obscure;
                      });
                    },
                  )
                : null,
            border: const OutlineInputBorder(),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: colors_name.textColorGreyLight, width: 1.5),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: colors_name.colorPrimary, width: 1.5),
            ),
            labelText: widget.labelText,
            hintText: widget.hintText,
            labelStyle: TextStyle(color: widget.color, fontSize: widget.size, fontWeight: widget.fontWeight),
            floatingLabelBehavior: FloatingLabelBehavior.always),
      ),
    );
  }
}
