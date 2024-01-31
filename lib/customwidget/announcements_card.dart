import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';

import '../../values/text_styles.dart';
import '../models/announcement_response.dart';
import '../models/base_api_response.dart';

class AnnouncementsCard extends StatelessWidget {
  AnnouncementsCard({super.key, required this.data, this.margin, required this.onTap, this.onEdit, this.height});

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
        child: SizedBox(
          height: height ?? (kIsWeb ? MediaQuery.of(context).size.height * 0.35 : 200.h),
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20.r),
                child: CachedNetworkImage(
                  imageUrl: data.fields?.image ?? '',
                  fit: BoxFit.fill,
                  width: 1.sw,
                  height: height ?? (kIsWeb ? MediaQuery.of(context).size.height * 0.35 : 200.h),
                  errorWidget: (context, url, error) => const Center(child: Icon(Icons.error)),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.r),
                  color: colors_name.colorBlack.withOpacity(0.4),
                ),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 12.w, bottom: 12.h, right: 12.w),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data.fields?.title ?? '',
                        style: titleStyleWhite,
                        maxLines: 2,
                      ),
                      SizedBox(height: 4.h),
                      Visibility(
                        visible: false,
                        child: Text(
                          data.fields?.description ?? '',
                          style: textStyleLightWhite,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: onEdit != null,
                child: Positioned(
                  top: 10.h,
                  right: 10.h,
                  child: GestureDetector(
                    onTap: onEdit,
                    child: Container(
                      height: 32.h,
                      width: 32.h,
                      decoration: BoxDecoration(
                        color: colors_name.colorWhite.withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.edit_outlined,
                        color: colors_name.colorWhite,
                      ),
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
