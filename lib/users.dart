import 'package:localstorage/localstorage.dart';

class UserStorage {
  final LocalStorage _storage = LocalStorage('my_app');

  Future<void> _ensureInitialized() async {
    await _storage.ready;
  }

  Future<List<Map<String, dynamic>>> getListUsers() async {
    await _ensureInitialized();
    List<Map<String, dynamic>> records =
    (_storage.getItem('records') as List<dynamic>)
        .cast<Map<String, dynamic>>();
    return records;
  }

  Future<void> addNewUserLocal(newUser) async {
    await _ensureInitialized();
    List<Map<String, dynamic>> records =
    (_storage.getItem('records') as List<dynamic>)
        .cast<Map<String, dynamic>>() ?? [];

    newUser['id'] = getNextId(records);
    records.add(newUser);
    _storage.setItem('records', records);
  }

  Future<void> DeleteUser(int id) async {
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
