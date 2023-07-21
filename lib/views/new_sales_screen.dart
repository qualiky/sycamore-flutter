import 'package:com_sandeepgtm_sycamore_mobile/helpers/sales_network_helper.dart';
import 'package:com_sandeepgtm_sycamore_mobile/models/app_data.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../utils/color_schemes.g.dart';
import '../utils/constants.dart';

class NewSalesScreen extends StatefulWidget {

  NewSalesScreen({super.key});

  late TextEditingController salesByEditingController, buyerContactEditingController, buyerIdEditingController;
  late TextEditingController billItemIdEditingController, billUnitPriceEditingController, billQuantityEditingController;
  late AppData appData;
  late SalesNetworkHelper salesNetworkHelper;


  @override
  State<NewSalesScreen> createState() => _NewSalesScreenState();
}

class _NewSalesScreenState extends State<NewSalesScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    widget.salesByEditingController = TextEditingController();
    widget.buyerContactEditingController = TextEditingController();
    widget.buyerIdEditingController = TextEditingController();
    widget.billItemIdEditingController = TextEditingController();
    widget.billUnitPriceEditingController = TextEditingController();
    widget.billQuantityEditingController = TextEditingController();
    widget.appData = Provider.of<AppData>(context);
    widget.salesNetworkHelper = SalesNetworkHelper(context: context, appData: widget.appData);
    widget.appData.createNewSalesOrder();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'New Sales',
          style: appBarTextStyling,
        ),
        elevation: 0,
        backgroundColor: appBackgroundColor,
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
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
                padding: const EdgeInsets.fromLTRB(32, 24, 32, 0),
                child: TextField(
                  keyboardType: TextInputType.text,
                  controller: widget.salesByEditingController,
                  onChanged: (value) {
                    widget.appData.updateSalesByCandidate(value);
                  },
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: lightColorScheme.surfaceVariant,
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 15),
                      hintText: 'Sales: Employee Id',
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
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
                  keyboardType: TextInputType.number,
                  controller: widget.buyerContactEditingController,
                  onChanged: (value) {
                    widget.appData.updateBuyerContact(value);
                  },
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: lightColorScheme.surfaceVariant,
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 15),
                      hintText: 'Buyer Contact Number',
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
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
                  keyboardType: TextInputType.text,
                  controller: widget.buyerIdEditingController,
                  onChanged: (value) {
                    widget.appData.updateBuyerContact(value);
                  },
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: lightColorScheme.surfaceVariant,
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 15),
                      hintText: 'Buyer Contact Number',
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(5),
                            topRight: Radius.circular(5)),
                        borderSide: BorderSide.none,
                      )),
                ),
              ),
              const SizedBox(height: 32,),
              Text(
                'Item Details',
                style: GoogleFonts.inter(
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                    color: lightColorScheme.primary
                ),
              ),
              widget.appData.getSalesRecorderBills().isEmpty ?
                  const Text('No item added in bill so far') :
                  ListView.builder(
                      itemBuilder: (context, index) {
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
                                      widget.appData.getSalesRecorderBills()[index].itemName,
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
                                      "NRs. ${widget.appData.getSalesRecorderBills()[index].itemPrice} x ${widget.appData.getSalesRecorderBills()[index].quantity} units",
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
                                      "NRs. ${widget.appData.getSalesRecorderBills()[index].subTotal}",
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
                  ),
              const SizedBox(height: 32,),

            ],
          ),
        ),
      ),
    );
  }
}
