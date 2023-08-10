import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';

class ListUsers extends StatefulWidget {
  @override
  State<ListUsers> createState() => _ListUsersState();
}

class _ListUsersState extends State<ListUsers> {
  Future<List<Map<String, dynamic>>> getListUsers() async {
    List<Map<String, dynamic>> users = [];
    final File jsonFile = File('assets/local_data.json');
    try {
      final jsonString = await jsonFile.readAsString();
      final data = json.decode(jsonString);
      users = List<Map<String, dynamic>>.from(data['users']);
    } catch(err) {
      print('Error al agregar el registro: $err');
    }
    return users;
  }

  Future<void> DeleteUser(id) async {
    List<Map<dynamic, dynamic>> users = [];
    final File jsonFile = File('assets/local_data.json');
    try {

      final jsonString = await jsonFile.readAsString();
      final data = json.decode(jsonString);
      //print(data['users']);
      users = List<Map<dynamic, dynamic>>.from(data['users']);

      users.removeWhere((item) => item['id'] == id);

      data['users'] = users;
      final updatedJsonString = json.encode(data);
      await jsonFile.writeAsString(updatedJsonString);
    } catch(err) {
      print('Error al agregar el registro: $err');
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: getListUsers(),
        builder: (context, snapshot){
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('No data available'));
          } else {
            final users = snapshot.data!;
            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return Hero(
                  tag: 'Listile-Hero',
                  child: Material(
                    child: ListTile(
                      title: Text(user['name']),
                      subtitle: Text(user['email']),
                      trailing: TextButton(
                        onPressed: () {
                          DeleteUser(user['id']);
                        },
                        child: Icon(Icons.delete_forever),
                      ),
                      onTap: () {}
                    )
                  )
                );
              },
            );
          }
        },
      )
    );
  }
}

