import 'package:equatable/equatable.dart';

class OfficeDataModel extends Equatable {
  final String lat;
  final String long;

  const OfficeDataModel({required this.lat, required this.long});

  factory OfficeDataModel.fromJson(Map<String, dynamic> map) {
    return OfficeDataModel(
      lat: map['lat'] as String,
      long: map['long'] as String,
    );
  }
  
  @override
  List<Object?> get props => [
    lat,
    long
  ];
}