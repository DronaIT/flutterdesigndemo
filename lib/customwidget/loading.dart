
import 'package:flutter/material.dart';
import 'package:flutterdesigndemo/values/app_values.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'elevated_container.dart';

class Loading extends StatelessWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: ElevatedContainer(
        padding: EdgeInsets.all(AppValues.margin),
        child: CircularProgressIndicator(
          color: colors_name.colorPrimary,
        ),
      ),
    );
  }
}
