import 'package:flutter/material.dart';

class SalesData {
  late String date;
  late double amount;

  SalesData({required this.date, required this.amount});

  Map toJson() => {
    'date': date,
    'amount': amount
  };
}