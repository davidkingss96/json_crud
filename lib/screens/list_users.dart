import 'package:flutter/material.dart';

import '../users.dart';

class ListUsers extends StatefulWidget {
  @override
  State<ListUsers> createState() => _ListUsersState();
}

class _ListUsersState extends State<ListUsers> {
  final UserStorage userStorage = UserStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder<List<Map<String, dynamic>>>(
          future: userStorage.getListUsers(),
          builder: (context, snapshot){
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error on FutureBuilder: ${snapshot.error}'));
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
                                            userStorage.DeleteUser(user['id']);
                                            Navigator.of(context).pop();
                                            setState(() {});
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
