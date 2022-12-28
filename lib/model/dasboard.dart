class Dashboard {
  int total;
  int inprogress;
  int resolved;
  int dropp;

  Dashboard({this.total, this.inprogress, this.resolved, this.dropp});

  Dashboard.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    inprogress = json['inprogress'];
    resolved = json['resolved'];
    dropp = json['dropp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total'] = this.total;
    data['inprogress'] = this.inprogress;
    data['resolved'] = this.resolved;
    data['dropp'] = this.dropp;
    return data;
  }
}
