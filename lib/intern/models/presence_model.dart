import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class PresenceModel extends Equatable {
  final String status;
  final DateTime checkIn;
  final DateTime checkOut;
  final String statement;

  const PresenceModel({required this.status, required this.checkIn, required this.checkOut, required this.statement});

  factory PresenceModel.fromJson(Map<String, dynamic> map) {
    return PresenceModel(
      status: map['status'] as String,
      checkIn: (map['check_in'] as Timestamp).toDate(),
      checkOut: (map['check_out'] as Timestamp).toDate(),
      statement: map['statement'] as String,
    );
  }
  
  @override
  List<Object?> get props => [
    status,
    checkIn, 
    checkOut,
    statement
  ];


}