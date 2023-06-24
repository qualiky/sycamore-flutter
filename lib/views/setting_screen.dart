

import 'package:com_sandeepgtm_sycamore_mobile/views/login_screen.dart';
import 'package:flutter/material.dart';
import '../helpers/network_helper.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Expanded(
                child: Text('Expanded'),
              ),
              MaterialButton(
                color: Colors.red,
                minWidth: double.infinity,
                onPressed: () async {
                  final logoutStatus = await NetworkHelper(context).verifySignOut();
                  print("${logoutStatus['isLoggedOut']} ${logoutStatus['message']} ${logoutStatus['statusCode']}");
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (ctx) => LoginScreen()), (route) => false);
                },
                child: const Text(
                  'Log Out',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                )
              ),
            ],
          ),
        )
    );
  }
}
