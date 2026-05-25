class RideCancellationReason {
  int _RideCancellationReason_Id = 0;
  String? _RideCancellationReason_Title;
  String? _RideCancellationReason_Description;

  RideCancellationReason({
    int RideCancellationReason_Id = 0,
    String? RideCancellationReason_Title = '',
    String? RideCancellationReason_Description = '',
  })  : _RideCancellationReason_Id = RideCancellationReason_Id,
        _RideCancellationReason_Title = RideCancellationReason_Title,
        _RideCancellationReason_Description =
            RideCancellationReason_Description;

  Map<String, dynamic> toMap() {
    return {
      'RideCancellationReason_Id': _RideCancellationReason_Id,
      'RideCancellationReason_Title': _RideCancellationReason_Title,
      'RideCancellationReason_Description': _RideCancellationReason_Description,
    };
  }

  // Create Dart object from Map
  factory RideCancellationReason.fromMap(Map<String, dynamic> map) {
    return RideCancellationReason(
        RideCancellationReason_Id: map['RideCancellationReason_Id'] ?? '',
        RideCancellationReason_Title:
            map['RideCancellationReason_Title'] ?? "Unknown",
        RideCancellationReason_Description:
            map['RideCancellationReason_Description'] ?? "91********");
  }

  String get RideCancellationReason_Description =>
      _RideCancellationReason_Description ?? "";

  set RideCancellationReason_Description(String value) {
    _RideCancellationReason_Description = value;
  }

  String get RideCancellationReason_Title =>
      _RideCancellationReason_Title ?? "";

  set RideCancellationReason_Title(String value) {
    _RideCancellationReason_Title = value;
  }

  int get RideCancellationReason_Id => _RideCancellationReason_Id;

  set RideCancellationReason_Id(int value) {
    _RideCancellationReason_Id = value;
  }

  Future<RideCancellationReason> copyWith(
      {int? RideCancellationReason_Id,
      String? RideCancellationReason_Title,
      String? RideCancellationReason_Description}) async {
    return RideCancellationReason(
        RideCancellationReason_Id:
            RideCancellationReason_Id ?? this.RideCancellationReason_Id,
        RideCancellationReason_Title:
            RideCancellationReason_Title ?? this.RideCancellationReason_Title,
        RideCancellationReason_Description:
            RideCancellationReason_Description ??
                this.RideCancellationReason_Description);
  }
}
