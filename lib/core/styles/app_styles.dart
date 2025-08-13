import 'package:flutter/material.dart';

import '../constants/app_constants.dart';

class AppStyles {
  // Common Container Styles
  static BoxDecoration get cardDecoration => BoxDecoration(
    color: const Color(AppConstants.white),
    borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
    boxShadow: [
      BoxShadow(
        color: const Color(AppConstants.black).withOpacity(0.05),
        blurRadius: 10,
        offset: const Offset(0, 2),
      ),
    ],
  );

  static BoxDecoration get elevatedCardDecoration => BoxDecoration(
    color: const Color(AppConstants.white),
    borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
    boxShadow: [
      BoxShadow(
        color: const Color(AppConstants.black).withOpacity(0.1),
        blurRadius: 15,
        offset: const Offset(0, 4),
      ),
    ],
  );

  // Button Styles
  static ButtonStyle get primaryButtonStyle => ElevatedButton.styleFrom(
    backgroundColor: const Color(AppConstants.primaryRed),
    foregroundColor: const Color(AppConstants.white),
    elevation: 0,
    shadowColor: Colors.transparent,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
    ),
    padding: const EdgeInsets.symmetric(
      horizontal: AppConstants.paddingLarge,
      vertical: AppConstants.paddingMedium,
    ),
    textStyle: const TextStyle(
      fontSize: AppConstants.fontSizeLarge,
      fontWeight: FontWeight.w600,
    ),
  );

  static ButtonStyle get secondaryButtonStyle => OutlinedButton.styleFrom(
    foregroundColor: const Color(AppConstants.primaryRed),
    side: const BorderSide(
      color: Color(AppConstants.primaryRed),
      width: 1.5,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
    ),
    padding: const EdgeInsets.symmetric(
      horizontal: AppConstants.paddingLarge,
      vertical: AppConstants.paddingMedium,
    ),
    textStyle: const TextStyle(
      fontSize: AppConstants.fontSizeLarge,
      fontWeight: FontWeight.w600,
    ),
  );

  static ButtonStyle get textButtonStyle => TextButton.styleFrom(
    foregroundColor: const Color(AppConstants.primaryRed),
    textStyle: const TextStyle(
      fontSize: AppConstants.fontSizeLarge,
      fontWeight: FontWeight.w600,
    ),
  );

  // Input Styles
  static InputDecoration get inputDecoration => InputDecoration(
    filled: true,
    fillColor: const Color(AppConstants.lightGray),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
      borderSide: const BorderSide(
        color: Color(AppConstants.primaryRed),
        width: 2,
      ),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
      borderSide: const BorderSide(
        color: Color(AppConstants.primaryRed),
        width: 2,
      ),
    ),
    contentPadding: const EdgeInsets.symmetric(
      horizontal: AppConstants.paddingMedium,
      vertical: AppConstants.paddingMedium,
    ),
    hintStyle: TextStyle(
      color: const Color(AppConstants.darkGray).withOpacity(0.6),
      fontSize: AppConstants.fontSizeMedium,
    ),
  );

  // Text Styles
  static const TextStyle headingStyle = TextStyle(
    fontSize: AppConstants.fontSizeTitle,
    fontWeight: FontWeight.w700,
    color: Color(AppConstants.black),
  );

  static const TextStyle subheadingStyle = TextStyle(
    fontSize: AppConstants.fontSizeXXLarge,
    fontWeight: FontWeight.w600,
    color: Color(AppConstants.black),
  );

  static const TextStyle bodyStyle = TextStyle(
    fontSize: AppConstants.fontSizeLarge,
    fontWeight: FontWeight.w400,
    color: Color(AppConstants.black),
  );

  static const TextStyle captionStyle = TextStyle(
    fontSize: AppConstants.fontSizeMedium,
    fontWeight: FontWeight.w400,
    color: Color(AppConstants.darkGray),
  );

  static const TextStyle buttonTextStyle = TextStyle(
    fontSize: AppConstants.fontSizeLarge,
    fontWeight: FontWeight.w600,
    color: Color(AppConstants.white),
  );

  // Spacing
  static const EdgeInsets paddingSmall = EdgeInsets.all(AppConstants.paddingSmall);
  static const EdgeInsets paddingMedium = EdgeInsets.all(AppConstants.paddingMedium);
  static const EdgeInsets paddingLarge = EdgeInsets.all(AppConstants.paddingLarge);
  static const EdgeInsets paddingXLarge = EdgeInsets.all(AppConstants.paddingXLarge);

  static const EdgeInsets paddingHorizontalSmall = EdgeInsets.symmetric(horizontal: AppConstants.paddingSmall);
  static const EdgeInsets paddingHorizontalMedium = EdgeInsets.symmetric(horizontal: AppConstants.paddingMedium);
  static const EdgeInsets paddingHorizontalLarge = EdgeInsets.symmetric(horizontal: AppConstants.paddingLarge);

  static const EdgeInsets paddingVerticalSmall = EdgeInsets.symmetric(vertical: AppConstants.paddingSmall);
  static const EdgeInsets paddingVerticalMedium = EdgeInsets.symmetric(vertical: AppConstants.paddingMedium);
  static const EdgeInsets paddingVerticalLarge = EdgeInsets.symmetric(vertical: AppConstants.paddingLarge);
}