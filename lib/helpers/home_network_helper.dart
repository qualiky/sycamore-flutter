import 'package:com_sandeepgtm_sycamore_mobile/helpers/Components/transaction_list_item.dart';
import 'package:com_sandeepgtm_sycamore_mobile/models/home_screen_data.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:com_sandeepgtm_sycamore_mobile/seed/home_page_data.dart';

import '../models/app_data.dart';

class HomeNetworkHelper {
  late BuildContext context;
  late http.Response tokenResponse;
  late AppData appData;

  final String BASE_URL = 'localhost:8081';

  HomeNetworkHelper({required this.context, required this.appData});

  void removeOldSalesData() async {
    appData.removeAllSalesData();
  }

  void getLastNTransactions() async {
    const jsonMap = lastTransactionDetails;
    jsonMap.forEach((key, value) {
      for(int i = 0; i < value.length; ++i) {
        final txElement = TransactionListItemElements(amount: double.parse("${value[i]['amount']}"), customerName: "${value[i]['customerName']}", dateTime: "${value[i]['datetime']}", paymentType: "${value[i]['paymentType']}");
        appData.addTransactionData(txElement);
      }
    });
  }

  void removeLastNTransactionData() async {
    appData.removeAllTransactionData();
  }

  void getLastSevenDaySales () async {
    const jsonMap = lastSevenDaySales;
    jsonMap.forEach((key, value) {
      for(var value in value) {
        for(int i = 0; i < value.length; ++i) {
          final salesData = SalesData(date: "$i", amount: double.parse("${value[i]['amount']}"));
          appData.addSalesData(salesData);
        }
      }
    });
  }
}