import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import '../values/text_styles.dart';

class AddButton extends StatelessWidget {
  final String title;
  Alignment? alignment;
  int? type;

  AddButton({
    super.key,
    required this.onTap,
    required this.title,
    this.alignment,
    this.type,
  });

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          margin: EdgeInsets.symmetric(horizontal: 10.w),
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
          alignment: alignment ?? Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(color: type == null ? colors_name.green : colors_name.coffee),
            color: type == null ? colors_name.green.withOpacity(0.2) : colors_name.coffee.withOpacity(0.2),
            borderRadius: BorderRadius.circular(10.w),
          ),
          child: Row(
            mainAxisAlignment: type == null ? MainAxisAlignment.center : MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: type == null ? greenText14 : coffeeText14,
              ),
              type != null ? Icon(Icons.arrow_forward_ios, size: 16.h, color: colors_name.coffee) : Container(),
            ],
          )),
    );
  }
}
