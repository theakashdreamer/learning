class ForgetPassword {
  String? Person_Mobile;
  String? User_Password;
  String? ResultString;
  Map<String, dynamic> toJson() {
    return {
      'Person_Mobile': Person_Mobile,
      'User_Password': User_Password,
      'ResultString': ResultString,
    };
  }
}
