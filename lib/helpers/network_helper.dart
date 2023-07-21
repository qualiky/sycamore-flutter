import 'dart:convert';
import 'package:com_sandeepgtm_sycamore_mobile/models/storage_item.dart';
import 'package:intl/intl.dart';
import 'package:com_sandeepgtm_sycamore_mobile/helpers/secure_storage_helper.dart';
import 'package:com_sandeepgtm_sycamore_mobile/models/simple_response.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:com_sandeepgtm_sycamore_mobile/utils/secure_storage_constants.dart';

class NetworkHelper {

  late BuildContext context;
  late SecureStorageHelper secureStorageHelper;
  late http.Response tokenResponse;

  final String BASE_URL = 'localhost:8081';

  NetworkHelper(this.context) {
    secureStorageHelper = SecureStorageHelper();
  }

  String convertUtcStringToDateTime(String utcString) {
    DateFormat utcFormat = DateFormat('EEE, dd MMM yyyy HH:mm:ss');
    DateTime dateTime = utcFormat.parseUtc(utcString);
    DateFormat outputFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
    String formattedDateTime = outputFormat.format(dateTime);
    return formattedDateTime;
  }


  Future<bool> hasValidSessionCookies() async {
    bool redirectToHome = false;
    String? sessionCookie = await secureStorageHelper.readSecureStorageData(SecureStorageConstants.SESSION_COOKIE);
    print('Session cookie: $sessionCookie');
    if(sessionCookie == null) {
      print("Session cookie empty!");
      // cookie is empty, redirect to login
      return redirectToHome = false;

    } else {
      if(sessionCookie.contains('Expires')) {
        // check the expiry date of cookies
        String expiresValue = sessionCookie.split('Expires=')[1].trim();
        print("Expires value: $expiresValue");
        String splitTimeOnly = expiresValue.split(';')[0].trim();
        print('Split time: $splitTimeOnly');
        DateTime? expirationDateTime = DateTime.tryParse(convertUtcStringToDateTime(splitTimeOnly));
        print("Expiration date for cookie: $expirationDateTime");
        DateTime? localExpirationDateTime = expirationDateTime?.add(expirationDateTime.timeZoneOffset);
        print('local expiry time: $localExpirationDateTime');

        if(localExpirationDateTime != null && localExpirationDateTime.isBefore(DateTime.now())) {
          // cookie has expired
          print("Cookie has expired!");
          return redirectToHome = false;
        } else {
          print("Cookie has not expired!");
          // cookie has not expired, and the cookie is valid. jump to home.
          return redirectToHome = true;
        }
      }
    }
    return redirectToHome;
  }

  Future<Map<dynamic, dynamic>> verifyLogin(String email, String password) async {
    var loginStatus = {};

    final url = Uri.parse('http://localhost:8081/api/auth/login');
    final body = {
      'email': email,
      'password': password
    };

    print("Body: pre-request: $body");
    final response = await http.post(url, body: body);
    final parsedResponse = await jsonDecode(response.body);
    print(parsedResponse);

    loginStatus['statusCode'] = response.statusCode;
    loginStatus['message'] = parsedResponse['message'] ?? 'Server returned no response.';

    if(response.statusCode == 200 && response.headers['set-cookie'] != null) {
      // final sessionKey = _extractSessionKey(response.headers['set-cookie']!);
      final sessionKey = response.headers['set-cookie']!;
      print("Parsed sessionKey from cookie: $sessionKey");
      loginStatus['sessionKey'] = sessionKey;
    } else if(response.statusCode == 403) {
      loginStatus['sessionKey'] = null;
    }

    return loginStatus;
  }

  Future<Map<dynamic, dynamic>> verifySignup(String email, String firstName, String lastName, String contactNumber, String countryCode, String password, String repeatPassword) async {
    var signupStatus = {};

    final url = Uri.parse('http://localhost:8081/api/auth/signup');
    final body = {
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': contactNumber,
      'country': countryCode,
      'password': password,
      'repeatPassword': repeatPassword
    };

    print("Body: pre-request during signup: $body");
    final response = await http.post(url, body: body);
    final parsedResponse = await jsonDecode(response.body);
    print(parsedResponse);

    signupStatus['statusCode'] = response.statusCode;
    signupStatus['message'] = parsedResponse['message'] ?? parsedResponse['error'];

    return signupStatus;
  }

  
  Future<Map<dynamic, dynamic>> verifyEmail(String email) async {
    var emailStatus = {};
    
    final url = Uri.parse('http://localhost:8081/api/auth/signup/emailvalidate');
    final body = {
      'email': email
    };

    print("Body: pre-request: $body");
    final response = await http.post(url, body: body);
    final parsedResponse = jsonDecode(response.body);
    print("RESPONSE: $parsedResponse");

    emailStatus['status'] = parsedResponse['status'];
    emailStatus['message'] = parsedResponse['message'];

    if(emailStatus['status'] == 'true') {
      await secureStorageHelper.writeSecureStorageData(StorageItem('verifiedSignupEmail', email));
    }
    return emailStatus;
  }

  Future<Map<dynamic, dynamic>> verifySignOut() async {

    var logoutStatus = {};

    final url = Uri.parse('http://localhost:8081/api/auth/logout');
    print('Logout initiated');

    String? savedSessCookie = await secureStorageHelper.readSecureStorageData(SecureStorageConstants.SESSION_COOKIE);

    if(savedSessCookie != null) {

      final body = {
        'sessionKey': savedSessCookie
      };

      final response = await http.post(url, body: body);
      final parsedResponse = await jsonDecode(response.body);
      print(parsedResponse);

      await secureStorageHelper.deleteSecureStorageData(SecureStorageConstants.SESSION_COOKIE);

      if(response.statusCode == 200) {
        print('Logged out successfully!');
        await secureStorageHelper.deleteSecureStorageData(savedSessCookie);
        logoutStatus['statusCode'] = response.statusCode;
        logoutStatus['message'] = parsedResponse['message'] ?? 'Logged out successfully on client end.';
        logoutStatus['isLoggedOut'] = true;
        return logoutStatus;
      } else {
        print('Logged out despite status code 500');
        await secureStorageHelper.deleteSecureStorageData(savedSessCookie);
        logoutStatus['statusCode'] = response.statusCode;
        logoutStatus['message'] = parsedResponse['message'] ?? 'Logged out successfully on client end.';
        logoutStatus['isLoggedOut'] = true;
        return logoutStatus;
      }

    } else {
      logoutStatus['message'] = 'Logged out';
      logoutStatus['isLoggedOut'] = true;
      return logoutStatus;
    }
  }



  String _extractSessionKey(String cookie) {
    final keyStart = cookie.indexOf('sessionKey=') + 11;
    final keyEnd = cookie.indexOf(';', keyStart);
    return cookie.substring(keyStart, keyEnd);
  }


  Future<bool> hasNetwork() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch(_) {
      return false;
    }
  }



}