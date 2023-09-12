import 'package:flutter/material.dart';
import 'package:flutter_gphql/controller/user_controller.dart';
import 'package:flutter_gphql/graphql/query_script.dart';
import 'package:flutter_gphql/model/user.dart';
import 'package:flutter_gphql/screen/details_page.dart';
import 'package:flutter_gphql/screen/home_screen.dart';
import 'package:flutter_gphql/screen/update_user_page.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  List users = [];
  List<Users> userList = [];
  List<Users> users1 = [];
  List hobbiesIDsToDelete = [];
  List postsIdsToDelete = [];

  bool _isRemoveHobby = false;
  bool _isRemovePost = false;

  QueryScript query = QueryScript();
  UserController uc = UserController();

  List<Users> newList(List<dynamic> data) {
    //clear list to avoid looping add new list
    if (userList.isNotEmpty) {
      userList.clear();
    }
    //var e is the object of data without having index
    // for (var e in data) {
    //   Users user = Users.fromJson(e);
    //   userList.add(user);
    // }
    for (var i = 0; i < data.length; i++) {
      final user = Users.fromJson(data[i]);
      userList.add(user);
    }
    return userList;
  }

  @override
  Widget build(BuildContext context) {
    return Query(
      options: QueryOptions(document: gql(query.allQuery())),
      builder: (result, {fetchMore, refetch}) {
        if (result.isLoading) {
          return const CircularProgressIndicator();
        }
        users = result.data!["users"];
        newList(users);
        //List<Users> userList = users.map((e) => Users.fromJson(e)).toList();
        return (userList.isNotEmpty)
            ? ListView.builder(
                itemCount: userList.length,
                itemBuilder: (context, index) {
                  final user = userList[index];
                  return Stack(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(
                          bottom: 23,
                          left: 10,
                          right: 10,
                        ),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                  offset: const Offset(0, 10),
                                  color: Colors.grey.shade300,
                                  blurRadius: 30)
                            ]),
                        padding: const EdgeInsets.all(20),
                        child: InkWell(
                          onTap: () async {
                            print(":::User: ${user.toString()}");
                            final route = MaterialPageRoute(
                              builder: (context) {
                                return DetailsPage(user: user);
                              },
                            );
                            await Navigator.push(context, route);
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    userList[index].name!,
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Row(
                                    children: [
                                      InkWell(
                                        child: const Icon(
                                          Icons.edit,
                                          color: Colors.greenAccent,
                                        ),
                                        onTap: () async {
                                          final route = MaterialPageRoute(
                                              builder: (context) {
                                            return UpdateUser(
                                              id: userList[index].id!,
                                              name: userList[index].name!,
                                              age: userList[index].age!,
                                              profession:
                                                  userList[index].profession!,
                                            );
                                          });
                                          await Navigator.push(context, route);
                                        },
                                      ),
                                      Mutation(
                                        options: MutationOptions(
                                          document: gql(query.removeUser()),
                                          onCompleted: (data) {},
                                        ),
                                        builder: (runMutation, result) {
                                          return Padding(
                                            padding: const EdgeInsets.all(8),
                                            child: InkWell(
                                              child: const Icon(
                                                Icons.delete_forever,
                                                color: Colors.red,
                                              ),
                                              onTap: () async {
                                                hobbiesIDsToDelete.clear();
                                                postsIdsToDelete.clear();

                                                for (var i = 0;
                                                    i <
                                                        userList[index]
                                                            .hobbies!
                                                            .length;
                                                    i++) {
                                                  hobbiesIDsToDelete.add(
                                                      userList[index]
                                                          .hobbies![i]
                                                          .id);
                                                }

                                                for (var i = 0;
                                                    i <
                                                        userList[index]
                                                            .posts!
                                                            .length;
                                                    i++) {
                                                  postsIdsToDelete.add(
                                                      userList[index]
                                                          .posts![i]
                                                          .id);
                                                }
                                                // // print(
                                                // //     "+++${user["name"]} Hobbies to delete: ${hobbiesIDsToDelete.toString()} ");
                                                // // print(
                                                // //     "+++${user["name"]} Posts to delete: ${postsIdsToDelete.toString()}");
                                                setState(() {
                                                  _isRemoveHobby = true;
                                                  _isRemovePost = true;
                                                });
                                                runMutation(
                                                    {"id": userList[index].id});
                                                Navigator.pushAndRemoveUntil(
                                                    context, MaterialPageRoute(
                                                  builder: (context) {
                                                    return const HomeScreen();
                                                  },
                                                ), (route) => false);
                                              },
                                            ),
                                          );
                                        },
                                      ),
                                      _isRemoveHobby
                                          ? Mutation(
                                              options: MutationOptions(
                                                document:
                                                    gql(query.removeHobbies()),
                                                onCompleted: (data) {},
                                              ),
                                              builder: (runMutation, result) {
                                                if (hobbiesIDsToDelete
                                                    .isNotEmpty) {
                                                  print(
                                                      "Calling deleteHobbies...");
                                                  runMutation({
                                                    'ids': hobbiesIDsToDelete
                                                  });
                                                }
                                                return Container();
                                              },
                                            )
                                          : Container(),
                                      _isRemovePost
                                          ? Mutation(
                                              options: MutationOptions(
                                                document:
                                                    gql(query.removePosts()),
                                                onCompleted: (data) {},
                                              ),
                                              builder: (runMutation, result) {
                                                if (postsIdsToDelete
                                                    .isNotEmpty) {
                                                  runMutation({
                                                    "ids": postsIdsToDelete
                                                  });
                                                }
                                                return Container();
                                              },
                                            )
                                          : Container()
                                    ],
                                  )
                                ],
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 8.0, top: 8.0),
                                child: Text(
                                    "Occupation: ${userList[index].profession ?? 'N/A'}"),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 8.0, top: 8.0),
                                child: Text(
                                    "Age: ${userList[index].age ?? 'N/A'}"),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  );
                },
              )
            : const Center(
                child: Text("No items found"),
              );
      },
    );
  }
}
