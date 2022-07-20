class User {
  int _useId;
  String _fullName;
  String _address;
  String _phoneNumber;
  String _emailAddress;

  User(this._useId, this._fullName, this._address, this._phoneNumber,
      this._emailAddress);

  int getUserID() {
    return _useId;
  }

  String getFullName() {
    return _fullName;
  }

  String getAddress() {
    return _address;
  }

  String getPhoneNumber() {
    return _phoneNumber;
  }

  String getEmail() {
    return _emailAddress;
  }

  void setUserId(int userId) {
    _useId = userId;
  }

  void setFullName(String fullName) {
    _fullName = fullName;
  }

  void setAddress(String address) {
    _address = address;
  }

  void setPhoneNumber(String phoneNum) {
    _phoneNumber = phoneNum;
  }

  void setEmailAddress(String emailAddress) {
    _emailAddress = emailAddress;
  }
}
