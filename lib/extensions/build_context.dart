import 'dart:ui';

import 'package:flutter/widgets.dart';

extension BuildContextColor on BuildContext {
  Color dynamicPaintColor({
    required final Color lightThemeColor,
    required final Color darkThemeColor}) {
    final brightness = MediaQuery.of(this).platformBrightness;
    switch (brightness) {
      case Brightness.dark:
        return darkThemeColor;
      case Brightness.light:
        return lightThemeColor;
    }
  }
}