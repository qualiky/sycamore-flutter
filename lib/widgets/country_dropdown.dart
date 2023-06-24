import 'package:flutter/material.dart';
import 'package:country_codes/country_codes.dart';

import '../utils/color_schemes.g.dart';
import '../utils/constants.dart';

class CountryDropdown extends StatefulWidget {

  CountryDropdown({
    super.key,
    required this.selectedCountry
  });

  Country selectedCountry;

  @override
  _CountryDropdownState createState() => _CountryDropdownState();
}

class _CountryDropdownState extends State<CountryDropdown> {
  final List<Country> _countries = [];


  @override
  void initState() {
    super.initState();
    _loadCountries();
  }

  void _loadCountries() async {
    var prevCountries = await CountryCodes.countryCodes();
    print("ARRAY LENGTH: ${prevCountries.length}");
    for(CountryDetails? countryDetails in prevCountries) {
      if(countryDetails != null) {
        print("Country name: ${countryDetails.name}");
        _countries.add(
          Country(countryDetails.name, countryDetails.alpha2Code)
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<Country>(
      decoration: InputDecoration(
          filled: true,
          fillColor: lightColorScheme.surfaceVariant,
          contentPadding: const EdgeInsets.symmetric(
              vertical: 20, horizontal: 15),
          hintText: 'Last Name',
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(5),
                topRight: Radius.circular(5)),
            borderSide: BorderSide.none,
          )
      ),
      value: widget.selectedCountry,
      items: _countries.map((Country country) {
        return DropdownMenuItem<Country>(
          value: country,
          child: Text('${country.name}: (${country.code})'),
        );
      }).toList(),
      onChanged: (Country? newValue) {
        setState(() {
          // Handle the selected country
          if(newValue != null) {
            widget.selectedCountry = newValue;
          }
        });
      },
    );
  }
}
