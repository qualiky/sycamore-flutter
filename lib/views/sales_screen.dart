import 'package:com_sandeepgtm_sycamore_mobile/helpers/Components/sales_data_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../helpers/sales_network_helper.dart';
import '../models/app_data.dart';

class SalesScreen extends StatefulWidget {
  late AppData appData;
  late SalesNetworkHelper salesNetworkHelper;
  late bool didLoadCorrectly;

  @override
  State<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
  @override
  void initState() {
    super.initState();
    widget.didLoadCorrectly = false;
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    widget.appData = Provider.of<AppData>(context);
    widget.salesNetworkHelper =
        SalesNetworkHelper(context: context, appData: widget.appData);
    widget.salesNetworkHelper.removeOldSalesRecordData();
    await widget.salesNetworkHelper.getSalesRecords();
    setState(() {
      widget.didLoadCorrectly = true;
    });
  }

  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(
      child: Center(
        child: !widget.didLoadCorrectly
            ? const Text('Loading'):
              Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListView.builder(
                        shrinkWrap: true,
                        itemCount: widget.appData.getSalesRecordDataCount,
                        itemBuilder: (context, index) {
                          return SalesDataItem(data: widget.appData.getSalesRecordData[index], networkHelper: widget.salesNetworkHelper, context: context,);
                        }
                    )
                  ]
              ),
      ),
    );
  }
}
