import 'package:com_sandeepgtm_sycamore_mobile/helpers/sales_network_helper.dart';
import 'package:com_sandeepgtm_sycamore_mobile/utils/color_schemes.g.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/constants.dart';

class SalesDetailScreen extends StatefulWidget {

  late IndividualSalesRecord individualSalesRecord;
  SalesDetailScreen({super.key, required this.individualSalesRecord});

  @override
  State<SalesDetailScreen> createState() => _SalesDetailScreenState();
}

class _SalesDetailScreenState extends State<SalesDetailScreen> {

  Widget getBillItems(BillRecordDetails billRecordDetail) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
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
                      billRecordDetail.itemName,
                      textAlign: TextAlign.start,
                      style: GoogleFonts.inter(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          color: lightColorScheme.onPrimaryContainer
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 1.0),
                    child: Text(
                      " NRS. ${billRecordDetail.itemPrice}/unit x ${billRecordDetail.quantity} units",
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
                      "NRs. ${billRecordDetail.subTotal}",
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Receipt number ${widget.individualSalesRecord.salesRecordData.receiptNumber}',
          style: appBarTextStyling,
        ),
        elevation: 0,
        backgroundColor: appBackgroundColor,
      ),
      body: SingleChildScrollView(
        child: Container(
          color: lightColorScheme.background,
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Column(
                  children: [
                    Text(
                        'Sales Details',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                        color: lightColorScheme.primary
                      ),
                    ),
                    const SizedBox(height: 16,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Sales Reference Id',
                            style: GoogleFonts.inter(
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                                color: lightColorScheme.primary
                            ),
                          ),
                          Text(
                            '${widget.individualSalesRecord.salesRecordData.receiptNumber}',
                            style: GoogleFonts.inter(
                                fontWeight: FontWeight.w800,
                                fontSize: 12,
                                color: lightColorScheme.onPrimaryContainer
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Sales Date',
                            style: GoogleFonts.inter(
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                                color: lightColorScheme.primary
                            ),
                          ),
                          Text(
                            widget.individualSalesRecord.salesRecordData.salesDate,
                            style: GoogleFonts.inter(
                                fontWeight: FontWeight.w800,
                                fontSize: 12,
                                color: lightColorScheme.onPrimaryContainer
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Sold By',
                            style: GoogleFonts.inter(
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                                color: lightColorScheme.primary
                            ),
                          ),
                          Text(
                            'Owner',
                            style: GoogleFonts.inter(
                                fontWeight: FontWeight.w800,
                                fontSize: 12,
                                color: lightColorScheme.onPrimaryContainer
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Buyer Contact',
                            style: GoogleFonts.inter(
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                                color: lightColorScheme.primary
                            ),
                          ),
                          Text(
                            widget.individualSalesRecord.salesRecordData.buyerContact ?? 'User not registered',
                            style: GoogleFonts.inter(
                                fontWeight: FontWeight.w800,
                                fontSize: 12,
                                color: lightColorScheme.onPrimaryContainer
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32,),
                    Text(
                      'Payment Details',
                      style: GoogleFonts.inter(
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                          color: lightColorScheme.primary
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Subtotal Amount',
                            style: GoogleFonts.inter(
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                                color: lightColorScheme.primary
                            ),
                          ),
                          Text(
                            'NRs. ${widget.individualSalesRecord.paymentDetails.subtotalAmount}',
                            style: GoogleFonts.inter(
                                fontWeight: FontWeight.w800,
                                fontSize: 12,
                                color: lightColorScheme.onPrimaryContainer
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Discount Percentage',
                            style: GoogleFonts.inter(
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                                color: lightColorScheme.primary
                            ),
                          ),
                          Text(
                            '${widget.individualSalesRecord.paymentDetails.discountPercentage} %',
                            style: GoogleFonts.inter(
                                fontWeight: FontWeight.w800,
                                fontSize: 12,
                                color: lightColorScheme.onPrimaryContainer
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Pre-VAT Amount',
                            style: GoogleFonts.inter(
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                                color: lightColorScheme.primary
                            ),
                          ),
                          Text(
                            'NRs. ${widget.individualSalesRecord.paymentDetails.beforeVATAmount}',
                            style: GoogleFonts.inter(
                                fontWeight: FontWeight.w800,
                                fontSize: 12,
                                color: lightColorScheme.onPrimaryContainer
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'VAT Percentage',
                            style: GoogleFonts.inter(
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                                color: lightColorScheme.primary
                            ),
                          ),
                          Text(
                            '${widget.individualSalesRecord.paymentDetails.vatPercentage}%',
                            style: GoogleFonts.inter(
                                fontWeight: FontWeight.w800,
                                fontSize: 12,
                                color: lightColorScheme.onPrimaryContainer
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Final Amount',
                            style: GoogleFonts.inter(
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                                color: lightColorScheme.primary
                            ),
                          ),
                          Text(
                            'NRs. ${widget.individualSalesRecord.paymentDetails.finalAmount}',
                            style: GoogleFonts.inter(
                                fontWeight: FontWeight.w800,
                                fontSize: 12,
                                color: lightColorScheme.onPrimaryContainer
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Remarks',
                            style: GoogleFonts.inter(
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                                color: lightColorScheme.primary
                            ),
                          ),
                          Text(
                            '${widget.individualSalesRecord.paymentDetails.remarks}',
                            style: GoogleFonts.inter(
                                fontWeight: FontWeight.w800,
                                fontSize: 12,
                                color: lightColorScheme.onPrimaryContainer
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Paid Amount',
                            style: GoogleFonts.inter(
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                                color: lightColorScheme.primary
                            ),
                          ),
                          Text(
                            'NRs. ${widget.individualSalesRecord.paymentDetails.paidAmount}',
                            style: GoogleFonts.inter(
                                fontWeight: FontWeight.w800,
                                fontSize: 12,
                                color: lightColorScheme.onPrimaryContainer
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Payment Method',
                            style: GoogleFonts.inter(
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                                color: lightColorScheme.primary
                            ),
                          ),
                          Text(
                            widget.individualSalesRecord.paymentDetails.paymentMethod.name,
                            style: GoogleFonts.inter(
                                fontWeight: FontWeight.w800,
                                fontSize: 12,
                                color: lightColorScheme.onPrimaryContainer
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            '${widget.individualSalesRecord.paymentDetails.paymentMethod.name} Transaction Id',
                            style: GoogleFonts.inter(
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                                color: lightColorScheme.primary
                            ),
                          ),
                          Text(
                            widget.individualSalesRecord.paymentDetails.transactionGatewayId,
                            style: GoogleFonts.inter(
                                fontWeight: FontWeight.w800,
                                fontSize: 12,
                                color: lightColorScheme.onPrimaryContainer
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Amount Due',
                            style: GoogleFonts.inter(
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                                color: lightColorScheme.primary
                            ),
                          ),
                          Text(
                            'NRs. ${widget.individualSalesRecord.paymentDetails.dueAmount}',
                            style: GoogleFonts.inter(
                                fontWeight: FontWeight.w800,
                                fontSize: 12,
                                color: lightColorScheme.onPrimaryContainer
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32,),
                    Text(
                      'Bill Items',
                      style: GoogleFonts.inter(
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                          color: lightColorScheme.primary
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                        itemCount: widget.individualSalesRecord.billItemCount,
                        itemBuilder: (context, index) {
                          return getBillItems(widget.individualSalesRecord.billRecordDetails[index]);
                        }
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
