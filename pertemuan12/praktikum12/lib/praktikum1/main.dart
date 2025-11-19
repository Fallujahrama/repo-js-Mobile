import 'User.dart';

void main() {
  //object dart ke JSON
  User user = User(
    id: 1,
    name: 'Fallujah',
    email: 'fallujah@gmail.com',
    createdAt: DateTime.now(),
  );

  Map<String, dynamic> userJson = user.toJson();
  print('User JSON: $userJson');

  Map<String, dynamic> jsonData = {
    'id': 2,
    'name': 'John Doe',
    'email': 'johndoe@gmail.com',
    'created_at': '2022-05-25T12:00:00.000Z',
  };

  User userFromJson = User.fromJson(jsonData);
  print('User from JSON: ${userFromJson.name}');
}
  