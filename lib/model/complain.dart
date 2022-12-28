class Complain {
  int id;
  String code;
  String subject;
  String detail;
  String address;
  String gpsLocation;
  String latLong;
  String attach;
  int hideIdentity;
  String status;
  String createdAt;
  int districtId;
  int tehsilId;
  int category3Id;
  String district;
  String tehsil;
  String cat3;
  String cat2;
  String cat1;
  int feedbackStatus;

  Complain(
      {this.id,
      this.code,
      this.subject,
      this.detail,
      this.address,
      this.gpsLocation,
      this.latLong,
      this.attach,
      this.hideIdentity,
      this.status,
      this.createdAt,
      this.districtId,
      this.tehsilId,
      this.category3Id,
      this.district,
      this.tehsil,
      this.cat3,
      this.cat2,
      this.cat1,
      this.feedbackStatus});

  Complain.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    subject = json['subject'];
    detail = json['detail'];
    address = json['address'];
    gpsLocation = json['gps_location'];
    latLong = json['lat_long'];
    attach = json['attach'];
    hideIdentity = json['hide_identity'];
    status = json['status'];
    createdAt = json['created_at'];
    districtId = json['district_id'];
    tehsilId = json['tehsil_id'];
    category3Id = json['category3_id'];
    district = json['district'];
    tehsil = json['tehsil'];
    cat3 = json['cat3'];
    cat2 = json['cat2'];
    cat1 = json['cat1'];
    feedbackStatus = json['feedbackStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['code'] = this.code;
    data['subject'] = this.subject;
    data['detail'] = this.detail;
    data['address'] = this.address;
    data['gps_location'] = this.gpsLocation;
    data['lat_long'] = this.latLong;
    data['attach'] = this.attach;
    data['hide_identity'] = this.hideIdentity;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['district_id'] = this.districtId;
    data['tehsil_id'] = this.tehsilId;
    data['category3_id'] = this.category3Id;
    data['district'] = this.district;
    data['tehsil'] = this.tehsil;
    data['cat3'] = this.cat3;
    data['cat2'] = this.cat2;
    data['cat1'] = this.cat1;
    data['feedbackStatus'] = this.feedbackStatus;
    return data;
  }
}
