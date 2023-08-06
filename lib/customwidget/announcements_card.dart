import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../values/text_styles.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';

import '../models/announcement_response.dart';
import '../models/base_api_response.dart';

class AnnouncementsCard extends StatelessWidget {
  AnnouncementsCard(
      {super.key,
      required this.data,
      this.margin,
      required this.onTap,
      this.onEdit,
      this.height
      });

  final BaseApiResponseWithSerializable<AnnouncementResponse> data;
  final EdgeInsetsGeometry? margin;
  final VoidCallback onTap;
  VoidCallback? onEdit;
  double? height;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: margin ?? EdgeInsets.zero,
        // padding: EdgeInsets.zero,
        // margin: margin,
        child: Container(
          // margin: margin,
          height: height??180.h,
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: CachedNetworkImage(
                  imageUrl: data.fields?.image??'',
                  fit: BoxFit.cover,
                  width: 1.sw,
                  height: height==null?200.h:height!+10.h,
                  errorWidget: (context, url, error) =>
                      const Center(child: Icon(Icons.error)),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: colors_name.colorBlack.withOpacity(0.4),
                ),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 16.0, bottom: 16.0, right: 16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data.fields?.title??'',
                        style: titleStyleWhite,
                      ),
                      SizedBox(
                        height: 4.h,
                      ),
                      Text(
                        data.fields?.description??'',
                        style: textStyleLightWhite,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: onEdit!=null,
                child: Positioned(
                  top: 10,
                  right: 10,
                  child: GestureDetector(
                    onTap: onEdit,
                    child: Container(
                      height: 32.h,
                      width: 32.h,
                      decoration: BoxDecoration(
                        color: colors_name.colorWhite.withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.edit_outlined,color: colors_name.colorWhite,),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
