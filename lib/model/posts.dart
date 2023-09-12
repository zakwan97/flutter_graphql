class Posts {
  String? id;
  String? comment;
  String? userId;

  Posts({this.id, this.comment, this.userId});

  Posts.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    comment = json['comment'];
    userId = json['userId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['comment'] = comment;
    data['userId'] = userId;
    return data;
  }
}
