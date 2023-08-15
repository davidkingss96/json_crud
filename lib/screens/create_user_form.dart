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

  bool validateEmail(String email) {
    bool valid = EmailValidator.validate(email);
    return valid;
  }

  void clearInputs() {
    nameController.clear();
    lastNameController.clear();
    emailController.clear();
    dateInput.clear();
    print('Se han limpiado los inputs');
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    DateTime selectedDate = appState.isEditing ? DateTime.parse(appState.currentUser['birthDate']) : DateTime(1990);
    if(appState.isEditing){
      nameController.text = appState.currentUser['name'];
      lastNameController.text = appState.currentUser['lastName'];
      emailController.text = appState.currentUser['email'];
      dateInput.text = appState.currentUser['birthDate'];
    }else{
      clearInputs();
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
                            "name": nameController.text,
                            "lastName": lastNameController.text,
                            "email": emailController.text,
                            "birthDate": dateInput.text,
                            "id": appState.isEditing ? appState.currentUser['id'] : 0,
                          };
                          try {
                            if(appState.isEditing){
                              userStorage.setUserLocal(newRecord);
                            }else{
                              userStorage.addNewUserLocal(newRecord);
                            }
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: appState.isEditing ? Text('User updated successfully') : Text('User created successfully'),
                                  actions: <Widget>[
                                    ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            appState.isEditing = false;
                                            appState.selectedIndex = 0;
                                            appState.appTitle = "Create User";
                                          });
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('New User')),
                                    SizedBox(width: 20),
                                    ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            appState.selectedIndex = 1;
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
                    !appState.isEditing ? ElevatedButton(
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
