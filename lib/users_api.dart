import 'dart:convert';

import 'package:localstorage/localstorage.dart';
import 'package:http/http.dart' as http;

class UserApi {
  final LocalStorage _storage = LocalStorage('my_app');

  Future<void> _ensureInitialized() async {
    await _storage.ready;
  }

  Future<List<Map<String, dynamic>>> getListUsers() async {
    try {
      final response = await http.get(Uri.parse('https://app.agrocampo.net.co/flutter/Api/simple-rest/items/read'));
      final data = jsonDecode(response.body);
      final List<Map<String, dynamic>> dataList = List<Map<String, dynamic>>.from(data['items']);

      return dataList;
    }catch (err){
      print('Error on getDataApi: $err');
    }

    return [];
  }

  Future<http.Response> addNewUserLocal(newUser) async {
    final response = await http.post(
      Uri.parse('https://app.agrocampo.net.co/flutter/Api/simple-rest/items/create'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(newUser)
    );
    print(response.statusCode);
    if (response.statusCode == 201) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      print(jsonDecode(response.body));
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to create album.');
    }
    return response;
  }

  Future<void> setUserLocal(user) async {
    print(user);
    final response = await http.post(
        Uri.parse('https://app.agrocampo.net.co/flutter/Api/simple-rest/items/update'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(user)
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      print(jsonDecode(response.body));
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to create album.');
    }
  }

  Future<void> deleteUser(int id) async {
    final response = await http.post(
        Uri.parse('https://app.agrocampo.net.co/flutter/Api/simple-rest/items/delete'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          "id" : id
        })
    );

    print(response.statusCode);
    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      print(jsonDecode(response.body));
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to create album.');
    }
    print(response);
  }

  int getNextId(List<Map<String, dynamic>> records) {
    int maxId = 0;
    for(var user in records){
      int userId = user['id'];
      if(userId > maxId){
        maxId = userId;
      }
    }
    return maxId + 1;
  }
}
