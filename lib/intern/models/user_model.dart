import 'package:equatable/equatable.dart';

class InternModel extends Equatable {
  final String email;
  final String name;
  final String faceChar;

  const InternModel({required this.email, required this.faceChar, required this.name});

  factory InternModel.fromJson(Map<String, dynamic> map) {
    return InternModel(
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