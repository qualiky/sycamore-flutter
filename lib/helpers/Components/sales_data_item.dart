import 'package:com_sandeepgtm_sycamore_mobile/helpers/sales_network_helper.dart';
import 'package:com_sandeepgtm_sycamore_mobile/utils/color_schemes.g.dart';
import 'package:com_sandeepgtm_sycamore_mobile/views/sales_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../models/app_data.dart';
import '../../utils/constants.dart';

class SalesDataItem extends StatelessWidget {

  late SalesRecordData data;
  late SalesNetworkHelper networkHelper;
  late AppData appData;
  late BuildContext context;

  SalesDataItem({super.key, required this.data, required this.networkHelper, required this.context}){
    appData = Provider.of<AppData>(context);
  }

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
    bool didLoadData;
    return GestureDetector(
      onTap: () async => {
        didLoadData = await networkHelper.getIndividualSalesRecord(data.salesId),
        didLoadData && appData.getIndividualSalesData != null ? Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SalesDetailScreen(individualSalesRecord: appData.getIndividualSalesData!)
            ),
        ) : context.mounted ? showSnackbar(context, 'Data not available') : null
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: SizedBox(
          height: 100,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: lightColorScheme.primaryContainer.withOpacity(0.3),
              border: Border.all(
                color: lightColorScheme.onPrimaryContainer,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
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
                            "NRs. ${data.paidAmount.toString()}",
                            textAlign: TextAlign.start,
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: Colors.green
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
                          child: Text(
                            "${getFormattedDate(data.salesDate)} • ${data.paymentMethod}",
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
                          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
                          child: Icon(
                            Icons.arrow_forward_ios,
                            color: lightColorScheme.onPrimaryContainer,
                            semanticLabel: 'View More',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    "Receipt ${data.receiptNumber} • ${data.remarks}",
                    textAlign: TextAlign.start,
                    style: GoogleFonts.inter(
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                        color: lightColorScheme.onPrimaryContainer
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

