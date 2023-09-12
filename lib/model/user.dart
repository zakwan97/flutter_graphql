import 'dart:convert';

import 'package:flutter_gphql/model/hobbies.dart';
import 'package:flutter_gphql/model/posts.dart';

Users graphqlFromJson(String str) => Users.fromJson(json.decode(str));

class Users {
  String? name;
  String? id;
  String? profession;
  int? age;
  List<Posts>? posts;
  List<Hobbies>? hobbies;

  Users(
      {this.name,
      this.id,
      this.profession,
      this.age,
      this.posts,
      this.hobbies});

  Users.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    id = json['id'];
    profession = json['profession'];
    age = json['age'];
    if (json['posts'] != null) {
      posts = <Posts>[];
      json['posts'].forEach((v) {
        posts!.add(Posts.fromJson(v));
      });
    }
    if (json['hobbies'] != null) {
      hobbies = <Hobbies>[];
      json['hobbies'].forEach((v) {
        hobbies!.add(Hobbies.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['id'] = id;
    data['profession'] = profession;
    data['age'] = age;
    if (posts != null) {
      data['posts'] = posts!.map((v) => v.toJson()).toList();
    }
    if (hobbies != null) {
      data['hobbies'] = hobbies!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
