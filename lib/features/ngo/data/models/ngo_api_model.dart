import 'package:aashwaas/features/ngo/domain/entities/ngo_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ngo_api_model.g.dart';

@JsonSerializable()
class NgoApiModel {
  @JsonKey(name: '_id')
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

  NgoApiModel({
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

  factory NgoApiModel.fromJson(Map<String, dynamic> json) =>
      _$NgoApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$NgoApiModelToJson(this);

  NgoEntity toEntity() {
    return NgoEntity(
      id: id,
      name: name,
      registrationNumber: registrationNumber,
      contactPerson: contactPerson,
      phone: phone,
      email: email,
      address: address,
      focusAreas: focusAreas,
      photo: photo,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  static List<NgoEntity> toEntityList(List<NgoApiModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }
}
