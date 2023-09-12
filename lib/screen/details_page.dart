import 'package:flutter/material.dart';
import 'package:flutter_gphql/model/hobbies.dart';
import 'package:flutter_gphql/model/posts.dart';
import 'package:flutter_gphql/model/user.dart';
import 'package:flutter_gphql/stylings/stylings.dart';

class DetailsPage extends StatefulWidget {
  final Users user;
  const DetailsPage({Key? key, required this.user}) : super(key: key);

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  List<Hobbies> _hobbies = [];
  List<Posts> _posts = [];
  Hobbies hobby = Hobbies();
  Posts post = Posts();
  bool _isHobby = false;
  bool _isPost = false;

  void _togglePostBtn() {
    setState(() {
      _isPost = true;
      _isHobby = false;
    });
  }

  void _toggleHobbyBtn() {
    setState(() {
      _isPost = false;
      _isHobby = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          widget.user.name!,
          style: const TextStyle(
              color: Colors.grey, fontSize: 19, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Flexible(
            flex: 1,
            fit: FlexFit.loose,
            child: Container(
              padding: const EdgeInsets.all(24),
              margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                        offset: const Offset(0, 10),
                        color: Colors.grey.shade300,
                        blurRadius: 30)
                  ]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.user.name!.toUpperCase(),
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, top: 8),
                    child:
                        Text("Occupations: ${widget.user.profession ?? "N/A"}"),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Age: ${widget.user.age ?? "N/A"}"),
                  )
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Flexible(
                flex: 1,
                fit: FlexFit.loose,
                child: TextButton(
                    onPressed: () {
                      _toggleHobbyBtn();
                      //get all hobbies and show them
                      setState(() {
                        _hobbies = widget.user.hobbies!;
                      });
                    },
                    style: buildButtonStyle(),
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 36, vertical: 12),
                      child: Text(
                        "Hobbies",
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    )),
              ),
              Flexible(
                  child: TextButton(
                onPressed: () {
                  _togglePostBtn();
                  //get all hobbies and show them
                  setState(() {
                    _posts = widget.user.posts!;
                  });
                },
                style: buildButtonStyle(),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 36, vertical: 12),
                  child: Text(
                    "Posts",
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ),
              ))
            ],
          ),
          //Listview
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.45,
            child: ListView.builder(
              itemCount: _isHobby ? _hobbies.length : _posts.length,
              itemBuilder: (BuildContext context, index) {
                _isHobby ? (hobby = _hobbies[index]) : (post = _posts[index]);
                // var data = _isHobby ? _hobbies[index] : _posts[index];
                return Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(
                          bottom: 23, left: 10, right: 10, top: 22),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                                offset: const Offset(0, 10),
                                color: Colors.grey.shade300,
                                blurRadius: 30)
                          ]),
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(_isHobby
                                  ? "Hobby: ${hobby.title}"
                                  : "Post: ${post.comment}")
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0, top: 8),
                            child: Text(_isHobby
                                ? "Description: ${hobby.description}"
                                : ""),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Author: ${widget.user.name}",
                              style:
                                  const TextStyle(fontStyle: FontStyle.italic),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
