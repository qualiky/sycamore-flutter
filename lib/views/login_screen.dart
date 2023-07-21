import 'package:com_sandeepgtm_sycamore_mobile/utils/constants.dart';
import 'package:com_sandeepgtm_sycamore_mobile/views/home_screen.dart';
import 'package:com_sandeepgtm_sycamore_mobile/views/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../helpers/network_helper.dart';
import '../models/storage_item.dart';
import '../utils/color_schemes.g.dart';
import '../helpers/secure_storage_helper.dart';
import '../utils/secure_storage_constants.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late GlobalKey<ScaffoldMessengerState> globalKey;
  late TextEditingController usernameEditController;
  late TextEditingController passwordEditController;
  String _userName = "";
  String _password = "";

  @override
  void initState() {
    super.initState();
    globalKey = GlobalKey<ScaffoldMessengerState>();
  }

  @override
  Widget build(BuildContext context) {

    usernameEditController = TextEditingController();
    passwordEditController = TextEditingController();

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 72, bottom: 16),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/images/sycamore-logo-main.svg',
                  height: 300,
                  width: 300,
                ),
                Text(
                  "Log in to get back to your store.",
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                    color: isDarkModeEnabled()
                        ? lightColorScheme.primary
                        : darkColorScheme.inversePrimary,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 48, left: 32, right: 32),
                  child: TextField(
                    keyboardType: TextInputType.emailAddress,
                    controller: usernameEditController,
                    onChanged: (value) {
                      _userName = value;
                    },
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: isDarkModeEnabled()
                            ? darkColorScheme.surfaceVariant
                            : lightColorScheme.surfaceVariant,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 15),
                        hintText: 'Email',
                        helperText: 'Use your org email to log in',
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(5),
                              topRight: Radius.circular(5)),
                          borderSide: BorderSide.none,
                        )),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 32, left: 32, right: 32),
                  child: TextField(
                    obscureText: true,
                    obscuringCharacter: "•",
                    controller: passwordEditController,
                    onChanged: (value) {
                      _password = value;
                    },
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: isDarkModeEnabled()
                            ? darkColorScheme.surfaceVariant
                            : lightColorScheme.surfaceVariant,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 15),
                        hintText: 'Password',
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        helperText:
                            'Passwords must be at least 8 characters long',
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(5),
                              topRight: Radius.circular(5)),
                          borderSide: BorderSide.none,
                        ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 32, left: 32, right: 32),
                  child: SizedBox(
                    width: double.infinity,
                    child: MaterialButton(
                      color: isDarkModeEnabled()
                          ? darkColorScheme.primary
                          : lightColorScheme.primary,
                      onPressed: () async {
                        var netHelper = NetworkHelper(context);
                        Map<dynamic, dynamic> loginSuccessState =
                            await netHelper.verifyLogin(_userName, _password);
                        var sessionKey = loginSuccessState['sessionKey'];
                        if (sessionKey != null) {
                          SecureStorageHelper().writeSecureStorageData(
                              StorageItem(SecureStorageConstants.SESSION_COOKIE,
                                  sessionKey));
                          bool isOnline = await netHelper.hasNetwork();
                          if(!context.mounted) return;
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      HomeScreen(onlineState: isOnline)
                              ),
                          );
                        } else {
                          context.mounted ? showSnackbar(context, loginSuccessState['message'] ?? loginSuccessState['error']) : null;
                        }
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 15),
                        child: Text(
                          "Log In",
                          style: GoogleFonts.inter(
                            color: isDarkModeEnabled()
                                ? darkColorScheme.onPrimary
                                : lightColorScheme.onPrimary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 5),
                    child: Text('Dont have an account? Sign up'),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignupScreen()
                      ),
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
