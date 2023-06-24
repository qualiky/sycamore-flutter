import 'dart:convert';

import 'package:com_sandeepgtm_sycamore_mobile/helpers/network_helper.dart';
import 'package:com_sandeepgtm_sycamore_mobile/models/app_data.dart';
import 'package:com_sandeepgtm_sycamore_mobile/utils/color_schemes.g.dart';
import 'package:com_sandeepgtm_sycamore_mobile/utils/constants.dart';
import 'package:com_sandeepgtm_sycamore_mobile/widgets/country_dropdown.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:country_codes/country_codes.dart';
import 'package:provider/provider.dart';

import '../helpers/secure_storage_helper.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  late TextEditingController emailEditController,
      firstNameController,
      lastNameController,
      phoneNumberController,
      passwordController,
      repeatPasswordController;
  String _email = "";
  String _firstName = "";
  String _lastName = "";
  String _phoneNumber = "";
  String _password = "";
  String _repeatPassword = "";
  String emailStatus = "Enter your unique email to sign up.";
  String firstNameStatus = "Your first name. We will call you with this name.";
  String lastNameStatus = "Your last name.";
  String phoneNumberStatus = "Enter your 10-digit contact number.";
  String passwordStatus = "At least 8 characters long";
  String repeatPasswordStatus = "Does not match password.";
  bool isEmailCorrect = false;
  bool isFirstNameCorrect = false;
  bool isLastNameCorrect = false;
  bool isPhoneNumberCorrect = false;
  bool isPasswordCorrect = false;
  bool isRepeatPasswordCorrect = false;
  bool? isEmailValidationLoading;
  Country selectedCountry = Country('Nepal', 'NP');
  List<Country> _countries = [];
  String selectedCountryCode = '';
  FocusNode emailFocusNode = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadCountries();
    emailFocusNode.addListener(() {
      if(!emailFocusNode.hasFocus) {
        verifyEmail();
      }
    });
  }

  @override
  void dispose() {
    emailFocusNode.removeListener(() { });
    super.dispose();

  }

  void verifyEmail() async {
    isEmailValidationLoading = false;
    if (_email.length < 3) {
      setState(() {
        emailStatus = "Invalid input.";
        isEmailCorrect = false;
      });
    } else {
      var receivedEmailStatus =
      await NetworkHelper(context).verifyEmail(_email);
      print('This is after awaiting email verification.');
      var verifiedEmail = await SecureStorageHelper().readSecureStorageData('verifiedSignupEmail');
      setState(() {
        emailStatus = receivedEmailStatus['message'];
        isEmailCorrect =
            receivedEmailStatus['status'] == 'true';
            if(isEmailCorrect) {
              print("From secure storage: $verifiedEmail");
              emailEditController.text = verifiedEmail!;
            }
        // if (isEmailCorrect) {
        //   emailEditController.text = _email;
        // }
      });
    }
  }

  void _loadCountries() async {
    var prevCountries = CountryCodes.countryCodes();
    for (CountryDetails? countryDetails in prevCountries) {
      if (countryDetails != null) {
        _countries.add(Country(countryDetails.name, countryDetails.alpha2Code));
      }
    }
    print("Length of countries: ${_countries.length}");
    for(Country c in _countries) {
      print('${c.name}: ${c.code}');
    }
  }

  @override
  Widget build(BuildContext context) {
    emailEditController = TextEditingController();
    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
    phoneNumberController = TextEditingController();
    passwordController = TextEditingController();
    repeatPasswordController = TextEditingController();

    return Consumer<AppData>(
      builder: (context, appData, child) {
        return Scaffold(
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 72, horizontal: 16),
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
                      "Welcome to Sycamore.\n"
                          "The partner to your SME.",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                          color: lightColorScheme.primary),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Text(
                      "Enter your email to get started.",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: lightColorScheme.primary),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(32, 32, 32, 0),
                      child: TextField(
                        keyboardType: TextInputType.emailAddress,
                        controller: emailEditController,
                        onChanged: (value) {
                          // _email = value;
                          // appData.signUpDataEmail = value;
                        },
                        focusNode: emailFocusNode,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: lightColorScheme.surfaceVariant,
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 20, horizontal: 15),
                            hintText: 'Email',
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            helperText: emailStatus,
                            helperStyle: TextStyle(
                                color: isEmailCorrect ? Colors.green : Colors.red),
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(5),
                                  topRight: Radius.circular(5)),
                              borderSide: BorderSide.none,
                            )),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(32, 24, 32, 0),
                      child: TextField(
                        keyboardType: TextInputType.name,
                        controller: firstNameController,
                        onEditingComplete: () {
                          _firstName = firstNameController.text;
                          if (_firstName.isEmpty) {
                            setState(() {
                              isFirstNameCorrect = false;
                              firstNameStatus = "First Name cannot be empty.";
                            });
                          } else {
                            setState(() {
                              isFirstNameCorrect = true;
                              firstNameStatus = "Valid first name.";
                              firstNameController.text = _firstName;
                            });
                          }
                        },
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: lightColorScheme.surfaceVariant,
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 20, horizontal: 15),
                            hintText: 'First Name',
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            helperText: firstNameStatus,
                            helperStyle: TextStyle(
                                color:
                                isFirstNameCorrect ? Colors.green : Colors.red),
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(5),
                                  topRight: Radius.circular(5)),
                              borderSide: BorderSide.none,
                            )),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(32, 24, 32, 0),
                      child: TextField(
                        keyboardType: TextInputType.name,
                        controller: lastNameController,
                        onEditingComplete: () {
                          _lastName = lastNameController.text;
                          if (_lastName.isEmpty) {
                            setState(() {
                              isLastNameCorrect = false;
                              lastNameStatus = "Last Name cannot be empty.";
                            });
                          } else {
                            setState(() {
                              isLastNameCorrect = true;
                              lastNameStatus = "Valid last name.";
                              lastNameController.text = _lastName;
                            });
                          }
                        },
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: lightColorScheme.surfaceVariant,
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 20, horizontal: 15),
                            hintText: 'Last Name',
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            helperText: lastNameStatus,
                            helperStyle: TextStyle(
                                color:
                                isLastNameCorrect ? Colors.green : Colors.red),
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(5),
                                  topRight: Radius.circular(5)),
                              borderSide: BorderSide.none,
                            )),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(32, 24, 32, 0),
                      child: TextField(
                        keyboardType: TextInputType.phone,
                        controller: phoneNumberController,
                        onEditingComplete: () {
                          _phoneNumber = phoneNumberController.text;
                          if (_phoneNumber.isEmpty || _phoneNumber.length < 10) {
                            setState(() {
                              isPhoneNumberCorrect = false;
                              phoneNumberStatus = "Invalid Contact Number.";
                            });
                          } else {
                            setState(() {
                              isPhoneNumberCorrect = true;
                              phoneNumberStatus = "Valid Contact Number.";
                              phoneNumberController.text = _lastName;
                            });
                          }
                        },
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: lightColorScheme.surfaceVariant,
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 20, horizontal: 15),
                            hintText: 'Contact Number',
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            helperText: lastNameStatus,
                            helperStyle: TextStyle(
                                color: isPhoneNumberCorrect
                                    ? Colors.green
                                    : Colors.red),
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(5),
                                  topRight: Radius.circular(5)),
                              borderSide: BorderSide.none,
                            )),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(32, 24, 32, 0),
                      child: DropdownButtonFormField<Country>(
                        isDense: true,
                        isExpanded: true,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: lightColorScheme.surfaceVariant,
                            // contentPadding: const EdgeInsets.symmetric(
                            //     vertical: 20, horizontal: 32),
                            hintText: 'Your Country',
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(5),
                                  topRight: Radius.circular(5)),
                              borderSide: BorderSide.none,
                            )
                        ),
                        // items: _countries
                        //     .map<DropdownMenuItem<Country>>((Country c) => DropdownMenuItem<Country>(
                        //     value: c, // add this property an pass the _value to it
                        //     child: Text(c.name!,)
                        // )).toList(),
                        items: _countries.map((Country c) =>
                            DropdownMenuItem<Country>(
                              value: c,
                              child: Text(c.name!),
                            )
                        ).toList(growable: false),
                        onChanged: (Country? c) {
                          setState(() {
                            if(c != null && c.code != null) {
                              print("Selected country: ${c.name} with code: ${c.code}");
                              selectedCountry = c;
                              selectedCountryCode = c.code!;
                            }
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(32, 24, 32, 0),
                      child: TextField(
                        keyboardType: TextInputType.text,
                        controller: passwordController,
                        onEditingComplete: () {
                          _password = passwordController.text;
                          if (_password.isEmpty || _phoneNumber.length < 8) {
                            setState(() {
                              isPasswordCorrect = false;
                              passwordStatus = "Invalid Password.";
                            });
                          } else {
                            setState(() {
                              isPasswordCorrect = true;
                              passwordStatus = "Good job!";
                              passwordController.text = _password;
                            });
                          }
                        },
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: lightColorScheme.surfaceVariant,
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 15),
                          hintText: 'Password',
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          helperText: passwordStatus,
                          helperStyle: TextStyle(
                              color: isPasswordCorrect
                                  ? Colors.green
                                  : Colors.red),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(5),
                              topRight: Radius.circular(5),
                            ),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(32, 24, 32, 0),
                      child: TextField(
                        keyboardType: TextInputType.text,
                        controller: repeatPasswordController,
                        onEditingComplete: () {
                          _repeatPassword = repeatPasswordController.text;
                          if (_repeatPassword.isEmpty || _repeatPassword.length < 8 || _repeatPassword != _password) {
                            setState(() {
                              isRepeatPasswordCorrect = false;
                              repeatPasswordStatus = "Passwords do not match";
                            });
                          } else {
                            setState(() {
                              isRepeatPasswordCorrect = true;
                              repeatPasswordStatus = "Good job!";
                              repeatPasswordController.text = _repeatPassword;
                            });
                          }
                        },
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: lightColorScheme.surfaceVariant,
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 15),
                          hintText: 'Repeat Password',
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          helperText: repeatPasswordStatus,
                          helperStyle: TextStyle(
                              color: isRepeatPasswordCorrect
                                  ? Colors.green
                                  : Colors.red),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(5),
                              topRight: Radius.circular(5),
                            ),
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
                            Map<dynamic, dynamic> signupSuccessState =
                            await netHelper.verifySignup(_email, _firstName, _lastName, _phoneNumber, selectedCountryCode, _password, _repeatPassword);
                            // var sessionKey = loginSuccessState['sessionKey'];
                            // if (sessionKey != null) {
                            //   SecureStorageHelper().writeSecureStorageData(
                            //       StorageItem(SecureStorageConstants.SESSION_COOKIE,
                            //           sessionKey));
                            //   bool isOnline = await netHelper.hasNetwork();
                            //   if(!context.mounted) return;
                            //   Navigator.pushReplacement(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) =>
                            //             HomeScreen(onlineState: isOnline)
                            //     ),
                            //   );
                            // }
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 20, horizontal: 15),
                            child: Text(
                              "Sign Up",
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
                  ],
                ),
              ),
            ),
          ),
        );
      },
      // child: Scaffold(
      //   body: SingleChildScrollView(
      //     child: Padding(
      //       padding: const EdgeInsets.symmetric(vertical: 72, horizontal: 16),
      //       child: Center(
      //         child: Column(
      //           crossAxisAlignment: CrossAxisAlignment.center,
      //           children: [
      //             SvgPicture.asset(
      //               'assets/images/sycamore-logo-main.svg',
      //               height: 300,
      //               width: 300,
      //             ),
      //             Text(
      //               "Welcome to Sycamore.\n"
      //               "The partner to your SME.",
      //               textAlign: TextAlign.center,
      //               style: GoogleFonts.inter(
      //                   fontWeight: FontWeight.w700,
      //                   fontSize: 20,
      //                   color: lightColorScheme.primary),
      //             ),
      //             const SizedBox(
      //               height: 30,
      //             ),
      //             Text(
      //               "Enter your email to get started.",
      //               textAlign: TextAlign.center,
      //               style: GoogleFonts.inter(
      //                   fontWeight: FontWeight.w500,
      //                   fontSize: 16,
      //                   color: lightColorScheme.primary),
      //             ),
      //             Padding(
      //               padding: const EdgeInsets.fromLTRB(32, 32, 32, 0),
      //               child: TextField(
      //                 keyboardType: TextInputType.emailAddress,
      //                 controller: emailEditController,
      //                 onChanged: (value) {
      //                   _email = value;
      //                 },
      //                 focusNode: emailFocusNode,
      //                 decoration: InputDecoration(
      //                     filled: true,
      //                     fillColor: lightColorScheme.surfaceVariant,
      //                     contentPadding: const EdgeInsets.symmetric(
      //                         vertical: 20, horizontal: 15),
      //                     hintText: 'Email',
      //                     errorBorder: InputBorder.none,
      //                     disabledBorder: InputBorder.none,
      //                     helperText: emailStatus,
      //                     helperStyle: TextStyle(
      //                         color: isEmailCorrect ? Colors.green : Colors.red),
      //                     border: const OutlineInputBorder(
      //                       borderRadius: BorderRadius.only(
      //                           topLeft: Radius.circular(5),
      //                           topRight: Radius.circular(5)),
      //                       borderSide: BorderSide.none,
      //                     )),
      //               ),
      //             ),
      //             Padding(
      //               padding: const EdgeInsets.fromLTRB(32, 24, 32, 0),
      //               child: TextField(
      //                 keyboardType: TextInputType.name,
      //                 controller: firstNameController,
      //                 onEditingComplete: () {
      //                   _firstName = firstNameController.text;
      //                   if (_firstName.isEmpty) {
      //                     setState(() {
      //                       isFirstNameCorrect = false;
      //                       firstNameStatus = "First Name cannot be empty.";
      //                     });
      //                   } else {
      //                     setState(() {
      //                       isFirstNameCorrect = true;
      //                       firstNameStatus = "Valid first name.";
      //                       firstNameController.text = _firstName;
      //                     });
      //                   }
      //                 },
      //                 decoration: InputDecoration(
      //                     filled: true,
      //                     fillColor: lightColorScheme.surfaceVariant,
      //                     contentPadding: const EdgeInsets.symmetric(
      //                         vertical: 20, horizontal: 15),
      //                     hintText: 'First Name',
      //                     errorBorder: InputBorder.none,
      //                     disabledBorder: InputBorder.none,
      //                     helperText: firstNameStatus,
      //                     helperStyle: TextStyle(
      //                         color:
      //                             isFirstNameCorrect ? Colors.green : Colors.red),
      //                     border: const OutlineInputBorder(
      //                       borderRadius: BorderRadius.only(
      //                           topLeft: Radius.circular(5),
      //                           topRight: Radius.circular(5)),
      //                       borderSide: BorderSide.none,
      //                     )),
      //               ),
      //             ),
      //             Padding(
      //               padding: const EdgeInsets.fromLTRB(32, 24, 32, 0),
      //               child: TextField(
      //                 keyboardType: TextInputType.name,
      //                 controller: lastNameController,
      //                 onEditingComplete: () {
      //                   _lastName = lastNameController.text;
      //                   if (_lastName.isEmpty) {
      //                     setState(() {
      //                       isLastNameCorrect = false;
      //                       lastNameStatus = "Last Name cannot be empty.";
      //                     });
      //                   } else {
      //                     setState(() {
      //                       isLastNameCorrect = true;
      //                       lastNameStatus = "Valid last name.";
      //                       lastNameController.text = _lastName;
      //                     });
      //                   }
      //                 },
      //                 decoration: InputDecoration(
      //                     filled: true,
      //                     fillColor: lightColorScheme.surfaceVariant,
      //                     contentPadding: const EdgeInsets.symmetric(
      //                         vertical: 20, horizontal: 15),
      //                     hintText: 'Last Name',
      //                     errorBorder: InputBorder.none,
      //                     disabledBorder: InputBorder.none,
      //                     helperText: lastNameStatus,
      //                     helperStyle: TextStyle(
      //                         color:
      //                             isLastNameCorrect ? Colors.green : Colors.red),
      //                     border: const OutlineInputBorder(
      //                       borderRadius: BorderRadius.only(
      //                           topLeft: Radius.circular(5),
      //                           topRight: Radius.circular(5)),
      //                       borderSide: BorderSide.none,
      //                     )),
      //               ),
      //             ),
      //             Padding(
      //               padding: const EdgeInsets.fromLTRB(32, 24, 32, 0),
      //               child: TextField(
      //                 keyboardType: TextInputType.phone,
      //                 controller: phoneNumberController,
      //                 onEditingComplete: () {
      //                   _phoneNumber = phoneNumberController.text;
      //                   if (_phoneNumber.isEmpty || _phoneNumber.length < 10) {
      //                     setState(() {
      //                       isPhoneNumberCorrect = false;
      //                       phoneNumberStatus = "Invalid Contact Number.";
      //                     });
      //                   } else {
      //                     setState(() {
      //                       isPhoneNumberCorrect = true;
      //                       phoneNumberStatus = "Valid Contact Number.";
      //                       phoneNumberController.text = _lastName;
      //                     });
      //                   }
      //                 },
      //                 decoration: InputDecoration(
      //                     filled: true,
      //                     fillColor: lightColorScheme.surfaceVariant,
      //                     contentPadding: const EdgeInsets.symmetric(
      //                         vertical: 20, horizontal: 15),
      //                     hintText: 'Contact Number',
      //                     errorBorder: InputBorder.none,
      //                     disabledBorder: InputBorder.none,
      //                     helperText: lastNameStatus,
      //                     helperStyle: TextStyle(
      //                         color: isPhoneNumberCorrect
      //                             ? Colors.green
      //                             : Colors.red),
      //                     border: const OutlineInputBorder(
      //                       borderRadius: BorderRadius.only(
      //                           topLeft: Radius.circular(5),
      //                           topRight: Radius.circular(5)),
      //                       borderSide: BorderSide.none,
      //                     )),
      //               ),
      //             ),
      //             Padding(
      //               padding: const EdgeInsets.fromLTRB(32, 24, 32, 0),
      //               child: DropdownButtonFormField<Country>(
      //                 isDense: true,
      //                 isExpanded: true,
      //                 decoration: InputDecoration(
      //                     filled: true,
      //                     fillColor: lightColorScheme.surfaceVariant,
      //                     // contentPadding: const EdgeInsets.symmetric(
      //                     //     vertical: 20, horizontal: 32),
      //                     hintText: 'Your Country',
      //                     errorBorder: InputBorder.none,
      //                     disabledBorder: InputBorder.none,
      //                     border: const OutlineInputBorder(
      //                       borderRadius: BorderRadius.only(
      //                           topLeft: Radius.circular(5),
      //                           topRight: Radius.circular(5)),
      //                       borderSide: BorderSide.none,
      //                     )
      //                 ),
      //                 // items: _countries
      //                 //     .map<DropdownMenuItem<Country>>((Country c) => DropdownMenuItem<Country>(
      //                 //     value: c, // add this property an pass the _value to it
      //                 //     child: Text(c.name!,)
      //                 // )).toList(),
      //                 items: _countries.map((Country c) =>
      //                     DropdownMenuItem<Country>(
      //                         value: c,
      //                         child: Text(c.name!),
      //                     )
      //                 ).toList(growable: false),
      //                 onChanged: (Country? c) {
      //                    setState(() {
      //                      if(c != null && c.code != null) {
      //                        print("Selected country: ${c.name} with code: ${c.code}");
      //                        selectedCountry = c;
      //                        selectedCountryCode = c.code!;
      //                      }
      //                    });
      //                 },
      //               ),
      //             ),
      //             Padding(
      //               padding: const EdgeInsets.fromLTRB(32, 24, 32, 0),
      //               child: TextField(
      //                 keyboardType: TextInputType.text,
      //                 controller: passwordController,
      //                 onEditingComplete: () {
      //                    _password = passwordController.text;
      //                   if (_password.isEmpty || _phoneNumber.length < 8) {
      //                     setState(() {
      //                       isPasswordCorrect = false;
      //                       passwordStatus = "Invalid Password.";
      //                     });
      //                   } else {
      //                     setState(() {
      //                       isPasswordCorrect = true;
      //                       passwordStatus = "Good job!";
      //                       passwordController.text = _password;
      //                     });
      //                   }
      //                 },
      //                 decoration: InputDecoration(
      //                     filled: true,
      //                     fillColor: lightColorScheme.surfaceVariant,
      //                     contentPadding: const EdgeInsets.symmetric(
      //                         vertical: 20, horizontal: 15),
      //                     hintText: 'Password',
      //                     errorBorder: InputBorder.none,
      //                     disabledBorder: InputBorder.none,
      //                     helperText: passwordStatus,
      //                     helperStyle: TextStyle(
      //                         color: isPasswordCorrect
      //                             ? Colors.green
      //                             : Colors.red),
      //                     border: const OutlineInputBorder(
      //                       borderRadius: BorderRadius.only(
      //                           topLeft: Radius.circular(5),
      //                           topRight: Radius.circular(5),
      //                       ),
      //                       borderSide: BorderSide.none,
      //                     ),
      //                 ),
      //               ),
      //             ),
      //             Padding(
      //               padding: const EdgeInsets.fromLTRB(32, 24, 32, 0),
      //               child: TextField(
      //                 keyboardType: TextInputType.text,
      //                 controller: repeatPasswordController,
      //                 onEditingComplete: () {
      //                   _repeatPassword = repeatPasswordController.text;
      //                   if (_repeatPassword.isEmpty || _repeatPassword.length < 8 || _repeatPassword != _password) {
      //                     setState(() {
      //                       isRepeatPasswordCorrect = false;
      //                       repeatPasswordStatus = "Passwords do not match";
      //                     });
      //                   } else {
      //                     setState(() {
      //                       isRepeatPasswordCorrect = true;
      //                       repeatPasswordStatus = "Good job!";
      //                       repeatPasswordController.text = _repeatPassword;
      //                     });
      //                   }
      //                 },
      //                 decoration: InputDecoration(
      //                   filled: true,
      //                   fillColor: lightColorScheme.surfaceVariant,
      //                   contentPadding: const EdgeInsets.symmetric(
      //                       vertical: 20, horizontal: 15),
      //                   hintText: 'Repeat Password',
      //                   errorBorder: InputBorder.none,
      //                   disabledBorder: InputBorder.none,
      //                   helperText: repeatPasswordStatus,
      //                   helperStyle: TextStyle(
      //                       color: isRepeatPasswordCorrect
      //                           ? Colors.green
      //                           : Colors.red),
      //                   border: const OutlineInputBorder(
      //                     borderRadius: BorderRadius.only(
      //                       topLeft: Radius.circular(5),
      //                       topRight: Radius.circular(5),
      //                     ),
      //                     borderSide: BorderSide.none,
      //                   ),
      //                 ),
      //               ),
      //             ),
      //             Padding(
      //               padding: const EdgeInsets.only(top: 32, left: 32, right: 32),
      //               child: SizedBox(
      //                 width: double.infinity,
      //                 child: MaterialButton(
      //                   color: isDarkModeEnabled()
      //                       ? darkColorScheme.primary
      //                       : lightColorScheme.primary,
      //                   onPressed: () async {
      //                     var netHelper = NetworkHelper(context);
      //                     Map<dynamic, dynamic> signupSuccessState =
      //                     await netHelper.verifySignup(_email, _firstName, _lastName, _phoneNumber, selectedCountryCode, _password, _repeatPassword);
      //                     // var sessionKey = loginSuccessState['sessionKey'];
      //                     // if (sessionKey != null) {
      //                     //   SecureStorageHelper().writeSecureStorageData(
      //                     //       StorageItem(SecureStorageConstants.SESSION_COOKIE,
      //                     //           sessionKey));
      //                     //   bool isOnline = await netHelper.hasNetwork();
      //                     //   if(!context.mounted) return;
      //                     //   Navigator.pushReplacement(
      //                     //     context,
      //                     //     MaterialPageRoute(
      //                     //         builder: (context) =>
      //                     //             HomeScreen(onlineState: isOnline)
      //                     //     ),
      //                     //   );
      //                     // }
      //                   },
      //                   shape: RoundedRectangleBorder(
      //                     borderRadius: BorderRadius.circular(30),
      //                   ),
      //                   child: Padding(
      //                     padding: const EdgeInsets.symmetric(
      //                         vertical: 20, horizontal: 15),
      //                     child: Text(
      //                       "Sign Up",
      //                       style: GoogleFonts.inter(
      //                         color: isDarkModeEnabled()
      //                             ? darkColorScheme.onPrimary
      //                             : lightColorScheme.onPrimary,
      //                         fontWeight: FontWeight.w500,
      //                       ),
      //                     ),
      //                   ),
      //                 ),
      //               ),
      //             ),
      //           ],
      //         ),
      //       ),
      //     ),
      //   ),
      // ),
    );
  }
}
