class GetAllRidesForDriverAndPassenger {
  int? _Ride_Id;
  int? _AM_TypeId;
  String? _AM_TypeName;
  String? _Start_Lat;
  String? _Start_Long;
  String? _End_Lat;
  String? _End_Long;
  String? _Start_Location;
  String? _End_Location;
  int? _NumberOfPerson;
  String? _Distance;
  int? _PaymentMethod_Id;
  String? _Method_Name;
  String? _Fare;
  int? _Status_Id;
  String? _Status_Title;
  String? _Scheduled_Time;
  int? _PaymentStatus_Id;
  String? _PaymentStatus_Title;
  int? _RideCancellationReason_Id;
  String? _RideCancellationReason_Title;
  int? _Driver_Id;
  String? _Driver_Name;
  int? _Passenger_Id;
  String? _Passenger_Name;
  double _Rating_Points;

  GetAllRidesForDriverAndPassenger.name(
      this._Ride_Id,
      this._AM_TypeId,
      this._AM_TypeName,
      this._Start_Lat,
      this._Start_Long,
      this._End_Lat,
      this._End_Long,
      this._Start_Location,
      this._End_Location,
      this._NumberOfPerson,
      this._Distance,
      this._PaymentMethod_Id,
      this._Method_Name,
      this._Fare,
      this._Status_Id,
      this._Status_Title,
      this._Scheduled_Time,
      this._PaymentStatus_Id,
      this._PaymentStatus_Title,
      this._RideCancellationReason_Id,
      this._RideCancellationReason_Title,
      this._Driver_Id,
      this._Driver_Name,
      this._Passenger_Id,
      this._Passenger_Name,
      this._Rating_Points,
      );
  Map<String, dynamic> toMap() {
    return {
      'Ride_Id': this._Ride_Id,
      'AM_TypeId': this._AM_TypeId,
      'AM_TypeName': this._AM_TypeName,
      'Start_Lat': this._Start_Lat,
      'Start_Long': this._Start_Long,
      'End_Lat': this._End_Lat,
      'End_Long': this._End_Long,
      'Start_Location': this._Start_Location,
      'End_Location': this._End_Location,
      'NumberOfPerson': this._NumberOfPerson,
      'Distance': this._Distance,
      'PaymentMethod_Id': this._PaymentMethod_Id,
      'Method_Name': this._Method_Name,
      'Fare': this._Fare,
      'Status_Id': this._Status_Id,
      'Status_Title': this._Status_Title,
      'Scheduled_Time': this._Scheduled_Time,
      'PaymentStatus_Id': this._PaymentStatus_Id,
      'PaymentStatus_Title': this._PaymentStatus_Title,
      'RideCancellationReason_Id': this._RideCancellationReason_Id,
      'RideCancellationReason_Title': this._RideCancellationReason_Title,
      'Driver_Id': this._Driver_Id,
      'Driver_Name': this._Driver_Name,
      'Passenger_Id': this._Passenger_Id,
      'Passenger_Name': this._Passenger_Name,
      'Rating_Points': this._Rating_Points,
    };
  }

  factory GetAllRidesForDriverAndPassenger.fromMap(Map<String, dynamic> map) {
    return GetAllRidesForDriverAndPassenger.name(
        map['Ride_Id'] ?? "",
        map['AM_TypeId'] ?? 0,
        map['AM_TypeName'] ?? 0,
        map['Start_Lat'] ?? 0,
        map['Start_Long'] ?? 0.0,
        map['End_Lat'] ?? 0.0,
        map['End_Long'] ?? 0.0,
        map['Start_Location'] ?? 0.0,
        map['End_Location'] ?? 0.0,
        map['NumberOfPerson'] ?? 0.0,
        map['Distance'] ?? 0.0,
        map['PaymentMethod_Id'] ?? 0.0,
        map['Method_Name'] ?? 0,
        map['Fare'] ?? 0,
        map['Status_Id'] ?? "",
        map['Status_Title'] ?? 0,
        map['Scheduled_Time'] ?? 0,
        map['PaymentStatus_Id'] ?? 0.0,
        map['PaymentStatus_Title'] ?? 0.0,
        map['RideCancellationReason_Id'] ?? 0.0,
        map['RideCancellationReason_Title'] ?? 0.0,
        map['Driver_Id'] ?? 0.0,
        map['Driver_Name'] ?? 0.0,
        map['Passenger_Id'] ?? 0.0,
        map['Passenger_Name'] ?? 0.0,
        map['Rating_Points'] ?? 0.0
    );
  }

  String get Passenger_Name => _Passenger_Name??"";

  set Passenger_Name(String value) {
    _Passenger_Name = value;
  }

  int get Passenger_Id => _Passenger_Id??0;

  set Passenger_Id(int value) {
    _Passenger_Id = value;
  }

  String get Driver_Name => _Driver_Name??"";

  set Driver_Name(String value) {
    _Driver_Name = value;
  }

  int get Driver_Id => _Driver_Id??0;

  set Driver_Id(int value) {
    _Driver_Id = value;
  }

  String get RideCancellationReason_Title => _RideCancellationReason_Title??"";

  set RideCancellationReason_Title(String value) {
    _RideCancellationReason_Title = value;
  }

  int get RideCancellationReason_Id => _RideCancellationReason_Id??0;

  set RideCancellationReason_Id(int value) {
    _RideCancellationReason_Id = value;
  }

  String get PaymentStatus_Title => _PaymentStatus_Title??"";

  set PaymentStatus_Title(String value) {
    _PaymentStatus_Title = value;
  }

  int get PaymentStatus_Id => _PaymentStatus_Id??0;

  set PaymentStatus_Id(int value) {
    _PaymentStatus_Id = value;
  }

  String get Scheduled_Time => _Scheduled_Time??"";

  set Scheduled_Time(String value) {
    _Scheduled_Time = value;
  }

  String get Status_Title => _Status_Title??"";

  set Status_Title(String value) {
    _Status_Title = value;
  }

  int get Status_Id => _Status_Id??0;

  set Status_Id(int value) {
    _Status_Id = value;
  }

  String get Fare => _Fare??"";

  set Fare(String value) {
    _Fare = value;
  }

  String get Method_Name => _Method_Name??"";

  set Method_Name(String value) {
    _Method_Name = value;
  }

  int get PaymentMethod_Id => _PaymentMethod_Id??0;

  set PaymentMethod_Id(int value) {
    _PaymentMethod_Id = value;
  }

  String get Distance => _Distance??"";

  set Distance(String value) {
    _Distance = value;
  }

  int get NumberOfPerson => _NumberOfPerson??0;

  set NumberOfPerson(int value) {
    _NumberOfPerson = value;
  }

  String get End_Location => _End_Location??"";

  set End_Location(String value) {
    _End_Location = value;
  }

  String get Start_Location => _Start_Location??"";

  set Start_Location(String value) {
    _Start_Location = value;
  }

  String get End_Long => _End_Long??"";

  set End_Long(String value) {
    _End_Long = value;
  }

  String get End_Lat => _End_Lat??"";

  set End_Lat(String value) {
    _End_Lat = value;
  }

  String get Start_Long => _Start_Long??"";

  set Start_Long(String value) {
    _Start_Long = value;
  }

  String get Start_Lat => _Start_Lat??"";

  set Start_Lat(String value) {
    _Start_Lat = value;
  }

  String get AM_TypeName => _AM_TypeName??"";

  set AM_TypeName(String value) {
    _AM_TypeName = value;
  }

  int get AM_TypeId => _AM_TypeId??0;

  set AM_TypeId(int value) {
    _AM_TypeId = value;
  }

  int get Ride_Id => _Ride_Id??0;

  set Ride_Id(int value) {
    _Ride_Id = value;
  }
  double get Rating_Points => _Rating_Points??0.0;

  set Rating_Points(double value) {
    _Rating_Points = value;
  }
}
