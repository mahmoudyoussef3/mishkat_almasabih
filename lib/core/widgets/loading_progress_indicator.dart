import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mishkat_almasabih/core/theming/colors.dart';

loadingProgressIndicator({Color color = ColorsManager.primaryGreen,double size = 50.0}) {
  return Center(
    child: SpinKitSpinningLines(
      color: color,
      size: size.sp,
    ),
  );
}
