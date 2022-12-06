// import 'package:dart_airtable/dart_airtable.dart';
// import 'package:flutterdesigndemo/values/strings_name.dart';
// import 'package:flutter/material.dart';
//
// import 'customwidget/custom_app_bar.dart';
// import 'customwidget/custom_edittext.dart';
// import 'customwidget/custom_text.dart';
//
// //https://support.airtable.com/docs/api-record-limits
// //https://stackoverflow.com/questions/64303099/how-to-read-and-write-data-in-airtable-with-flutter
// //https://github.com/deriegle/dart-airtable
//
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: const MyHomePage(),
//     );
//   }
// }
//
// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key});
//
//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   TextEditingController emailController = TextEditingController();
//   TextEditingController passController = TextEditingController();
//   List<AirtableRecordField> records = [];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: CustomAppBar(
//         appBarTitleText: "Login",
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             custom_text(
//               text: strings_name.str_phone,
//               size: 16,
//               fontWeight: FontWeight.w600,
//             ),
//             custom_edittext(
//               hintText: strings_name.str_hint_email,
//               type: TextInputType.emailAddress,
//               textInputAction: TextInputAction.next,
//               controller: emailController,
//             ),
//             custom_text(
//                 text: strings_name.str_password,
//                 size: 16,
//                 fontWeight: FontWeight.w600),
//             custom_edittext(
//               hintText: strings_name.str_hint_password,
//               type: TextInputType.visiblePassword,
//               textInputAction: TextInputAction.done,
//               obscure: true,
//               controller: passController,
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () async {
//           print(
//               "email-password ${emailController.text.toString()}==> ${passController.text.toString()}");
//           //https://api.airtable.com/v0/appedmI7PL2dHBtmJ/Login?api_key=keyZWEKLzxuhEnMVb
//           var airtable = Airtable(
//               apiKey: "keyZWEKLzxuhEnMVb", projectBase: "appedmI7PL2dHBtmJ");
//
//           // var records = await airtable.getAllRecords("Login");
//           // print("test==>${records}");
//
//           //insert record in table
//
//           records.add(AirtableRecordField(
//               fieldName: "Email", value: emailController.text.toString()));
//           records.add(AirtableRecordField(
//               fieldName: "password", value: passController.text.toString()));
//           // print("record insert =>${records}");
//           var test = await airtable.createRecord(
//               "Login", AirtableRecord(fields: records));
//           print("record insert =>${test?.toJSON()} ==> ${test?.fields.length}");
//         },
//         child: const Icon(Icons.add),
//       ),
//     );
//   }
// }
