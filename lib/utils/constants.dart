import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:country_codes/country_codes.dart';

const String appName = "IGC";


// Colors and styling
const Color splashScreenBackgroundColor = Color(0xFFFFFFFF);
const mainBackgroundOffWhiteColor = Color(0xFFECECFC);
const appBackgroundColor = Color(0xFFFFFFFF);
const mainLogoColor = Color(0xFF002851);
const inactiveBottomIconColor = Color(0xFF999999);
const activeBottomIconColor = Color(0xFF002851);
// const activeBottomIconColor = Color(0xFF617BF3);
const postBodyTextColor = Color(0xFF54719A);
const postTileBgColor = Color(0xFFECECFC);
const inputFieldFillColor = Color(0xFFF6F6FE);
const commentWordColor = Color(0xFF898989);
var toDoDoneColor = const Color(0xFF00AF1B).withOpacity(0.5);
const toDoNotDoneColor = Color(0xFFC90000);

// Text Styling
const mainLogoTextStyling = TextStyle(
  fontFamily: 'Inter',
  fontWeight: FontWeight.normal,
  fontSize: 32,
  color: mainLogoColor,
);

const appBarTextStyling = TextStyle(
  fontFamily: 'Inter',
  fontWeight: FontWeight.bold,
  fontSize: 18,
  color: mainLogoColor,
);

const postTileTitleStyle = TextStyle(
    fontFamily: 'fonts/inter_bold',
    fontWeight: FontWeight.bold,
    fontSize: 18,
    color: mainLogoColor
);

const postTileBodyStyle = TextStyle(
    fontFamily: 'fonts/inter_regular',
    fontWeight: FontWeight.normal,
    fontSize: 16,
    color: postBodyTextColor
);

const byTextStyle = TextStyle(
    fontFamily: 'fonts/inter_light',
    fontWeight: FontWeight.w400,
    fontSize: 16,
    color: activeBottomIconColor
);

const usernameTextStyle = TextStyle(
    fontFamily: 'fonts/inter_regular',
    fontWeight: FontWeight.normal,
    fontSize: 16,
    color: activeBottomIconColor
);

const commentWordStyle = TextStyle(
    fontFamily: 'fonts/inter_regular',
    fontWeight: FontWeight.normal,
    fontSize: 16,
    color: commentWordColor
);

const postDetailTitleStyle = TextStyle(
    fontFamily: 'fonts/inter_semibold',
    fontWeight: FontWeight.w700,
    fontSize: 22,
    color: mainLogoColor
);

const postDetailBodyStyle = TextStyle (
    fontFamily: 'fonts/inter_regular',
    fontWeight: FontWeight.normal,
    fontSize: 20,
    color: postBodyTextColor
);

const commentUsernameStyle = TextStyle(
    fontFamily: 'fonts/inter_medium',
    fontWeight: FontWeight.w600,
    fontSize: 16,
    color: mainLogoColor
);

const commentBodyStyle = TextStyle(
    fontFamily: 'fonts/inter_regular',
    fontWeight: FontWeight.w400,
    fontSize: 15,
    color: postBodyTextColor
);

const userTileTitleStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: mainLogoColor
);

const userTileUserNameStyle = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.normal,
  color: postBodyTextColor,
);

const userDetailNameStyle = TextStyle (
    fontSize: 28,
    fontWeight: FontWeight.w600,
    color: mainLogoColor
);

const userDetailUserNameStyle = TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.normal,
  color: postBodyTextColor,
);

const userDetailDescriptionStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: postBodyTextColor
);

const actionTileActionStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: postBodyTextColor
);

const actionTileDataStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: mainLogoColor
);

const selectedIconTheme = IconThemeData(color: activeBottomIconColor);
const deselectedIconTheme = IconThemeData(color: inactiveBottomIconColor);

// Navigation bar item constants
const homeIcon =
BottomNavigationBarItem(icon: Icon(CupertinoIcons.home), label: 'Overview');
const salesIcon = BottomNavigationBarItem(icon: Icon(CupertinoIcons.graph_circle), label: 'Sales');
const inventoryIcons = BottomNavigationBarItem(icon: Icon(CupertinoIcons.doc_on_clipboard), label: 'Inventory');
const settingsIcon = BottomNavigationBarItem(icon: Icon(CupertinoIcons.settings), label: 'Settings');
const userIcon =
BottomNavigationBarItem(icon: Icon(CupertinoIcons.person), label: 'Users');
const listIcon = BottomNavigationBarItem(
    icon: Icon(CupertinoIcons.list_bullet), label: 'ToDos');
const albumsIcon = BottomNavigationBarItem(
    icon: Icon(CupertinoIcons.photo_on_rectangle), label: 'Albums');


class Country {
  String? name;
  String? code;

  Country(this.name, this.code);

}

List<Country> loadCountryNames() {
  final countryCodes = CountryCodes.countryCodes();
  final countries = <Country>[];

  for(int i = 0; i < countryCodes.length; ++i) {
    final country = Country(
      countryCodes[i]?.name,
      countryCodes[i]?.alpha2Code
    );
    countries.add(country);
  }

  return countries;
}


void showSnackbar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(16.0),
      duration: const Duration(seconds: 2),
    ),
  );
}