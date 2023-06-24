import 'dart:io';

import 'package:com_sandeepgtm_sycamore_mobile/utils/color_schemes.g.dart';
import 'package:com_sandeepgtm_sycamore_mobile/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:com_sandeepgtm_sycamore_mobile/models/app_data.dart';
import 'package:com_sandeepgtm_sycamore_mobile/views/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppData(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: appName,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: lightColorScheme,
          textTheme: GoogleFonts.interTightTextTheme(),
          pageTransitionsTheme: const PageTransitionsTheme(builders: {
            TargetPlatform.iOS: FadeUpwardsPageTransitionsBuilder(),
            TargetPlatform.android: FadeUpwardsPageTransitionsBuilder()
          }),
        ),
        // darkTheme: ThemeData(
        //   useMaterial3: true,
        //   colorScheme: darkColorScheme,
        //   textTheme: GoogleFonts.interTextTheme(),
        //   pageTransitionsTheme: const PageTransitionsTheme(builders: {
        //     TargetPlatform.iOS: FadeUpwardsPageTransitionsBuilder(),
        //     TargetPlatform.android: FadeUpwardsPageTransitionsBuilder()
        //   }),
        // ),
        home: const SplashScreen(),
      ),
    );
  }
}
