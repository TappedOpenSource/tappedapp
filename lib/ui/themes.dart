import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// const itlAccent = Color(0xff6200ee);
const tappedAccent = Color(0xff0086CC);

// const primaryColor = Colors.deepPurple;
const primaryColor = tappedAccent;
// const secondaryColor = Colors.deepPurple;
const secondaryColor = tappedAccent;
const backgroundLightColor = Color(0xfff8f6Fb);
const backgroundDarkColor = Color(0xff010F16);
const navigationBarLightColor = Color(0xfff8f6Fb);
const navigationBarDarkColor = Color(0xff010F16);

class Themes {
  static final themeLight = ThemeData.light().copyWith(
    textTheme: GoogleFonts.arimoTextTheme(
      ThemeData.light().textTheme,
    ),

    // selected color
    primaryColor: primaryColor,

    colorScheme: const ColorScheme.light().copyWith(
      primary: primaryColor,
      secondary: secondaryColor,
      background: backgroundLightColor,
    ),

    // floating action button
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
    ),

    // bottom bar
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: navigationBarLightColor,
      selectedItemColor: primaryColor,
      unselectedItemColor: Colors.black,
    ),
    // switch active color
    canvasColor: backgroundLightColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: backgroundLightColor,
      foregroundColor: Colors.black,
    ),

    tabBarTheme: const TabBarTheme(
      labelColor: Colors.black,
      unselectedLabelColor: Colors.black,
      indicatorColor: tappedAccent,
    ),

    sliderTheme: const SliderThemeData(
      activeTrackColor: tappedAccent,
      inactiveTrackColor: tappedAccent,
      thumbColor: tappedAccent,
      thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6),
      trackHeight: 2,
    ),
  );

  static final themeDark = ThemeData.dark().copyWith(
    textTheme: GoogleFonts.arimoTextTheme(
      ThemeData.dark().textTheme,
    ),

    // selected color
    primaryColor: primaryColor,
    colorScheme: const ColorScheme.dark().copyWith(
      primary: primaryColor,
      secondary: secondaryColor,
      background: backgroundDarkColor,
    ),
    // floating action button
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
    ),
    // bottom bar
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: navigationBarDarkColor,
      selectedItemColor: primaryColor,
      unselectedItemColor: Color(0xFF757575),
    ),
    // switch active color
    canvasColor: backgroundDarkColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: navigationBarDarkColor,
    ),

    tabBarTheme: const TabBarTheme(
      indicatorColor: tappedAccent,
      labelColor: Colors.white,
      unselectedLabelColor: Colors.white,
    ),

    sliderTheme: const SliderThemeData(
      activeTrackColor: tappedAccent,
      inactiveTrackColor: tappedAccent,
      thumbColor: tappedAccent,
      thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6),
      trackHeight: 2,
    ),
  );
}

extension ThemeUtil on BuildContext {
  ThemeData get theme => Theme.of(this);
}
