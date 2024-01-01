import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterdesigndemo/values/text_styles.dart';
import '../values/app_images.dart';
import 'app_text_style.dart';

class AppWidgets {
  static Text textRegular(String text,
      {Color color = Colors.black, double size = 16, maxLines = 1}) {
    return Text(
      text,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      style: AppTextStyle.normal(color, 16.sp),
    );
  }

  static Text textItalic(String text,
      {Color color = Colors.black, double size = 16}) {
    return Text(
      text,
      maxLines: 2,
      style: AppTextStyle.italic(color, size),
      overflow: TextOverflow.ellipsis,
    );
  }

  static Text textMedium(String text,
      {Color color = Colors.black, double size = 16, maxLines = 1}) {
    return Text(text,
        maxLines: maxLines,
        overflow: TextOverflow.ellipsis,
        style: AppTextStyle.medium(color, size));
  }

  static Text textBold(String text,
      {Color color = Colors.black, double size = 16, maxLine = 1}) {
    return Text(text,
        maxLines: maxLine,
        overflow: TextOverflow.visible,
        style: AppTextStyle.bold(color: color, fontSize: size.toInt()));
  }


  static Widget buttonLoader(String text, bool showLoading,
      {double paddingTop = 30,
        backgroundColor = colors_name.colorPrimary,
        textColor = colors_name.colorWhite,
        required Function onClick}) {
    return Padding(
      padding: EdgeInsetsDirectional.only(top: paddingTop),
      child: GestureDetector(
        onTap: onClick(),
        child: Center(
          child: Container(
              padding: const EdgeInsets.only(top: 20, bottom: 20),
              decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: const BorderRadius.all(Radius.circular(35))),
              child: showLoading
                  ? Container(
                  alignment: Alignment.center,
                  height: 20,
                  width: 20,
                  child: const CircularProgressIndicator(
                      color: Colors.white))
                  : Text(
                text,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyle.bold(color: textColor, fontSize: 18),
              )),
        ),
      ),
    );
  }

  static Widget button(String text,
      {double paddingTop = 30,
        backgroundColor = colors_name.colorPrimary,
        textColor = colors_name.colorWhite,
        Function? onClick}) {
    return Padding(
      padding: EdgeInsetsDirectional.only(top: paddingTop),
      child: GestureDetector(
        onTap: onClick!(),
        child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.only(top: 20, bottom: 20),
            decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: const BorderRadius.all(Radius.circular(35))),
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyle.bold(color: textColor, fontSize: 18),
            )),
      ),
    );
  }

  static Widget actionButton({required String text,
    required Color textColor,
    required Color bgColor,
    required Function onClick,
    double textSize = 14}) {
    return GestureDetector(
      onTap: onClick(),
      child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
              color: bgColor,
              border: Border.all(color: textColor),
              borderRadius: const BorderRadius.all(Radius.circular(25))),
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style:
            AppTextStyle.bold(color: textColor, fontSize: textSize.toInt()),
          )),
    );
  }

  static Widget inputField(BuildContext context, String hint,
      {TextInputAction textInputAction = TextInputAction.next,
        String initialValue = "",
        required TextEditingController controller,
        bool obscureText = false,
        int maxLines = 1,
        int maxLength = 100,
        bool enabled = true,
        bool readOnly = false,
        TextInputType keyboardType = TextInputType.text,
        Function? onClick}) {
    return TextFormField(
        controller: controller,
        initialValue: initialValue,
        obscureText: obscureText,
        textInputAction: textInputAction,
        enabled: enabled,
        readOnly: readOnly,
        keyboardType: keyboardType,
        onTap: onClick!(),
        style: AppTextStyle.bold(
            color: enabled ? Colors.black : colors_name.textColorBlueGreyDark,
            fontSize: 16),
        onFieldSubmitted: (v) {
          if (textInputAction == TextInputAction.next) {
            FocusScope.of(context).nextFocus();
          }
        },
        maxLines: maxLines,
        maxLength: maxLength,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(top: 15, bottom: 15),
          labelText: hint,
          counterText: '',
          labelStyle:
          AppTextStyle.normal(colors_name.textColorBlueGreyDark, 14),
        ));
  }

  static Widget cardInputField(BuildContext context, String hint,
      {TextInputAction textInputAction = TextInputAction.next,
        required TextEditingController controller,
        String initialValue = "",
        bool obscureText = false,
        bool enabled = true}) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 2,
      color: colors_name.colorWhite,
      child: Padding(
        padding: const EdgeInsets.only(top: 5, bottom: 5),
        child: TextFormField(
            controller: controller,
            initialValue: initialValue,
            obscureText: obscureText,
            enabled: enabled,
            textInputAction: textInputAction,
            style: AppTextStyle.normal(Colors.black, 14),
            onFieldSubmitted: (v) {
              if (textInputAction == TextInputAction.next) {
                FocusScope.of(context).nextFocus();
              }
            },
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: const EdgeInsets.only(left: 15, right: 15),
              hintText: hint,
              hintStyle:
              AppTextStyle.normal(colors_name.textColorBlueGreyDark, 14),
            )),
      ),
    );
  }

  static Widget cardLocationField(BuildContext context, String hint,
      {TextInputAction textInputAction = TextInputAction.next,
        required TextEditingController controller,
        String initialValue = "",
        bool obscureText = false,
        bool enabled = true}) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 2,
      color: colors_name.colorWhite,
      child: const Padding(
        padding: EdgeInsets.only(top: 5, bottom: 5),
        // child: PlacesAutocompleteField(
        //     apiKey: kGoogleApiKey,
        //     controller: controller,
        //     hint: hint,
        //     onSelected: (p) {
        //       mEvents.displayPrediction(p);
        //     },
        //     inputDecoration: InputDecoration(
        //       border: InputBorder.none,
        //       contentPadding: EdgeInsets.only(left: 15, right: 55),
        //       hintText: hint,
        //       hintStyle: AppString.normal(AppColors.darkSage, 14),
        //     )),
      ),
    );
  }

  static Widget appNoData(String message, bool isShowImage) {
    return Container(
      alignment: Alignment.center,
      height: double.infinity,
      width: double.infinity,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            isShowImage == false
                ? Container()
                : Container(
              width: 120.0,
              height: 120.0,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                color: Colors.black12,
              ),
              child: AppImage.load(
                AppImage.LOGO,
              ),
            ),
            Container(height: 30),
            textBold(message, color: colors_name.colorPrimary, size: 18.0)
          ],
        ),
      ),
    );
  }

  static AppBar appBarWithoutBack(String title) {
    return AppBar(
      centerTitle: true,
      backgroundColor: colors_name.colorPrimary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(14),
        ),
      ),
      title: Text(title, style: whiteTextSemiBold20),
      iconTheme: const IconThemeData(color: colors_name.colorWhite),
    );
  }


  static AppBar appBarWithAction(String title,List<Widget>? actions) {
    return AppBar(
      centerTitle: true,
      backgroundColor: colors_name.colorPrimary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(14),
        ),
      ),
      title: Text(title, style: whiteTextSemiBold20),
      actions: actions,
      iconTheme: const IconThemeData(color: colors_name.colorWhite),
    );
  }


  static AppBar appBar(BuildContext context, String title,
      {List<Widget>? actions}) {
    return AppBar(
      leading: GestureDetector(
        onTap: () {
          Navigator.pop(context, false);
        },
      ),
      titleSpacing: 0,
      centerTitle: false,
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      actions: actions,
      title: Transform(
        transform: Matrix4.translationValues(-25.0, 0.0, 0.0),
        child: GestureDetector(
            child: Container(
              padding: const EdgeInsets.all(15),
              child: Stack(
                children: [
                  AppWidgets.textMedium(title,
                      color: colors_name.colorWhite, size: 24)
                ],
              ),
            ),
            onTap: () {
              Navigator.pop(context, false);
            }),
      ),
    );
  }

  // static Widget toolBarBackground(BuildContext context,
  //     {double height = 0.13}) {
  //   var vHeight = MediaQuery.of(context).size.height * height;
  //   return ClipRRect(
  //     borderRadius: const BorderRadius.only(
  //         bottomRight: Radius.circular(35), bottomLeft: Radius.circular(35)),
  //     child: Image.asset(
  //       AppImage.BACKGROUND,
  //       width: double.maxFinite,
  //       fit: BoxFit.fitWidth,
  //       height: vHeight,
  //     ),
  //   );
  // }

  static Widget loader() {
    return Center(
      child: Container(
        constraints: const BoxConstraints.expand(),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.2),
        ),
        child: const CircularProgressIndicator(),
      ),
    );
  }

  static Widget spannableText(String normalText, String spannable,
      TextStyle spannableStyle) {
    return Text.rich(

        TextSpan(
            text: normalText,
            children: <InlineSpan>[
              TextSpan(
                text: spannable,
                style: spannableStyle,
              )
            ]
        )

    );
  }

}
