import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';

import 'package:localstorage/localstorage.dart';

class ListUsers extends StatefulWidget {
  @override
  State<ListUsers> createState() => _ListUsersState();
}

class _ListUsersState extends State<ListUsers> {

  Future<List<Map<String, dynamic>>> getListUsers() async {
    final LocalStorage storage = LocalStorage('my_app');
    List<Map<String, dynamic>> records =
    (storage.getItem('records') as List<dynamic>)
        .cast<Map<String, dynamic>>();
    print(records);
    return records;
  }

  Future<void> DeleteUser(int id) async {
    final LocalStorage storage = LocalStorage('my_app');
    List<Map<String, dynamic>> records =
    (storage.getItem('records') as List<dynamic>)
        .cast<Map<String, dynamic>>();

    try {
      records.removeWhere((record) => record['id'] == id);

      await storage.setItem('records', records);

      print('Usuario eliminado con éxito');
    } catch (err) {
      print('Error al eliminar el usuario: $err');
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
                      child: ListTile(
                          title: Text(user['name']),
                          subtitle: Text(user['email']),
                          trailing: TextButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text('Are you sure to delete the user?'),
                                      actions: <Widget>[
                                        ElevatedButton(
                                          onPressed: () {
                                            DeleteUser(user['id']);
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('Yes'),
                                        ),
                                        SizedBox(width: 20),
                                        ElevatedButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text('No')
                                        )
                                      ],
                                    );
                                  }
                              );
                            },
                            child: Icon(Icons.delete_forever),
                          ),
                          onTap: () {

                          }
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

