import 'package:flutter/material.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';

import '../values/app_values.dart';

class ElevatedContainer extends StatelessWidget {
  final Widget child;
  final Color bgColor;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;

  const ElevatedContainer({
    Key? key,
    required this.child,
    this.bgColor = colors_name.pageBackground,
    this.padding,
    this.borderRadius = AppValues.smallRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: [
            BoxShadow(
              color: colors_name.elevatedContainerColorOpacity,
              spreadRadius: 3,
              blurRadius: 8,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
          color: colors_name.pageBackground),
      child: child,
    );
  }
}
