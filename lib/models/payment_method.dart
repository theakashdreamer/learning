import 'package:equatable/equatable.dart';

class PaymentMethod extends Equatable {
  String _id;
  String _title;
  String _icon;
  String _description;

  PaymentMethod({
    String id = '',
    String title = '',
    String icon = '',
    String description = '',
  })  : _id = id,
        _title = title,
        _icon = icon,
        _description = description;

  // Getters and setters
  String get id => _id;

  set id(String value) => _id = value;

  String get title => _title;

  set title(String value) => _title = value;

  String get icon => _icon;

  set icon(String value) => _icon = value;

  String get description => _description;

  set description(String value) => _description = value;

  @override
  List<Object> get props => [_id, _title, _icon, _description];

  Map<String, dynamic> toMap() {
    return {
      'id': this._id,
      'title': this._title,
      'icon': this._icon,
      'description': this._description,
    };
  }

  factory PaymentMethod.fromMap(Map<String, dynamic> map) {
    return PaymentMethod(
      id: map['id'] as String,
      title: map['title']??"",
      icon: map['icon']??"",
      description: map['description']??"",
    );
  }
}
