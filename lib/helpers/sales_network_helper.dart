import 'dart:convert';
import 'dart:ffi';

import 'package:com_sandeepgtm_sycamore_mobile/helpers/Components/transaction_list_item.dart';
import 'package:com_sandeepgtm_sycamore_mobile/helpers/secure_storage_helper.dart';
import 'package:com_sandeepgtm_sycamore_mobile/models/home_screen_data.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:com_sandeepgtm_sycamore_mobile/seed/home_page_data.dart';

import '../models/app_data.dart';
import '../utils/secure_storage_constants.dart';

class SalesNetworkHelper {

  late BuildContext context;
  late http.Response tokenResponse;
  late SecureStorageHelper secureStorageHelper;
  late AppData appData;

  final String BASE_URL = 'localhost:8081';

  SalesNetworkHelper({required this.context, required this.appData}){
    secureStorageHelper = SecureStorageHelper();
  }

  void removeOldSalesRecordData() async {
    appData.removeAllSalesRecordData();
  }

  Future<bool> getSalesRecords() async {
    var salesRecordsList = {};
    List<SalesRecordData> salesRecordTypedList = [];
    var headers;

    String? savedSessCookie = await secureStorageHelper.readSecureStorageData(SecureStorageConstants.SESSION_COOKIE);

    if(savedSessCookie != null) {
        headers = {
        'sessionKey': (savedSessCookie.split(';')[0]).split('=')[1]
      };
    }

    final url = Uri.parse(
      'http://localhost:8081/api/sales/sales-record',
    );

    final response = await http.get(url, headers: headers);
    final parsedResponse = await jsonDecode(response.body);
    print(parsedResponse);

    salesRecordsList['statusCode'] = response.statusCode;
    salesRecordsList['message'] = parsedResponse['message'] ?? parsedResponse['error'];

    if(response.statusCode == 200) {
      salesRecordTypedList = (parsedResponse['data'] as List<dynamic>).map((e) => SalesRecordData.fromJson(e as Map<String, dynamic>)).toList(growable: true);
      print('Added new list length: ${salesRecordTypedList.length}');
      appData.removeAllSalesRecordData();
      appData.addMultipleSalesRecordData(salesRecordTypedList);
    } else if(response.statusCode == 500) {
      appData.removeAllSalesRecordData();
    }
    return appData.getSalesRecordDataCount > 0;
  }


  Future<bool> getIndividualSalesRecord(String salesRecordId) async {

    var responseMeta = {};
    IndividualSalesRecord individualSalesRecord;
    var headers, url;

    String? savedSessCookie = await secureStorageHelper.readSecureStorageData(SecureStorageConstants.SESSION_COOKIE);

    if(savedSessCookie != null) {
      headers = {
        'sessionKey': (savedSessCookie.split(';')[0]).split('=')[1]
      };
    }

    url = Uri.parse(
      'http://localhost:8081/api/sales/sales-details?salesRecordId=$salesRecordId',
    );

    final response = await http.get(url, headers: headers);
    final parsedResponse = await jsonDecode(response.body);
    print(parsedResponse);

    responseMeta['statusCode'] = response.statusCode;
    responseMeta['message'] = parsedResponse['message'] ?? parsedResponse['error'];

    if(response.statusCode == 200) {
      var data = parsedResponse['data'];
      // individualSalesRecord = await data.map((e) => IndividualSalesRecord.fromJson(e));
      individualSalesRecord = IndividualSalesRecord.fromJson(data);
      print('Added new individual sales record: ${individualSalesRecord.salesRecordData.salesId}');
      appData.individualSalesData = individualSalesRecord;
    } else if(response.statusCode == 500) {
      appData.removeIndividualSalesData();
    }
    return appData.getIndividualSalesData != null;
  }
}


class IndividualSalesRecord {
  late SalesRecordData salesRecordData;
  late PaymentDetails paymentDetails;
  late List<BillRecordDetails> billRecordDetails;
  late int billItemCount;

  IndividualSalesRecord({
    required this.salesRecordData,
    required this.paymentDetails,
    required this.billRecordDetails,
    required this.billItemCount
  });

  factory IndividualSalesRecord.fromJson(Map<String, dynamic> parsedJson) {

    int billItemCount = parsedJson['itemCount'];

     var paymentDetails = PaymentDetails.from(
         paymentId: parsedJson['paymentRecord']['paymentId'],
         subtotalAmount: parsedJson['paymentRecord']['subtotalAmount'],
         discountPercentage: parsedJson['paymentRecord']['discountPercentage'],
         beforeVATAmount: parsedJson['paymentRecord']['beforeVATAmount'],
         vatPercentage: parsedJson['paymentRecord']['vatPercentage'],
         finalAmount: parsedJson['paymentRecord']['finalAmount'],
         remarks: parsedJson['paymentRecord']['remarks'] ?? "No Remarks",
         paidAmount: parsedJson['paymentRecord']['paidAmount'],
         paymentMethod: PaymentMethodType.values.byName(parsedJson['paymentRecord']['paymentMethod']),
         transactionGatewayId: parsedJson['paymentRecord']['transactionGatewayId'],
         dueAmount: parsedJson['paymentRecord']['dueAmount']
     );

     List<BillRecordDetails> billRecords = [];

     if(billItemCount > 0) {
       for(int i = 0; i < parsedJson['itemCount']; ++i) {
         billRecords.add(
             BillRecordDetails(
                 itemizedBillId: parsedJson['billRecord'][i]['itemizedBillId'],
                 itemName: parsedJson['billRecord'][i]['itemName'],
                 itemId: parsedJson['billRecord'][i]['itemId'],
                 itemizedBillRecNum: parsedJson['billRecord'][i]['itemizedBillRecNum'],
                 itemPrice: parsedJson['billRecord'][i]['itemPrice'],
                 discountPercentage: parsedJson['billRecord'][i]['discountPercentage'] ?? 0.0,
                 receiptNumber: parsedJson['billRecord'][i]['receiptNumber'],
                 quantity: parsedJson['billRecord'][i]['quantity'],
                 subTotal: parsedJson['billRecord'][i]['subTotal']
             )
         );
       }
     }

     var salesRecord = SalesRecordData(
         salesId: parsedJson['salesRecord']['salesId'],
         receiptNumber: parsedJson['salesRecord']['receiptNumber'],
         salesDate: parsedJson['salesRecord']['salesDate'],
         billId: parsedJson['salesRecord']['itemizedBillId'],
         paymentId: parsedJson['paymentRecord']['paymentId'],
         paymentMethod: parsedJson['paymentRecord']['paymentMethod'],
         paidAmount: parsedJson['paymentRecord']['paidAmount'],
         remarks: parsedJson['paymentRecord']['salesId'] ?? "No Remarks"
     );

     return IndividualSalesRecord(
       salesRecordData: salesRecord,
       billRecordDetails: billRecords,
       billItemCount: billItemCount,
       paymentDetails: paymentDetails
     );
  }
}

class PaymentDetails {
  late String paymentId;
  late num subtotalAmount;
  late num discountPercentage;
  late num beforeVATAmount;
  late num vatPercentage;
  late num finalAmount;
  late String? remarks;
  late num paidAmount;
  late PaymentMethodType paymentMethod;
  late String transactionGatewayId;
  late num dueAmount;

  PaymentDetails.from({
      required this.paymentId,
      required this.subtotalAmount,
      required this.discountPercentage,
      required this.beforeVATAmount,
      required this.vatPercentage,
      required this.finalAmount,
      this.remarks,
      required this.paidAmount,
      required this.paymentMethod,
      required this.transactionGatewayId,
      required this.dueAmount });
}

class BillRecordDetails {
  late String itemizedBillId;
  late String itemName;
  late String itemId;
  late String itemizedBillRecNum;
  late num itemPrice;
  late num discountPercentage;
  late String? remarks;
  late num receiptNumber;
  late num quantity;
  late num subTotal;

  BillRecordDetails({
      required this.itemizedBillId,
      required this.itemName,
      required this.itemId,
      required this.itemizedBillRecNum,
      required this.itemPrice,
      required this.discountPercentage,
      this.remarks,
      required this.receiptNumber,
      required this.quantity,
      required this.subTotal
  });
}

enum PaymentMethodType {
  ESWA, FNPY, CASH, DBTC, CDTC, KHLT, BANK, CHEQ
}


class SalesRecordData {
  late String salesId;
  late num receiptNumber;
  late String salesDate;
  late String? buyerContact;
  late String billId;
  late String paymentId;
  late String paymentMethod;
  late num paidAmount;
  late String remarks;

  SalesRecordData({required this.salesId, required this.receiptNumber, required this.salesDate,
      this.buyerContact, required this.billId, required this.paymentId, required this.paymentMethod,required this.paidAmount, required this.remarks});


  factory SalesRecordData.fromJson(Map<String, dynamic> parsedJson) {
    return SalesRecordData(
        salesId: parsedJson['salesRecord']['salesId'],
        receiptNumber: parsedJson['salesRecord']['receiptNumber'],
        salesDate: parsedJson['salesRecord']['salesDate'],
        buyerContact: parsedJson['salesRecord']['buyerContact'],
        billId: parsedJson['salesRecord']['itemizedBillId'],
        paymentId: parsedJson['salesRecord']['paymentId'],
        paymentMethod: parsedJson['paymentMethod'],
        paidAmount: double.parse(parsedJson['paidAmount'].toString()),
        remarks: parsedJson['remarks']
    );
  }
}