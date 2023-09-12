import 'package:flutter/material.dart';
import 'package:flutter_gphql/screen/add_user_page.dart';
import 'package:flutter_gphql/screen/getx_page/getx_users_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    // Widget content = const UsersPage();
    Widget content = const UsersPageGetx();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Users & Hobbies",
          style: TextStyle(
              color: Colors.grey, fontSize: 19, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(child: content),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final route = MaterialPageRoute(
            builder: (context) => const AddUserPage(),
          );
          await Navigator.push(context, route);
        },
        backgroundColor: Colors.lightGreen,
        child: const Icon(Icons.group_add),
      ),
    );
  }
}
