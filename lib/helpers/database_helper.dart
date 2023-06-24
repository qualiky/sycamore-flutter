import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class DatabaseHelper {
  late BuildContext context;
  late FlutterSecureStorage secureStorage;

  DatabaseHelper(this.context) {
    secureStorage = const FlutterSecureStorage();
  }


}