class Customer {
  String? accId;
  String? username;
  String? role;
  String? fullname;
  String? phoneNum;
  String? photo;
  String? bookingDate;
  String? cusId;
  String? balance;
  String? plate;
  String? vehicleBrand;
  String? deviceToken;
  String? vehiclePlate;

  Customer(
      {this.accId,
      this.balance,
      this.fullname,
      this.phoneNum,
      this.photo,
      this.cusId,
      this.role,
      this.bookingDate,
      this.username,
      this.plate,
      this.vehicleBrand,
      this.vehiclePlate,
      required this.deviceToken});
}
