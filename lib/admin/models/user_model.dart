import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String email;
  final String name;
  final String faceChar;

  const UserModel({required this.email, required this.faceChar, required this.name});

  factory UserModel.fromJson(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] as String,
      email: map['email'] as String,
      faceChar: (map['face_char']) as String,
    );
  }
  
  @override
  List<Object?> get props => [
    email,
    name, 
    faceChar
  ];


}