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

  Future<http.Response> addNewUserLocal(Object newUser) async {
    return http.post(
      Uri.parse('https://app.agrocampo.net.co/flutter/Api/simple-rest/items/create'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },

    );
  }

  Future<void> setUserLocal(user) async {
    await _ensureInitialized();
    List<Map<String, dynamic>> records =
        (_storage.getItem('records') as List<dynamic>)
            .cast<Map<String, dynamic>>() ?? [];

    final existingUserIndex = records.indexWhere((record) => record['id'] == user['id']);
    if (existingUserIndex != -1) {
      records[existingUserIndex] = user;
      _storage.setItem('records', records);
    } else {
      print('Usuario no encontrado');
    }
  }

  Future<void> deleteUser(int id) async {
    await _ensureInitialized();
    List<Map<String, dynamic>> records =
    (_storage.getItem('records') as List<dynamic>)
        .cast<Map<String, dynamic>>();

    try {
      records.removeWhere((record) => record['id'] == id);
      await _storage.setItem('records', records);
      print('Usuario eliminado con éxito');
    } catch (err) {
      print('Error al eliminar el usuario: $err');
    }
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
