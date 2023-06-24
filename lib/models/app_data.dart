import 'package:com_sandeepgtm_sycamore_mobile/models/signup_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class AppData extends ChangeNotifier {

  var _signUpData = SignupData();

  void setSignupData(SignupData signupData) {
    _signUpData = signupData;
    notifyListeners();
  }

  SignupData getSignupData() {
    return _signUpData;
  }

  String get signUpDataLastName => _signUpData.lastName;

  set signUpDataLastName(String value) {
    _signUpData.lastName = value;
  }

  String get signUpDataFirstName => _signUpData.firstName;

  set signUpDataFirstName(String value) {
    _signUpData.firstName = value;
  }

  String get signUpDataRepeatPassword => _signUpData.repeatPassword;

  set signUpDataRepeatPassword(String value) {
    _signUpData.repeatPassword = value;
  }

  String get signUpDataPassword => _signUpData.password;

  set signUpDataPassword(String value) {
    _signUpData.password = value;
  }

  String get signUpDataCountryCode => _signUpData.countryCode;

  set signUpDataCountryCode(String value) {
    _signUpData.countryCode = value;
  }

  String get signUpDataPhoneNumber => _signUpData.phoneNumber;

  set signUpDataPhoneNumber(String value) {
    _signUpData.phoneNumber = value;
  }

  String get signUpDataEmail => _signUpData.email;

  set signUpDataEmail(String value) {
    _signUpData.email = value;
  }

}