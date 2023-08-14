import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../users_api.dart';

class ListDataApi extends StatefulWidget {
  @override
  State<ListDataApi> createState() => _ListDataApi();
}

class _ListDataApi extends State<ListDataApi> {
  final UserApi userApi = UserApi();

  @override
  Widget build(BuildContext context) {
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

