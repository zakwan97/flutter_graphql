import 'package:flutter/material.dart';
import 'package:flutter_gphql/graphql/query_script.dart';
import 'package:flutter_gphql/screen/home_screen.dart';
import 'package:flutter_gphql/stylings/stylings.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class UpdateUser extends StatefulWidget {
  final String id;
  final String name;
  final int age;
  final String profession;

  const UpdateUser(
      {Key? key,
      required this.id,
      required this.name,
      required this.age,
      required this.profession})
      : super(key: key);

  @override
  State<UpdateUser> createState() => _UpdateUserState();
}

class _UpdateUserState extends State<UpdateUser> {
  final _nameController = TextEditingController();
  final _professionController = TextEditingController();
  final _ageController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isSaving = false;

  QueryScript query = QueryScript();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.name;
    _professionController.text = widget.profession;
    _ageController.text = widget.age.toString();
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
              Mutation(
                options: MutationOptions(
                  document: gql(query.updateUser()),
                  fetchPolicy: FetchPolicy.noCache,
                  onCompleted: (data) {
                    _isSaving = false;

                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                      builder: (context) {
                        return const HomeScreen();
                      },
                    ), (route) => false);
                  },
                ),
                builder: (runMutation, result) {
                  return Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const SizedBox(height: 12),
                        // TextFormField(
                        //   controller: _nameController,
                        //   decoration: const InputDecoration(
                        //       labelText: "Name",
                        //       fillColor: Colors.white,
                        //       border:
                        //           OutlineInputBorder(borderSide: BorderSide())),
                        //   validator: (v) {
                        //     if (v!.isEmpty) {
                        //       return "Name cannot be empty";
                        //     } else {
                        //       return null;
                        //     }
                        //   },
                        //   keyboardType: TextInputType.emailAddress,
                        // ),
                        _buildTextFormField(
                          controller: _nameController,
                          label: 'Name',
                          validator: (value) =>
                              value!.isEmpty ? 'Name cannot be empty' : null,
                        ),
                        const SizedBox(height: 12),
                        _buildTextFormField(
                          controller: _professionController,
                          label: 'Profession',
                          validator: (value) => value!.isEmpty
                              ? 'Profession cannot be empty'
                              : null,
                        ),
                        TextFormField(
                          controller: _professionController,
                          decoration: const InputDecoration(
                              labelText: "Profession",
                              fillColor: Colors.white,
                              border:
                                  OutlineInputBorder(borderSide: BorderSide())),
                          validator: (v) {
                            if (v!.isEmpty) {
                              return "Profession cannot be empty";
                            } else {
                              return null;
                            }
                          },
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _ageController,
                          decoration: const InputDecoration(
                              labelText: "Age",
                              fillColor: Colors.white,
                              border:
                                  OutlineInputBorder(borderSide: BorderSide())),
                          validator: (v) {
                            if (v!.isEmpty) {
                              return "Age cannot be empty";
                            } else {
                              return null;
                            }
                          },
                          keyboardType: TextInputType.number,
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
                                    runMutation(
                                      {
                                        'id': widget.id,
                                        'name': _nameController.text
                                            .toString()
                                            .trim(),
                                        'profession':
                                            _professionController.text.trim(),
                                        'age': int.parse(_ageController.text)
                                      },
                                    );
                                  }
                                },
                                style: buildButtonStyle(),
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 36, vertical: 12),
                                  child: Text(
                                    "Update",
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 16),
                                  ),
                                ),
                              )
                      ],
                    ),
                  );
                },
              )
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
