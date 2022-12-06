import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../utils/image_dialog.dart';

class AppImage {
  static String commanName = "assets/images/";
  static String LOGO = "assets/images/test.jpg";
  static String ic_splash = "${commanName}ic_splash.png";
  static String ic_welcome = "${commanName}welcome.json";
  static String ic_avtar = "${commanName}ic_avtar.png";
  static String ic_launcher = "${commanName}ic_launcher.png";


  static Widget loadSVG(String image,
      {double width = double.maxFinite,
      double height = double.maxFinite,
      BoxFit fit = BoxFit.contain,
      double radius = 0,
      Color? color}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: SvgPicture.asset(
        image,
        width: width,
        fit: fit,
        height: height,
        color: color,
      ),
    );
  }

  static Widget loadSVGRotation(String image,
      {double width = double.maxFinite,
      double height = double.maxFinite,
      BoxFit fit = BoxFit.contain,
      double radius = 0,
      Color? color}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: Transform(
        alignment: Alignment.center,
        transform: Matrix4.rotationY(3.14),
        child: SvgPicture.asset(
          image,
          width: width,
          fit: fit,
          height: height,
          color: color,
        ),
      ),
    );
  }

  static Widget load(String image,
      {double width = double.maxFinite,
      double height = double.maxFinite,
      BoxFit fit = BoxFit.contain,
      double radius = 0}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: Image.asset(
        image,
        width: width,
        fit: fit,
        height: height,
      ),
    );
  }

  static Widget network(String image,
      {BoxFit fit = BoxFit.cover,
      double radius = 0,
      double width = double.maxFinite,
      double height = double.maxFinite,
      required BuildContext context}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: GestureDetector(
        child: CachedNetworkImage(
          fit: fit,
          height: height,
          width: width,
          imageUrl: image,
          placeholder: (context, url) => SizedBox(
              width: width,
              height: height,
              child: const SizedBox(
                height: 20,
                width: 20,
                child: Center(
                  child: CircularProgressIndicator(strokeWidth: 5),
                ),
              )),
          errorWidget: (context, url, error) {
            return load("", width: width, height: height, fit: BoxFit.contain);
          },
        ),
        onTap: () async {
          showDialog(
            context: context,
            builder: (context) {
              return ImageDialog(image: image);
            },
          );
        },
      ),
    );
  }
}
