import '../loginModules/entity/UserDetails.dart';

class User {
  String _name;
  String _mobileNumber;
  String _photoUrl;

  User({
    String name = '',
    String mobileNumber = '',
    String photoUrl = '',
  })  : _name = name,
        _mobileNumber = mobileNumber,
        _photoUrl = photoUrl;

  // Getters and setters
  String get name => _name;
  set name(String value) => _name = value;

  String get mobileNumber => _mobileNumber;
  set mobileNumber(String value) => _mobileNumber = value;

  String get photoUrl => _photoUrl;
  set photoUrl(String value) => _photoUrl = value;
}
