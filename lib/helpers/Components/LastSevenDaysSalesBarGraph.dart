
import 'package:com_sandeepgtm_sycamore_mobile/models/app_data.dart';
import 'package:com_sandeepgtm_sycamore_mobile/models/home_screen_data.dart';
import 'package:com_sandeepgtm_sycamore_mobile/utils/color_schemes.g.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class _LastSevenDaysBarChart extends StatelessWidget {
  late BuildContext context;

  _LastSevenDaysBarChart({required this.context});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppData>(builder: (context, appData, child) {
      return BarChart(
        BarChartData(
          barTouchData: barTouchData,
          titlesData: titlesData,
          borderData: borderData,
          barGroups: getBarGroupData(),
          gridData: FlGridData(show: false),
          alignment: BarChartAlignment.spaceAround,
          maxY: 50000,
        ),
      );
    });
  }

  BarTouchData get barTouchData => BarTouchData(
    enabled: false,
    touchTooltipData: BarTouchTooltipData(
      tooltipBgColor: Colors.transparent,
      tooltipPadding: EdgeInsets.zero,
      tooltipMargin: 8,
      getTooltipItem: (
          BarChartGroupData group,
          int groupIndex,
          BarChartRodData rod,
          int rodIndex,
          ) {
        return BarTooltipItem(
          rod.toY.round().toString(),
          TextStyle(
            color: lightColorScheme.onPrimaryContainer,
            fontWeight: FontWeight.bold,
          ),
        );
      },
    ),
  );

  Widget getTitles(double value, TitleMeta meta) {

    final appData = Provider.of<AppData>(context);

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 4,
      child: Text(
        // appData.get7DaySales[value.toInt()].date,
        appData.get7DaySales[value.toInt()].date,
        style: GoogleFonts.inter(
            fontWeight: FontWeight.w400,
            fontSize: 14,
            color: lightColorScheme.onPrimaryContainer),
      ),
    );
  }

  FlTitlesData get titlesData => FlTitlesData(
    show: true,
    bottomTitles: AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        reservedSize: 100,
        getTitlesWidget: getTitles,
      ),
    ),
    leftTitles: AxisTitles(
      sideTitles: SideTitles(showTitles: false),
    ),
    topTitles: AxisTitles(
      sideTitles: SideTitles(showTitles: false),
    ),
    rightTitles: AxisTitles(
      sideTitles: SideTitles(showTitles: false),
    ),
  );

  FlBorderData get borderData => FlBorderData(show: false,);

  LinearGradient get _barsGradient => LinearGradient(
    colors: [
      lightColorScheme.primaryContainer,
      lightColorScheme.onPrimaryContainer
    ],
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
  );


  List<BarChartGroupData> getBarGroupData() {
    List<BarChartGroupData> chartGroup = [];

    final appData = Provider.of<AppData>(context, listen: true);
    final salesDataList = appData.get7DaySales;

    print("LENGTH OF SALES DATA: ${appData.get7DaySalesCount}");

    int count = 0;
    for (SalesData salesData in salesDataList) {
      chartGroup.add(
        BarChartGroupData(
          x: count,
          barRods: [
            BarChartRodData(
                toY: salesData.amount,
                gradient: _barsGradient
            ),
          ],
          showingTooltipIndicators: [0],
        ),
      );
    }

    return chartGroup;
  }

}