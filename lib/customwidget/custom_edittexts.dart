// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
//
// import '../values/app_colors.dart';
// import '../values/text_styles.dart';
//
// // ignore: must_be_immutable
// class CustomEditText extends StatefulWidget {
//   final bool enabled;
//
//   final bool readOnly;
//   final String labelText;
//   final String hintText;
//   final Color color;
//   final double topValue;
//   final Alignment alignment;
//   final TextInputType type;
//   final TextInputAction textInputAction;
//   bool obscure;
//   final TextEditingController controller;
//   final double size;
//   final FontWeight fontWeight;
//   final int maxLength;
//   final int maxLines;
//   // final FocusNode focusNode;
//   final int minLines;
//   final bool isPassword;
//   final bool isIconNeed;
//   String prefixIcon;
//   final Function(String)? onChanges;
//   final bool isEmailVerified;
//   final TextAlign align;
//
//   CustomEditText({
//     super.key,
//     this.align = TextAlign.start,
//     this.onChanges,
//     this.labelText = "",
//     this.hintText = "",
//     this.color = Colors.black,
//     this.alignment = Alignment.topLeft,
//     this.topValue = 10.0,
//     // this.focusNode = null,
//     required this.type,
//     required this.textInputAction,
//     this.obscure = false,
//     required this.controller,
//     this.size = 18,
//     this.enabled = true,
//     this.readOnly = false,
//     this.isPassword = false,
//     this.isIconNeed = true,
//     this.maxLength = 50,
//     this.maxLines = 1,
//     this.minLines = 1,
//     this.fontWeight = FontWeight.w700,
//     this.isEmailVerified = false,
//     this.prefixIcon = "",
//   });
//
//   @override
//   State<CustomEditText> createState() => _CustomState();
// }
//
// class _CustomState extends State<CustomEditText> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: EdgeInsets.only(left: 0, right: 0, top: widget.topValue),
//       alignment: widget.alignment,
//       child: TextFormField(
//         keyboardType: widget.type,
//         textInputAction: widget.textInputAction,
//         obscureText: widget.obscure,
//         controller: widget.controller,
//         enabled: widget.enabled,
//         readOnly: widget.readOnly,
//         //focusNode: null,
//         maxLines: widget.maxLines,
//         textAlign: widget.align,
//         cursorColor: AppColors.colorBlackLight,
//         inputFormatters: [
//           LengthLimitingTextInputFormatter(widget.maxLength), // for mobile
//         ],
//         onChanged: widget.onChanges,
//         minLines: widget.minLines,
//         style: textStyleEditText,
//         decoration: InputDecoration(
//                 filled: true,
//             fillColor: AppColors.lightGray,
//             suffixIcon: widget.isPassword
//                 ? InkWell(
//               child:Icon(
//                 widget.obscure ? Icons.visibility : Icons.visibility_off,
//                 color: AppColors.textColorGreyLight,
//               ) ,
//               onTap: () {
//                 setState(() {
//                   widget.obscure = !widget.obscure;
//                 });
//               },
//             )
//                 : widget.isEmailVerified
//                 ? InkWell(
//               child: const Icon(
//                 Icons.check_circle,
//                 color: AppColors.colorGreen,
//               ),
//               onTap: () {},
//             )
//                 : null,
//             border: const OutlineInputBorder(),
//             enabledBorder: const OutlineInputBorder(
//                 borderSide: BorderSide(color: AppColors.lightGray, width: 1.5),
//                 borderRadius: BorderRadius.all(Radius.circular(10))),
//             focusedBorder: const OutlineInputBorder(
//               borderSide:
//                   BorderSide(color: AppColors.textColorGreyLight, width: 1.5),
//             ),
//             prefixIcon: widget.isIconNeed ? IconButton(onPressed: () {}, icon: Image.asset(widget.prefixIcon)) : null,
//             labelText: widget.labelText,
//             hintText: widget.hintText,
//             hintStyle: textStyleHint,
//             labelStyle: TextStyle(
//                 color: widget.color,
//                 fontSize: widget.size,
//                 fontWeight: widget.fontWeight),
//             floatingLabelBehavior: FloatingLabelBehavior.always),
//       ),
//     );
//   }
// }
