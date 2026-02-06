import 'package:equatable/equatable.dart';

class VolunteerAuthEntity extends Equatable {
  final String? volunteerAuthId;
  final String fullName;
  final String email;
  final String? phoneNumber;
  final String? password;
  final String? profilePicture;
  final DateTime? createdAt;

  const VolunteerAuthEntity({
    this.volunteerAuthId, 
    required this.fullName, 
    required this.email, 
    this.phoneNumber, 
    this.profilePicture,
    this.password,
    this.createdAt,
  });
  
  @override
  List<Object?> get props => [
    volunteerAuthId,
    fullName,
    email,
    phoneNumber,
    profilePicture,
    password,
    createdAt,
  ];
}
