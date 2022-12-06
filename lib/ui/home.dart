import 'package:flutter/material.dart';
import 'package:flutterdesigndemo/customwidget/custom_text.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            custom_text(text: "Welcome to Home,"),
            // ListView.builder(
            //   itemCount: 8,
            //   scrollDirection: Axis.vertical,
            //   shrinkWrap: true,
            //   itemBuilder: (context, i) => Text("Module"),
            // )
          ],
        ),
      ),
    );
  }
}
