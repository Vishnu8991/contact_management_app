import 'package:contact_management_app/model/db_helper.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

class EditScreen extends StatefulWidget {
  const EditScreen({Key? key, required this.contact}) : super(key: key);

  final dynamic contact;

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController firstnameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  bool isEnabled = false;

  @override
  void initState() {
    super.initState();
    firstnameController.text = widget.contact['firstname'];
    lastnameController.text = widget.contact['lastname'];
    phoneController.text = widget.contact['number'].toString();
    emailController.text = widget.contact['email'];
  }

  String? validateFirstName(String? value) {
    if (value!.isEmpty || value.length <= 3) {
      return 'First Name must be longer than 3 characters';
    }
    return null;
  }

  String? validateLastName(String? value) {
    if (value!.isEmpty || value.length <= 3) {
      return 'Last Name must be longer than 3 characters';
    }
    if (value == firstnameController.text) {
      return 'Last Name cannot be the same as First Name';
    }
    return null;
  }

  String? validatePhoneNumber(String? value) {
    if (value!.isEmpty) {
      return 'Phone number is required';
    }
    if (value.length != 10) {
      return 'Phone number must be 10 digits long';
    }
    if (!RegExp(r'^[6-9]\d{9}$').hasMatch(value)) {
      return 'Invalid phone number';
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value!.isEmpty) {
      return 'Email is required';
    }
    if (!EmailValidator.validate(value)) {
      return 'Invalid email address';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[300],
        body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  width: constraints.maxWidth,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    border: Border.all(color: Colors.grey.shade100),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Edit Contact",
                            style: TextStyle(
                              fontSize: 25,
                              color: Color(0xffF7A800),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 15),
                          TextFormField(
                            enabled: isEnabled,
                            controller: firstnameController,
                            keyboardType: TextInputType.name,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              labelText: "First Name",
                              labelStyle: TextStyle(color: Colors.grey),
                              border: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                            ),
                            validator: validateFirstName,
                          ),
                          SizedBox(height: 15),
                          TextFormField(
                            enabled: isEnabled,
                            controller: lastnameController,
                            keyboardType: TextInputType.name,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              labelText: "Last Name",
                              labelStyle: TextStyle(color: Colors.grey),
                              border: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                            ),
                            validator: validateLastName,
                          ),
                          SizedBox(height: 15),
                          TextFormField(
                            enabled: isEnabled,
                            controller: phoneController,
                            keyboardType: TextInputType.phone,
                            textInputAction: TextInputAction.next,
                            maxLength: 10,
                            decoration: InputDecoration(
                              labelText: "Phone number",
                              labelStyle: TextStyle(color: Colors.grey),
                              border: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              counterText: '',
                            ),
                            validator: validatePhoneNumber,
                          ),
                          SizedBox(height: 15),
                          TextFormField(
                            enabled: isEnabled,
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              labelText: "Email",
                              labelStyle: TextStyle(color: Colors.grey),
                              border: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                            ),
                            validator: validateEmail,
                          ),
                          SizedBox(height: 30),
                          Center(
                            child: !isEnabled
                                ? Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            isEnabled = !isEnabled;
                                          });
                                        },
                                        style: ElevatedButton.styleFrom(
                                          primary: Color(0xffF7A800),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            side: BorderSide(
                                              color: Color(0xffF7A800),
                                              width: 2,
                                            ),
                                          ),
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 40,
                                            vertical: 10,
                                          ),
                                        ),
                                        child: Text(
                                          "Edit",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                      ElevatedButton(
                                        onPressed: () async {
                                          bool? confirmDelete =
                                              await showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              title: Text('Confirmation'),
                                              content: Text(
                                                'Are you sure you want to delete this contact?',
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context, true);
                                                  },
                                                  child: Text('Yes'),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(
                                                        context, false);
                                                  },
                                                  child: Text('No'),
                                                ),
                                              ],
                                            ),
                                          );
                                          if (confirmDelete != null &&
                                              confirmDelete) {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              await deleteContact(
                                                  widget.contact['id']);
                                              print("Validation passed!");
                                            } else {
                                              print("Validation failed!");
                                            }
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          primary: Color(0xffF7A800),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            side: BorderSide(
                                              color: Color(0xffF7A800),
                                              width: 2,
                                            ),
                                          ),
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 40,
                                            vertical: 10,
                                          ),
                                        ),
                                        child: Text(
                                          "Delete",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : ElevatedButton(
                                    onPressed: () async {
                                      if (_formKey.currentState!.validate()) {
                                        await updateContact(
                                            widget.contact['id']);
                                        print("Validation passed!");
                                      } else {
                                        print("Validation failed!");
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      primary: Color(0xffF7A800),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5),
                                        side: BorderSide(
                                          color: Color(0xffF7A800),
                                          width: 2,
                                        ),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 40,
                                        vertical: 10,
                                      ),
                                    ),
                                    child: Text(
                                      "Save",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> updateContact(int id) async {
    await SQLHelper.updateContact(
      widget.contact['id'],
      firstnameController.text,
      lastnameController.text,
      phoneController.text,
      emailController.text,
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.green,
        content: Text("Successfully Updated"),
        duration: Duration(seconds: 2),
      ),
    );
    Navigator.pop(context);
  }

  Future<void> deleteContact(int id) async {
    await SQLHelper.deleteContact(id);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        content: Text("Successfully Deleted"),
        duration: Duration(seconds: 2),
      ),
    );
    Navigator.pop(context);
  }
}
