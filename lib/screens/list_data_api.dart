import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ListDataApi extends StatefulWidget {
  @override
  State<ListDataApi> createState() => _ListDataApi();
}

class _ListDataApi extends State<ListDataApi> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder<List<Map<String, dynamic>>>(
          future: getDataAPI(),
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
                          title: Text(user['title'].substring(0, 10)),
                          subtitle: Text(user['body'].substring(0, 20)),
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

Future<List<Map<String, dynamic>>> getDataAPI() async {
  try {
    final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));
    final List<dynamic> data = jsonDecode(response.body);
    final List<Map<String, dynamic>> dataList = List<Map<String, dynamic>>.from(data);

    return dataList;
  }catch (err){
    print('Error on getDataApi: $err');
  }

  return [];
}

