import 'package:com_sandeepgtm_sycamore_mobile/utils/constants.dart';
import 'package:com_sandeepgtm_sycamore_mobile/views/inventory_screen.dart';
import 'package:com_sandeepgtm_sycamore_mobile/views/sales_screen.dart';
import 'package:com_sandeepgtm_sycamore_mobile/views/setting_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'overview_screen.dart';

class HomeScreen extends StatefulWidget {

  final bool onlineState;

  const HomeScreen({super.key, required this.onlineState});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if(!widget.onlineState) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No internet connection detected. Functionality and contents may be limited.'))
        );
      }
    });
  }

  int _selectedIndex = 0;
  String enteredNoteText = '';

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  String getSelectedTabName(int selectedValue) {
    if (selectedValue == 0) {
      return 'Overview';
    } else if (selectedValue == 1) {
      return 'Sales';
    } else if (selectedValue == 2) {
      return 'Inventory';
    } else {
      return 'Settings';
    }
  }

  Widget getBody(int selectedValue) {
    if (selectedValue == 0) {
      return OverviewScreen();
    } else if (selectedValue == 1) {
      return SalesScreen();
    } else if (selectedValue == 2) {
      return InventoryScreen();
    } else {
      return SettingScreen();
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(
          getSelectedTabName(_selectedIndex),
          style: appBarTextStyling,
        ),
        elevation: 0,
        actions: (_selectedIndex == 2) ? [
          IconButton(
            onPressed: (){
              print("Button pressed!");
            },
            icon: const Icon(
              CupertinoIcons.add,
              color: mainLogoColor,
            ),
          ),
        ] : null,
        backgroundColor: appBackgroundColor,
      ),
      body: getBody(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [homeIcon, salesIcon, inventoryIcons, settingsIcon],
        currentIndex: _selectedIndex,
        selectedIconTheme: selectedIconTheme,
        unselectedIconTheme: deselectedIconTheme,
        selectedFontSize: 0,
        unselectedFontSize: 0,
        onTap: _onItemTapped,
        showSelectedLabels: false,
        showUnselectedLabels: false,
      ),
    );
  }
}

