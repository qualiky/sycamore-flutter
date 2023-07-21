import 'package:com_sandeepgtm_sycamore_mobile/helpers/Components/transaction_list_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/app_data.dart';
import '../home_network_helper.dart';

class TransactionDetailList extends StatefulWidget {
  
  late List<TransactionListItemElements> txList;
  late AppData appData;
  late HomeNetworkHelper networkHelper;
  
  TransactionDetailList({super.key});

  @override
  State<TransactionDetailList> createState() => _TransactionDetailListState();
}

class _TransactionDetailListState extends State<TransactionDetailList> {

  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // TODO: Network call to get transactions
    widget.appData = Provider.of<AppData>(context);
    widget.networkHelper = HomeNetworkHelper(context: context, appData: widget.appData);
    widget.appData.removeAllTransactionData();
    widget.networkHelper.getLastNTransactions();
  }
  
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
        itemCount: widget.appData.getTransactionDataCount,
        itemBuilder: (context, index) {
          return TransactionListItem(elements: widget.appData.getTransactionData[index]);
        }
    );
  }
}
