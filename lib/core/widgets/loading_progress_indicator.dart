import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mishkat_almasabih/core/theming/colors.dart';

loadingProgressIndicator() {
  return Center(child: SpinKitSpinningLines(

    color: ColorsManager.primaryGreen, size: 50.0.sp));
}
