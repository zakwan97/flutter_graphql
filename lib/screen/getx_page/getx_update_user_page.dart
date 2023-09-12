import 'package:flutter/material.dart';
import 'package:flutter_gphql/controller/user_controller.dart';
import 'package:flutter_gphql/graphql/query_script.dart';
import 'package:flutter_gphql/screen/home_screen.dart';
import 'package:flutter_gphql/stylings/stylings.dart';
import 'package:get/get.dart';

class GetXUpdateUserPage extends StatefulWidget {
  final String id;
  final String name;
  final int age;
  final String profession;

  const GetXUpdateUserPage(
      {Key? key,
      required this.id,
      required this.name,
      required this.age,
      required this.profession})
      : super(key: key);

  @override
  State<GetXUpdateUserPage> createState() => _GetXUpdateUserPageState();
}

class _GetXUpdateUserPageState extends State<GetXUpdateUserPage> {
  final _formKey = GlobalKey<FormState>();

  UserController u = Get.put(UserController());

  bool _isSaving = false;

  QueryScript query = QueryScript();

  @override
  void initState() {
    super.initState();
    u.nameController.text = widget.name;
    u.professionController.text = widget.profession;
    u.ageController.text = widget.age.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Update ${widget.name}",
          style: const TextStyle(
              color: Colors.grey, fontSize: 19, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(24),
          margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.shade300,
                    offset: const Offset(0, 10),
                    blurRadius: 30)
              ]),
          child: Column(
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 12),
                    _buildTextFormField(
                      controller: u.nameController,
                      label: 'Name',
                      validator: (value) =>
                          value!.isEmpty ? 'Name cannot be empty' : null,
                    ),
                    const SizedBox(height: 12),
                    _buildTextFormField(
                      controller: u.professionController,
                      label: 'Profession',
                      validator: (value) =>
                          value!.isEmpty ? 'Profession cannot be empty' : null,
                    ),
                    const SizedBox(height: 12),
                    _buildTextFormField(
                      controller: u.ageController,
                      label: 'Age',
                      validator: (value) =>
                          value!.isEmpty ? 'Age cannot be empty' : null,
                    ),
                    const SizedBox(height: 12),
                    _isSaving
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 3,
                            ),
                          )
                        : TextButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  _isSaving = true;
                                });
                                u.updateUser(widget.id).then((value) {
                                  Navigator.pushAndRemoveUntil(context,
                                      MaterialPageRoute(
                                    builder: (context) {
                                      return const HomeScreen();
                                    },
                                  ), (route) => false);
                                });
                              }
                            },
                            style: buildButtonStyle(),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 36, vertical: 12),
                              child: Text(
                                "Update",
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 16),
                              ),
                            ),
                          )
                  ],
                ),
              ) //ger
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    TextInputType keyboardType = TextInputType.text,
    required String? Function(String?) validator,
  }) {
    return Column(
      children: [
        const SizedBox(height: 12),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            fillColor: Colors.white,
            border: const OutlineInputBorder(borderSide: BorderSide()),
          ),
          validator: validator,
          keyboardType: keyboardType,
        ),
      ],
    );
  }
}
