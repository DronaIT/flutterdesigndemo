import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  final bool isPassword;

  custom_edittext(
      {this.labelText = "",
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
      this.maxLength = 20,
      this.fontWeight = FontWeight.w700});

  @override
  State<custom_edittext> createState() => _customState();
}

class _customState extends State<custom_edittext> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10, top: widget.topValue),
      alignment: widget.alignment,
      child: TextFormField(
        keyboardType: widget.type,
        textInputAction: widget.textInputAction,
        obscureText: widget.obscure,
        controller: widget.controller,
        enabled: widget.enabled,
        readOnly: widget.readOnly,
        cursorColor: colors_name.colorPrimary,
        inputFormatters: [
          LengthLimitingTextInputFormatter(widget.maxLength), // for mobile
        ],
        minLines: 1,
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
              borderSide:
                  BorderSide(color: colors_name.textColorGreyLight, width: 1.5),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide:
                  BorderSide(color: colors_name.colorPrimary, width: 1.5),
            ),
            labelText: widget.labelText,
            hintText: widget.hintText,
            labelStyle: TextStyle(
                color: widget.color,
                fontSize: widget.size,
                fontWeight: widget.fontWeight),
            floatingLabelBehavior: FloatingLabelBehavior.always),
      ),
    );
  }
}
