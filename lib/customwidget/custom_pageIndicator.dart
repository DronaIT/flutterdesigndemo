import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class CustomPageIndicator extends StatelessWidget {
  final int totalItems;
  final int visibleIndicators;
  final int currentPage;

  const CustomPageIndicator({super.key,
    required this.totalItems,
    this.visibleIndicators = 5,
    required this.currentPage,
  });

  @override
  Widget build(BuildContext context) {
    int startIndex = (currentPage ~/ visibleIndicators) * visibleIndicators;
    int endIndex = (startIndex + visibleIndicators).clamp(0, totalItems - 1);

    List<Widget> indicators = [];
    for (int i = startIndex; i < endIndex; i++) {
      indicators.add(
        Container(
          width: 6.h,
          height: 6.h,
          margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: i == currentPage ? colors_name.darkGrayColor : colors_name.lightGrayColor,
          ),
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: indicators,
    );
  }
}



class CustomPageIndicatorScrolling extends StatelessWidget {
  final int totalItems;
  final PageController controller;
  const CustomPageIndicatorScrolling({super.key, required this.totalItems, required this.controller});

  @override
  Widget build(BuildContext context) {
    return
    SmoothPageIndicator(
        controller: controller,
        count: totalItems,
        effect: ScrollingDotsEffect(
          activeStrokeWidth: 2.6,
          activeDotScale: 1.3,
          maxVisibleDots: 5,
          radius: 8,
          spacing: 10,
          dotHeight: 6.h,
          dotWidth: 6.h,
          activeDotColor: colors_name.darkGrayColor,
          dotColor: colors_name.lightGrayColor,
        ));
  }
}
