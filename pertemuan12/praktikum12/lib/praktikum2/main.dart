import 'user.dart';

void main(){
  print('=== DEBUG: Check JSON Structure ===');

  // Object Dart ke JSON
  User user = User(
    id: 1,
    name: 'Fallujah',
    email: 'fallujah@gmail.com',
    createdAt: DateTime.now(),
  );

  Map<String, dynamic> userJson = user.toJson();
  print('User.toJson() result: $userJson');
  print('Field names: ${userJson.keys.toList()}');

  print('\n=== TEST: JSON to Object Dart ===');

  //gunakan field names yang sama dengan toJson() result
  Map<String, dynamic> jsonData = {
    'id': 2,
    'name': 'John Doe',
    'email': 'johndoe@gmail.com',
    'created_at': '2022-05-25T12:00:00.000Z', //perhatikan casing
  };

  //debug print json structure
  print('Json data to parse: $jsonData');
  print('JSON keys: ${jsonData.keys.toList()}'); 
  print('id: ${jsonData['id']} (type: ${jsonData['id'].runtimeType})'); 
  print('name: ${jsonData['name']} (type: ${jsonData['name'].runtimeType})'); 
  print('email: ${jsonData['email']} (type: ${jsonData['email'].runtimeType})'); 
  print('createdAt: ${jsonData['created_at']} (type: ${jsonData['created_at'].runtimeType})'); 

  try { 
    User userFromJson = User.fromJson(jsonData); 
    print('SUCCESS: User from JSON: $userFromJson'); 
  } catch (e, stack) { 
    print('ERROR: $e'); 
    print('Stack trace: $stack'); 
  }

  print('\n=== TEST: Handle Missing Fields ==='); 

  //test missing fields
  Map<String, dynamic> incompleteJson = {
    'id': 3,
    //'name': missing,
    'email': 'johndoe@gmail.com',
    //'created_at': missing,
  };

  try { 
    User userFromIncomplete = User.fromJson(incompleteJson); 
    print('User from incomplete JSON: $userFromIncomplete'); 
  } catch (e) { 
    print('Error with incomplete JSON: $e'); 
  }
}