import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'colors.dart';

class MyTheme {
  static final myTheme = ThemeData(
    fontFamily: 'Pretendard',
    primaryColor: MyColor.primary,
    scaffoldBackgroundColor: MyColor.white,
    // splashFactory: InkRipple.splashFactory,
    // splashColor: Colors.transparent,
    // highlightColor: Colors.transparent,
    appBarTheme: const AppBarTheme(
      surfaceTintColor: Colors.transparent,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      toolbarHeight: 44,
      elevation: 0,
    ),
  );
}
