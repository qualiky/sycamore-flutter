import 'dart:async';

import 'package:com_sandeepgtm_sycamore_mobile/helpers/database_helper.dart';
import 'package:com_sandeepgtm_sycamore_mobile/helpers/network_helper.dart';
import 'package:com_sandeepgtm_sycamore_mobile/views/home_screen.dart';
import 'package:com_sandeepgtm_sycamore_mobile/views/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../utils/color_schemes.g.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late NetworkHelper networkHelper;
  late DatabaseHelper databaseHelper;
  late GlobalKey<ScaffoldMessengerState> globalKey;
  bool isConnected = false;
  bool redirectToHome = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    globalKey = GlobalKey<ScaffoldMessengerState>();
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      networkHelper = NetworkHelper(context);
      isConnected = await networkHelper.hasNetwork();

      if (isConnected) {
        print("Connected to internet!");
        redirectToHome = await networkHelper.hasValidSessionCookies();
      } else {
        if(!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No Internet Connection!'),
            duration: Duration(milliseconds: 400),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    const splashDuration = Duration(seconds: 3);

    Timer(
      splashDuration, () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => redirectToHome ? HomeScreen(onlineState: isConnected) : LoginScreen())
      )
    );

    return Scaffold(
      key: globalKey,
      body: Container(
        color: isDarkModeEnabled() ? darkColorScheme.background : lightColorScheme.background,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/images/sycamore-logo-main.svg',
                  semanticsLabel: 'Sycamore Logo',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
