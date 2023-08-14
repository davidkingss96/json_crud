import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:email_validator/email_validator.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import '../users.dart';

class CreateUserForm extends StatefulWidget {
  const CreateUserForm({super.key});

  @override
  State<CreateUserForm> createState() => _CreateUserFormState();
}

class _CreateUserFormState extends State<CreateUserForm> {
  final dateInput = TextEditingController();
  final nameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final UserStorage userStorage = UserStorage();

  bool ValidateEmail(String email) {
    bool valid = EmailValidator.validate(email);
    return valid;
  }

  void ClearInputs () {
    nameController.clear();
    lastNameController.clear();
    emailController.clear();
    dateInput.clear();
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    return Padding(
      padding: EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child:  Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: nameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter name';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Enter name',
                ),
              ),
              TextFormField(
                controller: lastNameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter lastname';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Enter lastname',
                ),
              ),
              TextFormField(
                controller: emailController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter email';
                  }
                  if (!ValidateEmail(value)) {
                    return 'Please enter correct email';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Enter email',
                ),
              ),
              TextFormField(
                controller: dateInput,
                decoration: InputDecoration(
                    icon: Icon(Icons.calendar_today), //icon of text field
                    labelText: "Enter Date" //label text of field
                ),
                readOnly: true,
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime(1990),
                      firstDate: DateTime(1950),
                      lastDate: DateTime.now()
                  );
                  if (pickedDate != null) {
                    String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                    setState(() {
                      dateInput.text = formattedDate; //set output date to TextField value.
                    });
                  }
                },
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    child: const Text('Submit'),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        final newRecord = {
                          "name" : nameController.text,
                          "lastName" : lastNameController.text,
                          "email" : emailController.text,
                          "birthDate" : dateInput.text,
                          "id" : 0,
                        };
                        try{
                          userStorage.addNewUserLocal(newRecord);
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text('User created successfully'),
                                actions: <Widget>[
                                  ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          appState.selectedIndex = 0;
                                        });
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('New User')
                                  ),
                                  SizedBox(width: 20),
                                  ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          appState.selectedIndex = 1;
                                        });
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('List Users')
                                  ),
                                ],
                              );
                            },
                          );
                          ClearInputs();
                        }catch (err){
                          print('Error creating user: $err');
                        }
                      }
                    },
                  ),
                  SizedBox(width: 16),
                  ElevatedButton(
                    child: const Text('Clear'),
                    onPressed: () {
                      ClearInputs();
                    },
                  ),
                ]
              ),
            ],
          ),
        ),
      )
    );
  }
}

