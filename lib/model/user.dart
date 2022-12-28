class User {
  int id;
  String name;
  String email;
  String cnic;
  String contactNo;
  String gender;
  String address;
  int districtId;
  String emailVerifiedAt;
  String avatar;
  String mVerify;

  User({
    this.id,
    this.name,
    this.email,
    this.cnic,
    this.contactNo,
    this.gender,
    this.address,
    this.districtId,
    this.emailVerifiedAt,
    this.avatar,
    this.mVerify,
  });

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    cnic = json['cnic'];
    contactNo = json['contact_no'];
    gender = json['gender'];
    address = json['address'];
    districtId = json['district_id'].runtimeType == String
        ? int.parse(json['district_id'])
        : json['district_id'];
    emailVerifiedAt = json['email_verified_at'];
    avatar = json['avatar'] ?? 'user_green.png';
    mVerify = json['m_verify'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['cnic'] = this.cnic;
    data['contact_no'] = this.contactNo;
    data['gender'] = this.gender;
    data['address'] = this.address;
    data['district_id'] = this.districtId;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['avatar'] = this.avatar;
    data['m_verify'] = this.mVerify;
    return data;
  }
}
