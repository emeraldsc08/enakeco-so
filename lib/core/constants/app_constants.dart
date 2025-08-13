class AppConstants {
  // App Info
  static const String appName = 'EnakEco SO';
  static const String appVersion = '1.0.0';

  // Colors
  static const int primaryRed = 0xFFE53E3E;
  static const int secondaryRed = 0xFFC53030;
  static const int lightRed = 0xFFFED7D7;
  static const int white = 0xFFFFFFFF;
  static const int lightGray = 0xFFF7FAFC;
  static const int gray = 0xFFE2E8F0;
  static const int darkGray = 0xFF4A5568;
  static const int black = 0xFF1A202C;

  // Dimensions
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double paddingXLarge = 32.0;

  static const double radiusSmall = 4.0;
  static const double radiusMedium = 8.0;
  static const double radiusLarge = 12.0;
  static const double radiusXLarge = 16.0;

  // Font Sizes
  static const double fontSizeSmall = 12.0;
  static const double fontSizeMedium = 14.0;
  static const double fontSizeLarge = 16.0;
  static const double fontSizeXLarge = 18.0;
  static const double fontSizeXXLarge = 20.0;
  static const double fontSizeTitle = 24.0;

  // Animation Durations
  static const Duration animationFast = Duration(milliseconds: 200);
  static const Duration animationMedium = Duration(milliseconds: 300);
  static const Duration animationSlow = Duration(milliseconds: 500);

  // API Endpoints
  static const String stockListBaseUrl = 'https://dev.swalayanenakeco.com/api/stock/list';
}