import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutter/material.dart';

//Default appbar customized with the design of our app
class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  final String appBarTitleText;
  final List<Widget>? actions;
  final bool isBackButtonEnabled;

  CustomAppBar({
    Key? key,
    required this.appBarTitleText,
    this.actions,
    this.isBackButtonEnabled = true,
  }) : super(key: key);

  @override
  Size get preferredSize => AppBar().preferredSize;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: colors_name.appBarColor,
      centerTitle: true,
      elevation: 0,
      automaticallyImplyLeading: isBackButtonEnabled,
      actions: actions,
      iconTheme: const IconThemeData(color: colors_name.appBarIconColor),
      title: Text(appBarTitleText,
        style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            height: 1.15,
            color: colors_name.appBarTextColor),
        textAlign: TextAlign.center,),
    );
  }
}

