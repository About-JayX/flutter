import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

class ThemeHelper {
  static const Color primaryColor = Color.fromRGBO(255, 149, 149, 1);

  static ThemeData get lightTheme {
    ThemeData theme = FlexThemeData.light(
      colors: const FlexSchemeColor(
        primary: primaryColor,
        primaryContainer: primaryColor,
        secondary: Color(0xFFBE3BE3),
        secondaryContainer: Color(0xFFBE3BE3),
        tertiary: Color(0xFFC87A98),
        tertiaryContainer: Color.fromARGB(255, 104, 33, 81),
        appBarColor: primaryColor,
        error: primaryColor,
      ),
      fontFamily: 'MiSansVF',
      subThemesData: const FlexSubThemesData(
        interactionEffects: false,
        tintedDisabledControls: false,
        useTextTheme: true,
        inputDecoratorBorderType: FlexInputBorderType.underline,
        inputDecoratorUnfocusedBorderIsColored: false,
        alignedDropdown: true,
        tooltipRadius: 4,
        tooltipSchemeColor: SchemeColor.inverseSurface,
        tooltipOpacity: 0.9,
        useInputDecoratorThemeInDialogs: true,
        snackBarElevation: 6,
        snackBarBackgroundSchemeColor: SchemeColor.inverseSurface,
        navigationBarSelectedLabelSchemeColor: SchemeColor.onSurface,
        navigationBarUnselectedLabelSchemeColor: SchemeColor.onSurface,
        navigationBarMutedUnselectedLabel: false,
        navigationBarSelectedIconSchemeColor: SchemeColor.onSurface,
        navigationBarUnselectedIconSchemeColor: SchemeColor.onSurface,
        navigationBarMutedUnselectedIcon: false,
        navigationBarIndicatorSchemeColor: SchemeColor.secondaryContainer,
        navigationBarIndicatorOpacity: 1.00,
        navigationRailSelectedLabelSchemeColor: SchemeColor.onSurface,
        navigationRailUnselectedLabelSchemeColor: SchemeColor.onSurface,
        navigationRailMutedUnselectedLabel: false,
        navigationRailSelectedIconSchemeColor: SchemeColor.onSurface,
        navigationRailUnselectedIconSchemeColor: SchemeColor.onSurface,
        navigationRailMutedUnselectedIcon: false,
        navigationRailIndicatorSchemeColor: SchemeColor.secondaryContainer,
        navigationRailIndicatorOpacity: 1.00,
        navigationRailBackgroundSchemeColor: SchemeColor.surface,
        navigationRailLabelType: NavigationRailLabelType.none,
      ),
      visualDensity: FlexColorScheme.comfortablePlatformDensity,
      useMaterial3: true,
      swapLegacyOnMaterial3: true,
    );
    theme = theme.copyWith(
        cardTheme: theme.cardTheme
            .copyWith(color: const Color.fromARGB(25, 255, 255, 255)));
    return theme;
  }

  static ThemeData get darkTheme {
    ThemeData theme = FlexThemeData.dark(
      colors: const FlexSchemeColor(
        primary: primaryColor,
        primaryContainer: primaryColor,
        secondary: Color(0xFFBE3BE3),
        secondaryContainer: Color(0xFFBE3BE3),
        tertiary: Color(0xFFC87A98),
        tertiaryContainer: Color.fromARGB(255, 104, 33, 81),
        appBarColor: primaryColor,
        error: primaryColor,
      ),
      fontFamily: 'MiSansVF',
      subThemesData: const FlexSubThemesData(
        interactionEffects: false,
        tintedDisabledControls: false,
        useTextTheme: true,
        inputDecoratorBorderType: FlexInputBorderType.underline,
        inputDecoratorUnfocusedBorderIsColored: false,
        alignedDropdown: true,
        tooltipRadius: 4,
        tooltipSchemeColor: SchemeColor.inverseSurface,
        tooltipOpacity: 0.9,
        useInputDecoratorThemeInDialogs: true,
        snackBarElevation: 6,
        snackBarBackgroundSchemeColor: SchemeColor.inverseSurface,
        navigationBarSelectedLabelSchemeColor: SchemeColor.onSurface,
        navigationBarUnselectedLabelSchemeColor: SchemeColor.onSurface,
        navigationBarMutedUnselectedLabel: false,
        navigationBarSelectedIconSchemeColor: SchemeColor.onSurface,
        navigationBarUnselectedIconSchemeColor: SchemeColor.onSurface,
        navigationBarMutedUnselectedIcon: false,
        navigationBarIndicatorSchemeColor: SchemeColor.secondaryContainer,
        navigationBarIndicatorOpacity: 1.00,
        navigationRailSelectedLabelSchemeColor: SchemeColor.onSurface,
        navigationRailUnselectedLabelSchemeColor: SchemeColor.onSurface,
        navigationRailMutedUnselectedLabel: false,
        navigationRailSelectedIconSchemeColor: SchemeColor.onSurface,
        navigationRailUnselectedIconSchemeColor: SchemeColor.onSurface,
        navigationRailMutedUnselectedIcon: false,
        navigationRailIndicatorSchemeColor: SchemeColor.secondaryContainer,
        navigationRailIndicatorOpacity: 1.00,
        navigationRailBackgroundSchemeColor: SchemeColor.surface,
        navigationRailLabelType: NavigationRailLabelType.none,
      ),
      visualDensity: FlexColorScheme.comfortablePlatformDensity,
      useMaterial3: true,
      swapLegacyOnMaterial3: true,
    );
    theme = theme.copyWith(
        cardTheme: theme.cardTheme
            .copyWith(color: const Color.fromARGB(25, 255, 255, 255)));
    return theme;
  }
}
