import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import '../users_api.dart';

class ListDataApi extends StatefulWidget {
  @override
  State<ListDataApi> createState() => _ListDataApi();
}

class _ListDataApi extends State<ListDataApi> {
  final UserApi userApi = UserApi();

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    return Scaffold(
        body: FutureBuilder<List<Map<String, dynamic>>>(
          future: userApi.getListUsers(),
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
                          title: Text(user['firtsname']),
                          subtitle: Text(user['lastname']),
                          trailing: TextButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text('Are you sure to delete the user?'),
                                      actions: <Widget>[
                                        ElevatedButton(
                                          onPressed: () async {
                                            userApi.deleteUser(user['id']);
                                            await Future.delayed(const Duration(milliseconds: 300));
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
                            setState(() {
                              appState.selectedIndex = 3;
                              appState.isEditingApi = true;
                              appState.currentUserApi = user;
                              var userName = user['name'];
                              appState.appTitle = "Edit user $userName";
                            });
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

