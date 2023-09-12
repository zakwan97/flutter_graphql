class Hobbies {
  String? id;
  String? title;
  String? description;
  String? userId;

  Hobbies({this.id, this.title, this.description, this.userId});

  Hobbies.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    userId = json['userId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['description'] = description;
    data['userId'] = userId;
    return data;
  }
}
