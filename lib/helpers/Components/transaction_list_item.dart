import 'package:com_sandeepgtm_sycamore_mobile/utils/color_schemes.g.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class TransactionListItem extends StatelessWidget {

  late TransactionListItemElements elements;

  TransactionListItem({super.key, required this.elements});

  String getFormattedDate(String dateString) {
    print(dateString);
    var dt = DateTime.parse(dateString);
     // var dateFormatter = DateFormat('yyyy-MM-ddTHH:mm:ssZ');
    var dateFormatter = DateFormat('yyyy-MM-dd hh:mm a');
     final formattedDate = dateFormatter.format(dt);
     return formattedDate.toString();
  }

  @override
  Widget build(BuildContext context) {
    print("${elements.dateTime} ${elements.amount} ${elements.paymentType} ${elements.customerName}");
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SizedBox(
        height: 75,
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: lightColorScheme.primaryContainer.withOpacity(0.3),
            border: Border.all(
              color: lightColorScheme.onPrimaryContainer,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      elements.customerName,
                      textAlign: TextAlign.start,
                      style: GoogleFonts.inter(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          color: lightColorScheme.onPrimaryContainer
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      "${getFormattedDate(elements.dateTime)} • ${elements.paymentType}",
                      textAlign: TextAlign.start,
                      style: GoogleFonts.inter(
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                          color: lightColorScheme.primary
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      "NRs. ${elements.amount.toString()}",
                      textAlign: TextAlign.start,
                      style: GoogleFonts.inter(
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                          color: Colors.green
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class TransactionListItemElements {
  late double amount;
  late String customerName;
  late String dateTime;
  late String paymentType;

  TransactionListItemElements({Key? key, required this.amount, required this.customerName, required this.dateTime, required this.paymentType});

}

/**
 * 'amount': 2375,
    'customerName': 'HomeChef Cafe',
    'datetime': '2023-07-21T10:27:31.000Z',
    'paymentType': 'CASH'
 */