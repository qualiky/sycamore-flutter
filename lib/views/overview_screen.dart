import 'package:com_sandeepgtm_sycamore_mobile/helpers/Components/AnimatedBarGraphSalesData.dart';
import 'package:com_sandeepgtm_sycamore_mobile/helpers/Components/square_button.dart';
import 'package:com_sandeepgtm_sycamore_mobile/helpers/Components/transaction_detail_list.dart';
import 'package:com_sandeepgtm_sycamore_mobile/helpers/home_network_helper.dart';
import 'package:com_sandeepgtm_sycamore_mobile/models/app_data.dart';
import 'package:com_sandeepgtm_sycamore_mobile/utils/color_schemes.g.dart';
import 'package:com_sandeepgtm_sycamore_mobile/views/home_screen.dart';
import 'package:com_sandeepgtm_sycamore_mobile/views/sales_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'new_sales_screen.dart';

class OverviewScreen extends StatefulWidget {

  late AppData appData;
  late HomeNetworkHelper homeNetworkHelper;

  List<SquareButtonElements> elemButton = [
    SquareButtonElements(
        backgroundColor: lightColorScheme.secondaryContainer,
        iconColor: lightColorScheme.onPrimaryContainer,
        icon: Icons.add,
        label: 'New Sales',
        route: NewSalesScreen()
    ),
    SquareButtonElements(
        backgroundColor: lightColorScheme.secondaryContainer,
        iconColor: lightColorScheme.onPrimaryContainer,
        icon: Icons.history,
        label: 'Past Sales',
        route: SalesScreen()
    ),
    SquareButtonElements(
        backgroundColor: lightColorScheme.secondaryContainer,
        iconColor: lightColorScheme.onPrimaryContainer,
        icon: Icons.list_outlined,
        label: 'Inventory',
        route: HomeScreen(onlineState: true,)
    ),
    SquareButtonElements(
        backgroundColor: lightColorScheme.secondaryContainer,
        iconColor: lightColorScheme.onPrimaryContainer,
        icon: Icons.person_2_outlined,
        label: 'Customers',
        route: HomeScreen(onlineState: true,)
    ),
    SquareButtonElements(
        backgroundColor: lightColorScheme.secondaryContainer,
        iconColor: lightColorScheme.onPrimaryContainer,
        icon: Icons.emoji_transportation,
        label: 'Suppliers',
        route: HomeScreen(onlineState: true,)
    ),
    SquareButtonElements(
        backgroundColor: lightColorScheme.secondaryContainer,
        iconColor: lightColorScheme.onPrimaryContainer,
        icon: Icons.insights,
        label: 'Team Stats',
        route: HomeScreen(onlineState: true,)
    ),
  ];

  @override
  State<OverviewScreen> createState() => _OverviewScreenState();
}

class _OverviewScreenState extends State<OverviewScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget.appData = Provider.of<AppData>(context);
    widget.homeNetworkHelper = HomeNetworkHelper(context: context, appData: widget.appData);

    widget.homeNetworkHelper.removeOldSalesData();
    widget.homeNetworkHelper.getLastSevenDaySales();


  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: lightColorScheme.inversePrimary,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 30, 20, 5),
                child: Column(
                  children: [
                    Text(
                      "Sales Figure: Last 7 days",
                      textAlign: TextAlign.start,
                      style: GoogleFonts.inter(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          color: lightColorScheme.primary
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 30,),
                        // AspectRatio(
                        //   aspectRatio: 1.4,
                        //   child: _LastSevenDaysBarChart(context: context),
                        // ),
                        SevenDaysSalesDataBarGraph(salesData: widget.appData.get7DaySales),

                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              child: GridView.builder(
                shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16
                  ),
                  itemCount: widget.elemButton.length,
                  itemBuilder: (context, index) {
                    return SquareButton(elements: widget.elemButton[index]);
                  }
              ),
            ),
            const SizedBox(
              height: 4,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                "Transaction Overview",
                textAlign: TextAlign.start,
                style: GoogleFonts.inter(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: lightColorScheme.primary
                ),
              ),
            ),
            TransactionDetailList()
          ],
        ),
      ),
    );
  }
}


