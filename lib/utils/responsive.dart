


import 'dart:math';
import 'package:flutter/material.dart';

class ScreenSize {
  static late MediaQueryData _mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;
  static late double blockSizeHorizontal;
  static late double blockSizeVertical;
  static late Orientation orientation;
  static late double pixelRatio;
  static late double textScaleFactor;
  static late EdgeInsets viewPadding;
  static late EdgeInsets padding;
  static late double devicePixelRatio;
  static late double statusBarHeight;
  static late double bottomBarHeight;

  static void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    orientation = _mediaQueryData.orientation;
    pixelRatio = _mediaQueryData.devicePixelRatio;
    textScaleFactor = _mediaQueryData.textScaleFactor;
    viewPadding = _mediaQueryData.viewPadding;
    padding = _mediaQueryData.padding;
    devicePixelRatio = _mediaQueryData.devicePixelRatio;
    statusBarHeight = _mediaQueryData.padding.top;
    bottomBarHeight = _mediaQueryData.padding.bottom;
    
    // Divide screen into 100 blocks horizontally and vertically
    blockSizeHorizontal = screenWidth / 100;
    blockSizeVertical = screenHeight / 100;
  }
}

class Responsive extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget desktop;
  final Widget? watch;
  final Widget? ultraWide;

  const Responsive({
    super.key,
    required this.mobile,
    this.tablet,
    required this.desktop,
    this.watch,
    this.ultraWide,
  });

  // Screen size breakpoints with more flexibility
  static bool isWatch(BuildContext context) =>
      MediaQuery.of(context).size.width < 300;

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width >= 300 &&
      MediaQuery.of(context).size.width < 600;

  static bool isSmallTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= 600 &&
      MediaQuery.of(context).size.width < 768;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= 768 &&
      MediaQuery.of(context).size.width < 1024;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1024 &&
      MediaQuery.of(context).size.width < 1440;

  static bool isUltraWide(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1440;

  // Orientation helpers
  static bool isPortrait(BuildContext context) =>
      MediaQuery.of(context).orientation == Orientation.portrait;

  static bool isLandscape(BuildContext context) =>
      MediaQuery.of(context).orientation == Orientation.landscape;

  // Screen diagonal in inches (approximate)
  static double screenSizeInches(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final size = mediaQuery.size;
    final diagonal = sqrt(
      (size.width * size.width) + (size.height * size.height),
    );
    return diagonal / mediaQuery.devicePixelRatio / 160;
  }

  // Responsive sizing utilities with more options
  static double width(double percent, BuildContext context) {
    ScreenSize.init(context);
    return ScreenSize.blockSizeHorizontal * percent;
  }

  static double height(double percent, BuildContext context) {
    ScreenSize.init(context);
    return ScreenSize.blockSizeVertical * percent;
  }

  static double fontSize(double size, BuildContext context) {
    ScreenSize.init(context);
    // More sophisticated text scaling
    final scaleFactor = _getTextScaleFactor(context);
    return size * scaleFactor;
  }

  static double _getTextScaleFactor(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final width = mediaQuery.size.width;
    final height = mediaQuery.size.height;
    final diagonal = sqrt(width * width + height * height);
    
    // Base scaling on screen diagonal
    final baseScale = diagonal / 1000;
    
    // Adjust for text scale factor preference
    return baseScale * mediaQuery.textScaleFactor.clamp(0.8, 1.5);
  }

  static EdgeInsets symmetricPadding({
    double horizontal = 0,
    double vertical = 0,
    required BuildContext context,
  }) {
    return EdgeInsets.symmetric(
      horizontal: width(horizontal, context),
      vertical: height(vertical, context),
    );
  }

  static EdgeInsets allPadding(double value, BuildContext context) {
    return EdgeInsets.all(width(value, context));
  }

  static EdgeInsets fromLTRB({
    double left = 0,
    double top = 0,
    double right = 0,
    double bottom = 0,
    required BuildContext context,
  }) {
    return EdgeInsets.fromLTRB(
      width(left, context),
      height(top, context),
      width(right, context),
      height(bottom, context),
    );
  }

  static SizedBox verticalSpace(double height, BuildContext context) {
    return SizedBox(height: Responsive.height(height, context));
  }

  static SizedBox horizontalSpace(double width, BuildContext context) {
    return SizedBox(width: Responsive.width(width, context));
  }

  static BorderRadius borderRadius(double radius, BuildContext context) {
    return BorderRadius.all(
      Radius.circular(width(radius, context)),
    );
  }

  @override
  Widget build(BuildContext context) {
    ScreenSize.init(context);
    final size = MediaQuery.of(context).size;
    
    // Check for ultra-wide screens first
    if (size.width >= 1440 && ultraWide != null) {
      return ultraWide!;
    }
    // Desktop layout
    if (size.width >= 1024) {
      return desktop;
    }
    // Tablet layout
    else if (size.width >= 768 && tablet != null) {
      return tablet!;
    }
    // Small tablet layout (fall back to mobile if no tablet widget provided)
    else if (size.width >= 600 && tablet != null) {
      return tablet!;
    }
    // Watch layout
    else if (size.width < 300 && watch != null) {
      return watch!;
    }
    // Mobile layout (default)
    else {
      return mobile;
    }
  }
}