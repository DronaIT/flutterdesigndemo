import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';

class ImagePickerDialog {
  File? pickedImage;

  openDialog(BuildContext context, Function onImagePicked) {
    return showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4.w),
            ),
            title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Profile Image",
                  ),
                  GestureDetector(
                      onTap: () {
                        Navigator.pop(dialogContext);
                      },
                      child: Icon(
                        Icons.close,
                        color: Theme.of(context).primaryColor,
                        size: 6.w,
                      ))
                ]),
            content: Text(
              "Pick image from...",
              style: Theme.of(context).textTheme.labelLarge,
            ),
            actionsPadding: EdgeInsets.fromLTRB(0, 4.w, 0, 7.w),
            actionsAlignment: MainAxisAlignment.spaceEvenly,
            actions: [
              GestureDetector(
                  onTap: () async {
                    Navigator.pop(dialogContext);
                    _pickImage(ImageSource.camera, context, onImagePicked);
                  },
                  child: Container(
                    height: 40.w,
                    width: 40.w,
                    decoration: BoxDecoration(
                        color: colors_name.colorPrimary,
                        borderRadius: BorderRadius.circular(5.w)),
                    child: Icon(Icons.camera_alt_outlined,
                        color: Colors.white, size: 30.w),
                  )),
              GestureDetector(
                  onTap: () async {
                    Navigator.pop(dialogContext);
                    _pickImage(ImageSource.gallery, context, onImagePicked);
                  },
                  child: Container(
                    height: 40.w,
                    width: 40.w,
                    decoration: BoxDecoration(
                        color: colors_name.colorPrimary,
                        borderRadius: BorderRadius.circular(5.w)),
                    child: Icon(Icons.photo_camera_back,
                        color: Colors.white, size: 30.w),
                  )),
            ],
          );
        });
  }

  void _pickImage(ImageSource source, BuildContext context, Function onImagePicked) async {
    try {
      await ImagePicker()
          .pickImage(source: source, imageQuality: 70)
          .then((value) {
        if (value != null) {
          pickedImage = File(value.path);
          onImagePicked(pickedImage);
        }
      });
    } on PlatformException catch (e) {
      showDialog(
          context: context,
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Permission required",
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontSize: 17,
                        // color: ColorName.blue,
                        fontWeight: FontWeight.w500),
                  ),
                  GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: Icon(
                        Icons.close,
                        color: Theme.of(context).primaryColor,
                        size: 20,
                      )),
                ],
              ),
              content: Text(
                  "Permission for ${source.name} is required. Please click 'Yes' to provide permission from settings.",
                  style: const TextStyle(color: Colors.black, fontSize: 14)),
              actionsPadding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
              actions: [
                GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: Text(
                    "Cancel",
                    style: TextStyle(
                        color: Theme.of(context).primaryColor, fontSize: 14),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    Get.back();
                    openAppSettings();
                  },
                  child: Text(
                    "Yes",
                    style: TextStyle(
                        color: Theme.of(context).primaryColor, fontSize: 14),
                  ),
                ),
              ],
              actionsAlignment: MainAxisAlignment.spaceAround,
            );
          });
    }
    return null;
  }
}