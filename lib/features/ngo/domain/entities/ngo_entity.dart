import 'package:equatable/equatable.dart';

class NgoEntity extends Equatable {
  final String? id;
  final String name;
  final String registrationNumber;
  final String contactPerson;
  final String phone;
  final String email;
  final String address;
  final List<String> focusAreas;
  final String? photo;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const NgoEntity({
    this.id,
    required this.name,
    required this.registrationNumber,
    required this.contactPerson,
    required this.phone,
    required this.email,
    required this.address,
    this.focusAreas = const [],
    this.photo,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    registrationNumber,
    contactPerson,
    phone,
    email,
    address,
    focusAreas,
    photo,
    createdAt,
    updatedAt,
  ];
}
