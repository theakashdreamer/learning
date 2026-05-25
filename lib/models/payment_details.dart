import 'dart:core';

class PaymentDetails {
  int? _RidesPaymentDetails_Id;
  int? _Ride_Id;
  int? _Driver_Id;
  int? _Passenger_Id;
  double? _BaseFare;
  double? _DistanceFare;
  double? _TimeFare;
  double? _SurgeCharge;
  double? _Discount;
  double? _TaxAmount;
  double? _TotalAmount;
  double? _PaidAmount;
  int? _PaymentMethod_Id;
  int? _PaymentStatus_Id;
  String? _Transaction_Id;

  PaymentDetails();

  PaymentDetails.name(
      this._RidesPaymentDetails_Id,
      this._Ride_Id,
      this._Driver_Id,
      this._Passenger_Id,
      this._BaseFare,
      this._DistanceFare,
      this._TimeFare,
      this._SurgeCharge,
      this._Discount,
      this._TaxAmount,
      this._TotalAmount,
      this._PaidAmount,
      this._PaymentMethod_Id,
      this._PaymentStatus_Id,
      this._Transaction_Id);

  Map<String, dynamic> toMap() {
    return {
      'RidesPaymentDetails_Id': this._RidesPaymentDetails_Id,
      'Ride_Id': this._Ride_Id,
      'Driver_Id': this._Driver_Id,
      'Passenger_Id': this._Passenger_Id,
      'BaseFare': this._BaseFare,
      'DistanceFare': this._DistanceFare,
      'TimeFare': this._TimeFare,
      'SurgeCharge': this._SurgeCharge,
      'Discount': this._Discount,
      'TaxAmount': this._TaxAmount,
      'TotalAmount': this._TotalAmount,
      'PaidAmount': this._PaidAmount,
      'PaymentMethod_Id': this._PaymentMethod_Id,
      'PaymentStatus_Id': this._PaymentStatus_Id,
      'Transaction_Id': this._Transaction_Id,
    };
  }

  factory PaymentDetails.fromMap(Map<String, dynamic> map) {
    return PaymentDetails.name(
      map['RidesPaymentDetails_Id'] ??0.0,
      map['Ride_Id'] ?? 0,
      map['Driver_Id'] ?? 0,
      map['Passenger_Id'] ?? 0,
      map['BaseFare'] ?? 0.0,
      map['DistanceFare'] ?? 0.0,
      map['TimeFare'] ?? 0.0,
      map['SurgeCharge'] ?? 0.0,
      map['Discount'] ?? 0.0,
      map['TaxAmount'] ?? 0.0,
      map['TotalAmount'] ?? 0.0,
      map['PaidAmount'] ?? 0.0,
      map['PaymentMethod_Id'] ?? 0,
      map['PaymentStatus_Id'] ?? 0,
      map['Transaction_Id'] ?? "",
    );
  }

  String get Transaction_Id => _Transaction_Id ?? "";

  set Transaction_Id(String value) {
    _Transaction_Id = value;
  }

  int get PaymentStatus_Id => _PaymentStatus_Id ?? 0;

  set PaymentStatus_Id(int value) {
    _PaymentStatus_Id = value;
  }

  int get PaymentMethod_Id => _PaymentMethod_Id ?? 0;

  set PaymentMethod_Id(int value) {
    _PaymentMethod_Id = value;
  }

  double get PaidAmount => _PaidAmount ?? 0.0;

  set PaidAmount(double value) {
    _PaidAmount = value;
  }

  double get TotalAmount => _TotalAmount ?? 0.0;

  set TotalAmount(double value) {
    _TotalAmount = value;
  }

  double get TaxAmount => _TaxAmount ?? 0.0;

  set TaxAmount(double value) {
    _TaxAmount = value;
  }

  double get SurgeCharge => _SurgeCharge ?? 0.0;

  set SurgeCharge(double value) {
    _SurgeCharge = value;
  }

  double get TimeFare => _TimeFare ?? 0.0;

  set TimeFare(double value) {
    _TimeFare = value;
  }

  double get DistanceFare => _DistanceFare ?? 0.0;

  set DistanceFare(double value) {
    _DistanceFare = value;
  }

  double get BaseFare => _BaseFare ?? 0.0;

  set BaseFare(double value) {
    _BaseFare = value;
  }

  int get Passenger_Id => _Passenger_Id ?? 0;

  set Passenger_Id(int value) {
    _Passenger_Id = value;
  }

  int get RidesPaymentDetails_Id => _RidesPaymentDetails_Id ?? 0;

  set RidesPaymentDetails_Id(int value) {
    _RidesPaymentDetails_Id = value;
  }

  int get Ride_Id => _Ride_Id ?? 0;

  set Ride_Id(int value) {
    _Ride_Id = value;
  }

  PaymentDetails copyWith(
      {int? RidesPaymentDetails_Id,
      int? Ride_Id,
      int? Driver_Id,
      int? Passenger_Id,
      double? BaseFare,
      double? DistanceFare,
      double? TimeFare,
      double? SurgeCharge,
      double? Discount,
      double? TaxAmount,
      double? TotalAmount,
      double? PaidAmount,
      int? PaymentMethod_Id,
      int? PaymentStatus_Id,
      String? Transaction_Id}) {
    return PaymentDetails.name(
        RidesPaymentDetails_Id ?? this.RidesPaymentDetails_Id,
        Ride_Id ?? this.Ride_Id,
        Driver_Id ?? this.Driver_Id,
        Passenger_Id ?? this.Passenger_Id,
        BaseFare ?? this.BaseFare,
        DistanceFare ?? this.DistanceFare,
        TimeFare ?? this.TimeFare,
        SurgeCharge ?? this.SurgeCharge,
        Discount ?? this.Discount,
        TaxAmount ?? this.TaxAmount,
        TotalAmount ?? this.TotalAmount,
        PaidAmount ?? this.PaidAmount,
        PaymentMethod_Id ?? this.PaymentMethod_Id,
        PaymentStatus_Id ?? this.PaymentStatus_Id,
        Transaction_Id ?? this.Transaction_Id);
  }

  int get Driver_Id => _Driver_Id ?? 0;

  set Driver_Id(int value) {
    _Driver_Id = value;
  }

  double get Discount => _Discount ?? 0.0;

  set Discount(double value) {
    _Discount = value;
  }
}
