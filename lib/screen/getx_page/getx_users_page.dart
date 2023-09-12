import 'package:flutter/material.dart';
import 'package:flutter_gphql/controller/user_controller.dart';
import 'package:flutter_gphql/graphql/query_script.dart';
import 'package:flutter_gphql/screen/details_page.dart';
import 'package:flutter_gphql/screen/getx_page/getx_update_user_page.dart';
import 'package:flutter_gphql/screen/home_screen.dart';
import 'package:get/get.dart';

class UsersPageGetx extends StatefulWidget {
  const UsersPageGetx({super.key});

  @override
  State<UsersPageGetx> createState() => _UsersPageGetxState();
}

class _UsersPageGetxState extends State<UsersPageGetx> {
  UserController u = Get.put(UserController());
  List hobbiesIDsToDelete = [];
  List postsIdsToDelete = [];

  bool _isRemoveHobby = false;
  bool _isRemovePost = false;

  QueryScript query = QueryScript();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserController>(
      builder: (UserController uc) {
        return (uc.isLoading)
            ? const CircularProgressIndicator()
            : uc.userList.isNotEmpty
                ? ListView.builder(
                    itemCount: uc.userList.length,
                    itemBuilder: (context, index) {
                      final user = uc.userList[index];
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
                                        uc.userList[index].name!,
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
                                                return GetXUpdateUserPage(
                                                  id: uc.userList[index].id!,
                                                  name:
                                                      uc.userList[index].name!,
                                                  age: uc.userList[index].age!,
                                                  profession: uc.userList[index]
                                                      .profession!,
                                                );
                                              });
                                              await Navigator.push(
                                                  context, route);
                                            },
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8),
                                            child: InkWell(
                                              child: const Icon(
                                                Icons.delete_forever,
                                                color: Colors.red,
                                              ),
                                              onTap: () async {
                                                hobbiesIDsToDelete.clear();
                                                postsIdsToDelete.clear();

                                                setState(() {
                                                  _isRemoveHobby = true;
                                                  _isRemovePost = true;
                                                });

                                                uc.removeUsers(user);

                                                //Remove Hobbies
                                                _isRemoveHobby
                                                    ? uc
                                                        .removeHobbies(uc
                                                            .userList[index]
                                                            .hobbies!)
                                                        .then((value) {})
                                                    : Container();
                                                // Remove post
                                                _isRemovePost
                                                    ? uc
                                                        .removePosts(uc
                                                            .userList[index]
                                                            .posts!)
                                                        .then((value) {
                                                        Navigator
                                                            .pushAndRemoveUntil(
                                                                context,
                                                                MaterialPageRoute(
                                                          builder: (context) {
                                                            return const HomeScreen();
                                                          },
                                                        ), (route) => false);
                                                      })
                                                    : Container();
                                                uc.getUserList();
                                              },
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8.0, top: 8.0),
                                    child: Text(
                                        "Occupation: ${uc.userList[index].profession ?? 'N/A'}"),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8.0, top: 8.0),
                                    child: Text(
                                        "Age: ${uc.userList[index].age ?? 'N/A'}"),
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
