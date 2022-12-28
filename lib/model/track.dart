class Track {
  int id;
  String dept;
  String status;
  String remarks;
  String forwardDate;
  String createdAt;
  String attach;
  String days;

  Track(
      {this.id,
      this.dept,
      this.status,
      this.remarks,
      this.forwardDate,
      this.createdAt,
      this.attach,
      this.days});

  Track.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    dept = json['dept'];
    status = json['status'];
    remarks = json['remarks'];
    forwardDate = json['forward_date'];
    createdAt = json['created_at'];
    attach = json['attach'];
    days = json['days'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['dept'] = this.dept;
    data['status'] = this.status;
    data['remarks'] = this.remarks;
    data['forward_date'] = this.forwardDate;
    data['created_at'] = this.createdAt;
    data['attach'] = this.attach;
    data['days'] = this.days;
    return data;
  }
}
