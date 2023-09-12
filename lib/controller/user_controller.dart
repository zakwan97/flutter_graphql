import 'package:flutter/material.dart';
import 'package:flutter_gphql/graphql/query_script.dart';
import 'package:flutter_gphql/model/hobbies.dart';
import 'package:flutter_gphql/model/posts.dart';
import 'package:flutter_gphql/model/user.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class UserController extends GetxController {
  QueryScript query = QueryScript();
  GraphQLClient client = GraphQLClient(
      link: HttpLink('http://localhost:4000/graphql'), cache: GraphQLCache());

  var userList = <Users>[].obs;
  var isLoading = true;
  TextEditingController nameController = TextEditingController();
  TextEditingController professionController = TextEditingController();
  TextEditingController ageController = TextEditingController();

  @override
  void onInit() {
    getUserList();
    super.onInit();
  }

  Future<void> getUserList() async {
    final QueryOptions options = QueryOptions(
      document: gql(query.allQuery()),
      fetchPolicy: FetchPolicy.noCache,
    );

    final QueryResult result = await client.query(options);

    if (result.hasException) {
      throw result.exception!;
    }

    final data = result.data?['users'] as List<dynamic>;
    final fetchedPosts =
        data.map((userData) => Users.fromJson(userData)).toList();

    userList.assignAll(fetchedPosts);
    isLoading = false;
    update();
  }

  Future<void> runUserMutation(Map<String, dynamic> variables) async {
    await client.mutate(
      MutationOptions(
        document: gql(query.removeUser()),
        variables: variables,
        fetchPolicy: FetchPolicy.noCache,
      ),
    );
  }

  Future<void> removeUsers(Users user) async {
    await runUserMutation({
      "id": user.id,
    });
  }

  Future<void> runHobbiesMutation(Map<String, dynamic> variables) async {
    await client.mutate(
      MutationOptions(
        document: gql(query.removeHobbies()),
        variables: variables,
        fetchPolicy: FetchPolicy.noCache,
      ),
    );
  }

  Future<void> removeHobbies(List<Hobbies> hobbies) async {
    if (hobbies.isNotEmpty) {
      for (int index = 0; index < hobbies.length; index++) {
        await runHobbiesMutation({
          "id": hobbies[index].id,
        });
      }
    }
    update();
  }

  Future<void> runPostMutation(Map<String, dynamic> variables) async {
    await client.mutate(
      MutationOptions(
        document: gql(query.removePosts()),
        variables: variables,
        fetchPolicy: FetchPolicy.noCache,
      ),
    );
  }

  Future<void> removePosts(List<Posts> posts) async {
    if (posts.isNotEmpty) {
      for (int index = 0; index < posts.length; index++) {
        await runPostMutation({
          "id": posts[index].id,
        });
      }
    }
    update();
  }

  Future<void> runUpdateUserMutation(Map<String, dynamic> variables) async {
    await client.mutate(
      MutationOptions(
        document: gql(query.updateUser()),
        variables: variables,
        fetchPolicy: FetchPolicy.noCache,
      ),
    );
  }

  Future<void> updateUser(String id) async {
    await runUpdateUserMutation({
      'id': id,
      'name': nameController.text.toString().trim(),
      'profession': professionController.text.trim(),
      'age': int.parse(ageController.text),
    });
    getUserList();
  }
}
