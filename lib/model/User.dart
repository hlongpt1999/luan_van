class UserModel{
  String _id;
  String _name;
  String _sex;
  double _birthday;
  int _bornYear;
  double _height;
  double _weight;
  String _address;
  String _role;
  String _avatar;
  String _email;
  String _phone;
  String _password;

  UserModel(
      this._id,
      this._name,
      this._sex,
      this._birthday,
      this._bornYear,
      this._height,
      this._weight,
      this._address,
      this._role,
      this._avatar,
      this._email,
      this._phone,
      this._password);

  String get password => _password;

  set password(String value) {
    _password = value;
  }

  String get phone => _phone;

  set phone(String value) {
    _phone = value;
  }

  String get email => _email;

  set email(String value) {
    _email = value;
  }

  String get avatar => _avatar;

  set avatar(String value) {
    _avatar = value;
  }

  String get role => _role;

  set role(String value) {
    _role = value;
  }

  String get address => _address;

  set address(String value) {
    _address = value;
  }

  double get weight => _weight;

  set weight(double value) {
    _weight = value;
  }

  double get height => _height;

  set height(double value) {
    _height = value;
  }

  int get bornYear => _bornYear;

  set bornYear(int value) {
    _bornYear = value;
  }

  double get birthday => _birthday;

  set birthday(double value) {
    _birthday = value;
  }

  String get sex => _sex;

  set sex(String value) {
    _sex = value;
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  String get id => _id;

  set id(String value) {
    _id = value;
  }
}