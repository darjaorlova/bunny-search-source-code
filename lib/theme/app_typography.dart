import 'package:bunny_search/theme/app_colors.dart';
import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTypography {
  static final regular = TextStyle(
      fontSize: 16,
      color: AppColors.textBlue,
      fontFamily: 'Inter',
      letterSpacing: -0.37);

  static final medium = TextStyle(
      fontSize: 16,
      color: AppColors.textBlue,
      fontWeight: FontWeight.w500,
      fontFamily: 'Inter',
      letterSpacing: -0.17);

  static final header = TextStyle(
      fontSize: 22,
      color: AppColors.textBlue,
      fontFamily: 'Inter',
      fontWeight: FontWeight.w500,
      height: 1.3,
      letterSpacing: -0.97);

  static final headerMedium = TextStyle(
      fontSize: 18,
      color: AppColors.textBlue,
      fontFamily: 'Inter',
      fontWeight: FontWeight.w500,
      letterSpacing: -0.17);

  static final h4 = TextStyle(
      fontSize: 16,
      color: AppColors.accentBlack,
      fontFamily: 'Inter',
      fontWeight: FontWeight.w500,
      letterSpacing: -0.3);

  static final label = TextStyle(
      fontSize: 14,
      color: AppColors.rose,
      fontFamily: 'Inter',
      fontWeight: FontWeight.w500,
      letterSpacing: -0.47);

  static final labelDark = TextStyle(
      fontSize: 14,
      color: AppColors.textBlue,
      fontFamily: 'Inter',
      fontWeight: FontWeight.w500,
      letterSpacing: -0.37);

  static final labelInactive = TextStyle(
      fontSize: 14,
      color: AppColors.inactive,
      fontFamily: 'Inter',
      fontWeight: FontWeight.w500,
      letterSpacing: -0.37);

  static final caption = TextStyle(
      fontSize: 12,
      color: AppColors.inactive,
      fontWeight: FontWeight.w400,
      fontFamily: 'Inter',
      letterSpacing: 0.17);

  static final title = TextStyle(
      fontSize: 26,
      color: AppColors.textBlue,
      fontFamily: 'Inter',
      fontWeight: FontWeight.w500,
      letterSpacing: -0.47,
      height: 1.26);

  static final description = TextStyle(
      fontSize: 14,
      color: AppColors.textBlue,
      fontFamily: 'Inter',
      fontWeight: FontWeight.w400,
      letterSpacing: -0.17,
      height: 1.42);
}
