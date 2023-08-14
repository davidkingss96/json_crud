import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:email_validator/email_validator.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import '../users_api.dart';

class CreateUserApi extends StatefulWidget {
  const CreateUserApi({super.key});

  @override
  State<CreateUserApi> createState() => _CreateUserApiState();
}

class _CreateUserApiState extends State<CreateUserApi> {
  final dateInput = TextEditingController();
  final nameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final UserApi userApi = UserApi();

  bool validateEmail(String email) {
    bool valid = EmailValidator.validate(email);
    return valid;
  }

  void clearInputs() {
    nameController.clear();
    lastNameController.clear();
    emailController.clear();
    phoneController.clear();
    dateInput.clear();
    print('Se han limpiado los inputs');
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    DateTime selectedDate = appState.isEditingApi ? DateTime.parse(appState.currentUserApi['created']) : DateTime(1990);
    if(appState.isEditingApi){
      print(appState.currentUserApi);
      nameController.text = appState.currentUserApi['firtsname'];
      lastNameController.text = appState.currentUserApi['lastname'];
      emailController.text = appState.currentUserApi['email'];
      dateInput.text = appState.currentUserApi['created'];
      phoneController.text = appState.currentUserApi['telefono'];
    }else{
      //clearInputs();
    }
    return Padding(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
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
                  controller: phoneController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter phone';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Enter phone',
                  ),
                ),
                TextFormField(
                  controller: emailController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter email';
                    }
                    if (!validateEmail(value)) {
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
                        initialDate: selectedDate,
                        firstDate: DateTime(1950),
                        lastDate: DateTime.now()
                    );
                    if (pickedDate != null) {
                      String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);

                      dateInput.text = formattedDate;
                      selectedDate = pickedDate;
                    }
                  },
                ),
                SizedBox(height: 20),
                ToggleButtons(
                    direction: appState.directionButtons,
                    isSelected: [false, false],
                    renderBorder: false,
                    children: [
                      ElevatedButton(
                        child: const Text('Submit'),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            final newRecord = {
                              "firtsname": nameController.text,
                              "lastname": lastNameController.text,
                              "email": emailController.text,
                              "created": "${dateInput.text} 01:00:00",
                              "telefono" : phoneController.text,
                              "category_id" : 1,
                              //"id": appState.isEditingApi ? appState.currentUser['id'] : 0,
                            };
                            try {
                              if(appState.isEditingApi){
                                newRecord["id"] = appState.currentUserApi['id'];
                                userApi.setUserLocal(newRecord);
                              }else{
                                userApi.addNewUserLocal(newRecord);
                              }
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: appState.isEditingApi ? Text('User updated successfully') : Text('User created successfully'),
                                    actions: <Widget>[
                                      ElevatedButton(
                                          onPressed: () {
                                            setState(() {
                                              appState.isEditingApi = false;
                                              appState.selectedIndex = 3;
                                              appState.appTitle = "Create User";
                                            });
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('New User')),
                                      SizedBox(width: 20),
                                      ElevatedButton(
                                          onPressed: () {
                                            setState(() {
                                              appState.selectedIndex =2;
                                            });
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('List Users')),
                                    ],
                                  );
                                },
                              );
                              clearInputs();
                            } catch (err) {
                              print('Error creating user: $err');
                            }
                          }
                        },
                      ),
                      !appState.isEditingApi ? ElevatedButton(
                        child: const Text('Clear'),
                        onPressed: () {
                          clearInputs();
                        },
                      ) : SizedBox(),
                    ]
                ),
              ],
            ),
          ),
        )
    );
  }
}
