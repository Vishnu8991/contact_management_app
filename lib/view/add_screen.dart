import 'package:contact_management_app/model/db_helper.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';


class AddScreen extends StatefulWidget {
  final VoidCallback onContactCreated;

  const AddScreen({Key? key, required this.onContactCreated}) : super(key: key);

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController firstnameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();

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
                padding: EdgeInsets.all(constraints.maxWidth * 0.05),
                child: Container(
                  padding: EdgeInsets.all(constraints.maxWidth * 0.05),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    border: Border.all(color: Colors.grey.shade100),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Add Contact",
                          style: TextStyle(
                            fontSize: constraints.maxWidth * 0.07,
                            color: Color(0xffF7A800),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: constraints.maxWidth * 0.04),
                        TextFormField(
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
                        SizedBox(height: constraints.maxWidth * 0.04),
                        TextFormField(
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
                        SizedBox(height: constraints.maxWidth * 0.04),
                        TextFormField(
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
                        SizedBox(height: constraints.maxWidth * 0.04),
                        TextFormField(
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
                        SizedBox(height: constraints.maxWidth * 0.08),
                        Center(
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all<Color>(
                                      Color(0xffF7A800)),
                              maximumSize: MaterialStateProperty.all(
                                Size.fromHeight(
                                  constraints.maxWidth * 0.15,
                                ),
                              ),
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  side: BorderSide(
                                    color: Color(0xffF7A800),
                                    width: 2,
                                  ),
                                ),
                              ),
                              padding: MaterialStateProperty.all(
                                EdgeInsets.symmetric(
                                  horizontal: constraints.maxWidth * 0.1,
                                  vertical: constraints.maxWidth * 0.035,
                                ),
                              ),
                            ),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                await createContact();
                                print("Validation passed!");
                              } else {
                                print("Validation failed!");
                              }
                            },
                            child: Text(
                              "Create",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: constraints.maxWidth * 0.05,
                              ),
                            ),
                          ),
                        ),
                      ],
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
Future<void> createContact() async {
  final int id = await SQLHelper.createContact(
    firstnameController.text,
    lastnameController.text,
    phoneController.text,
    emailController.text,
  );

  if (id != -1) {
    widget.onContactCreated();
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.green,
        content: Text("Contact created successfully"),
        duration: Duration(seconds: 2),
      ));
  } else {
    String message = 'Contact already exists';
    final db = await SQLHelper.createDB();
    
    if (await db.query('contacts', where: 'firstname = ?', whereArgs: [firstnameController.text]).then((value) => value.isNotEmpty)) {
      message = 'Contact already exists with this First Name';
    } else if (await db.query('contacts', where: 'number = ?', whereArgs: [phoneController.text]).then((value) => value.isNotEmpty)) {
      message = 'Contact already exists with this Phone Number';
    } else if (await db.query('contacts', where: 'email = ?', whereArgs: [emailController.text]).then((value) => value.isNotEmpty)) {
      message = 'Contact already exists with this Email';
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );

  }
}

}