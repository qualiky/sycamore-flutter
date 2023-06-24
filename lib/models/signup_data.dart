class SignupData {
  late String _email;
  late String _phoneNumber;
  late String _countryCode;
  late String _password;
  late String _repeatPassword;
  late String _firstName;
  late String _lastName;

  SignupData();

  SignupData.all(this._email, this._phoneNumber, this._countryCode,
      this._password, this._repeatPassword, this._firstName, this._lastName);

  String get lastName => _lastName;

  set lastName(String value) {
    _lastName = value;
  }

  String get firstName => _firstName;

  set firstName(String value) {
    _firstName = value;
  }

  String get repeatPassword => _repeatPassword;

  set repeatPassword(String value) {
    _repeatPassword = value;
  }

  String get password => _password;

  set password(String value) {
    _password = value;
  }

  String get countryCode => _countryCode;

  set countryCode(String value) {
    _countryCode = value;
  }

  String get phoneNumber => _phoneNumber;

  set phoneNumber(String value) {
    _phoneNumber = value;
  }

  String get email => _email;

  set email(String value) {
    _email = value;
  }
}