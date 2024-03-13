import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

import '../values/app_images.dart';

class ImageDialog extends StatefulWidget {
  final String image;

  const ImageDialog({super.key, required this.image});

  @override
  ImageDialogState createState() => ImageDialogState();
}

class ImageDialogState extends State<ImageDialog> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          child: Container(padding: const EdgeInsets.all(15)),
        ),
        titleSpacing: 0,
        centerTitle: false,
        backgroundColor: Colors.black54,
        elevation: 0.0,
        actions: <Widget>[
          GestureDetector(
              child: Padding(
                padding: const EdgeInsets.only(right: 15, top: 0),
                child: AppImage.loadSVG("", height: 30, width: 30),
              ),
              onTap: () {
                Navigator.pop(context, true);
              }),
        ],
      ),
      resizeToAvoidBottomInset: true,
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black54,
      body: Container(
          color: Colors.black12,
          width: double.infinity,
          height: double.infinity,
          child: PhotoView(imageProvider: CachedNetworkImageProvider(widget.image))),
    );
  }
}
