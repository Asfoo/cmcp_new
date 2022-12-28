class Tehsil {
  int id;
  String title;
  int districtId;

  Tehsil({this.id, this.title, this.districtId});

  Tehsil.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    districtId = json['district_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['district_id'] = this.districtId;
    return data;
  }
}
