import 'package:equatable/equatable.dart';

class DonorAuthEntity extends Equatable {
  final String? donorAuthId;
  final String fullName;
  final String email;
  final String? phoneNumber;
  final String? profilePicture;

  const DonorAuthEntity({
    this.donorAuthId, 
    required this.fullName, 
    required this.email, 
    this.phoneNumber, 
    this.profilePicture
  });
  
  @override
  List<Object?> get props => [donorAuthId, fullName, email, phoneNumber, profilePicture];
}
