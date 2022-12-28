class Category {
  Category({
    this.id,
    this.title,
    this.titleUrdu,
    this.icon,
  });

  int id;
  String title;
  String titleUrdu;
  String icon;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["id"],
        title: json["title"],
        titleUrdu: json["title_urdu"],
        icon: json["icon"] ?? 'Complain.png',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "title_urdu": titleUrdu,
        "icon": icon,
      };
}
