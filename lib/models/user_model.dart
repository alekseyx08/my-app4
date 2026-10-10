class UserModel {
  final int? id;
  final String name;
  final int age;

  UserModel({this.id, required this.name, required this.age});

  Map<String, dynamic> toMap() => {'id': id, 'name': name, 'age': age};

  factory UserModel.fromMap(Map<String, dynamic> map) =>
      UserModel(id: map['id'], name: map['name'], age: map['age']);
}
