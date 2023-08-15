import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import '../values/text_styles.dart';

class AddButton extends StatelessWidget {
  final String title;
  const AddButton({
    super.key, required this.onTap,
    required this.title
  });

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10.w),
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 14.h),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(color: colors_name.green),
          color: colors_name.green.withOpacity(0.2),
          borderRadius: BorderRadius.circular(10.w),
        ),
        child: Text(
          title,
          style: greenText14,
        ),
      ),
    );
  }
}
