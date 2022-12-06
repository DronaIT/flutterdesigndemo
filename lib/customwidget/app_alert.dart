import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutter/material.dart';

import 'app_widgets.dart';

class AppAlert {
  static void showAlertDialog(BuildContext context, String message,
      {String positiveButtonText = "OK",
      String negativeButtonText = "Cancel",
      Function? positiveButton}) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const SizedBox(height: 20),
                Container(
                  child: AppWidgets.textBold(message),
                ),
                const SizedBox(height: 40),
                Row(
                  children: <Widget>[
                    const SizedBox(width: 15),
                    Expanded(
                        child: AppWidgets.actionButton(
                            text: negativeButtonText,
                            textColor: colors_name.colorPrimary,
                            bgColor: colors_name.colorWhite,
                            onClick: () {
                              Navigator.pop(context);
                            })),
                    const SizedBox(width: 10),
                    Expanded(
                        child: AppWidgets.actionButton(
                            text: positiveButtonText,
                            textColor: colors_name.colorWhite,
                            bgColor: colors_name.colorPrimary,
                            onClick: () {
                              Navigator.pop(context);
                              if (positiveButton != null) positiveButton();
                            })),
                    const SizedBox(width: 15),
                  ],
                )
              ],
            ),
          );
        });
  }

  static void showInfoDialog(BuildContext context, String message,
      {String positiveButtonText = "Dismiss", Function? positiveButton}) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const SizedBox(height: 20),
                Container(
                  child: AppWidgets.textBold(message),
                ),
                const SizedBox(height: 40),
                AppWidgets.actionButton(
                    text: positiveButtonText,
                    textColor: colors_name.colorWhite,
                    bgColor: colors_name.colorPrimary,
                    onClick: () {
                      Navigator.pop(context);
                      positiveButton!();
                    })
              ],
            ),
          );
        });
  }

  static void showGuestUserAlert(BuildContext context) {
    showAlertDialog(context,
        "Access restricted\nCurrently, you're login as a guest user. do you want to login to use this feature?",
        positiveButtonText: "Login now",
        positiveButton: () {},
        negativeButtonText: 'Dismiss');
  }
}
