import 'dart:convert';

import 'package:http/http.dart' as http;

class UserApi {

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

  Future<http.Response> apiCallPost(body, action) async {
    final response = await http.post(
        Uri.parse('https://app.agrocampo.net.co/flutter/Api/simple-rest/items/$action'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(body)
    );

    return response;
  }

  Future<String> addNewUserLocal(newUser) async {
    final response = await apiCallPost(newUser, 'create');
    if (response.statusCode != 201) {
      throw Exception('Failed to create user.');
    }
    return jsonDecode(response.body)['message'];
  }

  Future<String> setUserLocal(user) async {
    final response = await apiCallPost(user, 'update');
    if (response.statusCode != 200) {
      throw Exception('Failed to update user.');
    }
    return jsonDecode(response.body)['message'];
  }

  Future<String> deleteUser(int id) async {
    final response = await apiCallPost({"id" : id}, 'delete');
    if (response.statusCode != 200) {
      throw Exception('Failed to delete user.');
    }
    return jsonDecode(response.body)['message'];
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
