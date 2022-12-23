import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterdesigndemo/utils/preference.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';

extension E on String {
  String lastChars(int n) => substring(length - n);
}

class FormValidator {
  static bool validateEmail(String? email) {
    String pattern = r'^([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5})$';
    RegExp regExp = RegExp(pattern);
    if (!regExp.hasMatch(email!)) {
      return false;
    }
    return true;
  }

  static String validatePassword(String? value) {
    if (value!.isEmpty) return strings_name.str_empty_password;
    if (value.length < 6) return strings_name.str_password_length;
    return "";
  }

  static String validateCPassword(String? value) {
    if (value!.isEmpty) return strings_name.str_empty_confirm_password;
    if (value.length < 6) return strings_name.str_confirm_password_length;
    return "";
  }

  static String validatePhone(String? value) {
    if (value!.isEmpty) return strings_name.str_empty_phone;
    if (value.length < 10) return strings_name.str_phone_length;
    return "";
  }
}

class Utils {
  //set status bar color
  static String timeAgoSinceDate(int dateString, {bool numericDates = true}) {
    DateTime mDate = DateTime.fromMillisecondsSinceEpoch(dateString);
//    DateTime mDate = DateFormat("dd-MM-yyyy h:mma").parse(dateString);
    final date2 = DateTime.now();
    Duration difference;
    if (date2.compareTo(mDate) > 0) {
      difference = date2.difference(mDate);
      if ((difference.inDays / 365).floor() >= 2) {
        return 'Completed ${(difference.inDays / 365).floor()} years ago';
      } else if ((difference.inDays / 365).floor() >= 1) {
        return (numericDates) ? 'Completed 1 year ago' : 'Completed Last year';
      } else if ((difference.inDays / 30).floor() >= 2) {
        return 'Completed ${(difference.inDays / 365).floor()} months ago';
      } else if ((difference.inDays / 30).floor() >= 1) {
        return (numericDates) ? 'Completed 1 month ago' : 'Completed Last month';
      } else if ((difference.inDays / 7).floor() >= 2) {
        return 'Completed ${(difference.inDays / 7).floor()} weeks ago';
      } else if ((difference.inDays / 7).floor() >= 1) {
        return (numericDates) ? 'Completed 1 week ago' : 'Completed Last week';
      } else if (difference.inDays >= 2) {
        return 'Completed ${difference.inDays} days ago';
      } else if (difference.inDays >= 1) {
        return (numericDates) ? 'Completed 1 day ago' : 'Completed Yesterday';
      } else if (difference.inHours >= 2) {
        return 'Completed ${difference.inHours} hours ago';
      } else if (difference.inHours >= 1) {
        return (numericDates) ? 'Completed 1 hour ago' : 'Completed An hour ago';
      } else if (difference.inMinutes >= 2) {
        return 'Completed ${difference.inMinutes} minutes ago';
      } else if (difference.inMinutes >= 1) {
        return (numericDates) ? 'Completed 1 minute ago' : 'Completed A minute ago';
      } else if (difference.inSeconds >= 3) {
        return 'Completed ${difference.inSeconds} seconds ago';
      } else {
        return 'Just now';
      }
    } else {
      difference = mDate.difference(date2);

      if ((difference.inDays / 365).floor() >= 2) {
        return '${(difference.inDays / 365).floor()} years left';
      } else if ((difference.inDays / 365).floor() >= 1) {
        return (numericDates) ? '1 year left' : 'An year left';
      } else if ((difference.inDays / 30).floor() >= 2) {
        return '${(difference.inDays / 365).floor()} months left';
      } else if ((difference.inDays / 30).floor() >= 1) {
        return (numericDates) ? '1 month left' : 'An month left';
      } else if ((difference.inDays / 7).floor() >= 2) {
        return '${(difference.inDays / 7).floor()} weeks left';
      } else if ((difference.inDays / 7).floor() >= 1) {
        return (numericDates) ? '1 week left' : 'An week left';
      } else if (difference.inDays >= 2) {
        return '${difference.inDays} days left';
      } else if (difference.inDays >= 1) {
        return (numericDates) ? '1 day left' : 'Yesterday';
      } else if (difference.inHours >= 2) {
        return '${difference.inHours} hours left';
      } else if (difference.inHours >= 1) {
        return (numericDates) ? '1 hour left' : 'An hour left';
      } else if (difference.inMinutes >= 2) {
        return '${difference.inMinutes} minutes left';
      } else if (difference.inMinutes >= 1) {
        return (numericDates) ? '1 minute left' : 'A minute left';
      } else if (difference.inSeconds >= 3) {
        return '${difference.inSeconds} seconds left';
      } else {
        return 'Just now';
      }
    }
  }

  static void showSnackBar(BuildContext context, String message) {
    Flushbar(
      flushbarStyle: FlushbarStyle.GROUNDED,
      flushbarPosition: FlushbarPosition.BOTTOM,
      animationDuration: const Duration(seconds: 1),
      backgroundColor: colors_name.colorPrimary,
      message: message,
      messageText: Text(message, style: TextStyle(color: Colors.white, fontSize: 12.sp)),
      duration: const Duration(seconds: 2),
    ).show(context);
  }

  static void showSnackBarDuration(BuildContext context, String message, int second) {
    Flushbar(
      flushbarStyle: FlushbarStyle.GROUNDED,
      flushbarPosition: FlushbarPosition.BOTTOM,
      animationDuration: const Duration(seconds: 1),
      backgroundColor: colors_name.colorPrimary,
      message: message,
      messageText: Text(message, style: TextStyle(color: Colors.white, fontSize: 12.sp)),
      duration: Duration(seconds: second),
    ).show(context);
  }

  static String? getHubId(String? hubId) {
    final hubList = PreferenceUtils.getHubList();
    for (int i = 0; i < hubList.records!.length; i++) {
      if (hubList.records![i].fields!.hubId == hubId) {
        return hubList.records![i].id;
      }
    }
    return hubId;
  }

  static String? getSpecializationId(String? specializationId) {
    final specializationList = PreferenceUtils.getSpecializationList();
    for (int i = 0; i < specializationList.records!.length; i++) {
      if (specializationList.records![i].fields!.specializationId == specializationId) {
        return specializationList.records![i].id;
      }
    }
    return specializationId;
  }

  static String? getRoleId(String? roleId) {
    final roleList = PreferenceUtils.getRoleList();
    for (int i = 0; i < roleList.records!.length; i++) {
      if (roleList.records![i].fields!.roleId == roleId) {
        return roleList.records![i].id;
      }
    }
    return roleId;
  }

  static String? getRoleName(String? roleId) {
    final roleList = PreferenceUtils.getRoleList();
    String? roleName;
    for (int i = 0; i < roleList.records!.length; i++) {
      if (roleList.records![i].fields!.roleId == roleId) {
        roleName = roleList.records![i].fields?.roleTitle!;
        break;
      }
    }
    return roleName;
  }
}

class DateFormate {
  // static String toFormate(int timeStamp,
  //     {String formate = "dd MMMM yyyy hh:mm a"}) {
  //   final f = new DateFormat(formate);
  //   return f.format(new DateTime.fromMillisecondsSinceEpoch(timeStamp ?? 0));
  // }

  // static String toFormate1(int timeStamp,
  //     {String formate = "dd  / MM  / yyyy  hh:mm a"}) {
  //   final f = new DateFormat(formate);
  //   return f.format(new DateTime.fromMillisecondsSinceEpoch(timeStamp ?? 0));
  // }

  // static String toFormate2(int timeStamp,
  //     {String formate = "dd  / MM  / yyyy  hh:mm a"}) {
  //   final f = new DateFormat(formate);
  //   return f.format(new DateTime.fromMillisecondsSinceEpoch(timeStamp ?? 0));
  // }

  // DateTime convertTimeStampToDateTime(int timeStamp) {
  //   var dateToTimeStamp = DateTime.fromMillisecondsSinceEpoch(timeStamp * 1000);
  //   return dateToTimeStamp;
  // }

  // String convertTimeStampToHumanDate(int timeStamp) {
  //   var dateToTimeStamp = DateTime.fromMillisecondsSinceEpoch(timeStamp * 1000);
  //   return DateFormat('dd MMMM yyyy hh:mm a').format(dateToTimeStamp);
  // }

  // String convertTimeStampToHumanHour(int timeStamp) {
  //   var dateToTimeStamp = DateTime.fromMillisecondsSinceEpoch(timeStamp * 1000);
  //   return DateFormat('HH:mm').format(dateToTimeStamp);
  // }
}
