import 'package:flutter/material.dart';

class MHColors {

  // Main app menu colors
  static final appThemeColor = createMaterialColor(const Color (0xffaee1e1));
  static final menuBGColor = createMaterialColor(const Color(0xffcdf3f5));
  static final menuButtonColor = createMaterialColor(const Color(0xffade0e0));
  static final menuButtonTextColor = createMaterialColor(const Color(0xFF427A87));
  static final menuButtonShadowColor = createMaterialColor(const Color(
      0xFF427187));

  // Breathe colors
  static final breatheTextTwo = createMaterialColor(const Color (0xFF261863));

  // Journal Colors
  static final journalsPassFocusColor = createMaterialColor(const Color(0xff23dcaa));
  static final journalCursorColor = createMaterialColor(const Color(0xFF293553));

  // Helpline Colors
  static final helplineTextColor = createMaterialColor(const Color(0xFF8A76FC));
  static final helplineLinkColor = createMaterialColor(const Color(0xFF16765E));

  // Mood Tracker Colors
  static final trackerLineColor = createMaterialColor(const Color(0xFF20C298));
  static final selectorActiveColor = createMaterialColor(const Color(0xFF7856C7));
  static final selectorInactiveColor = createMaterialColor(const Color(0xFFAFA4DE));
  static final trackerMenuTextDisabled = createMaterialColor(const Color(
      0xFF686868));
  static final trackerMenuButtonDisabled = createMaterialColor(const Color(
      0xFFE0E0E0));
  static final trackerMenuShadowDisabled = createMaterialColor(const Color(
      0xFF767676));

  /// Creates a material color swatch from the [color].
  /// https://gist.github.com/filipvk/244be04f1dbdba52788017f008477484
  static MaterialColor createMaterialColor(Color color) {
    List strengths = <double>[.05];
    final swatch = <int, Color>{};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    for (var strength in strengths) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }
    return MaterialColor(color.value, swatch);
  }
}