import 'package:equatable/equatable.dart';
import 'package:tv_shows/domain/entities/tv_show_detail.dart';

class AuthorModel extends Equatable {
  AuthorModel({
    required this.id,
    required this.creditId,
    required this.name,
    required this.gender,
    required this.profilePath,
  });

  final int id;
  final String? creditId;
  final String? name;
  final int? gender;
  final String? profilePath;

  factory AuthorModel.fromJson(Map<String, dynamic> json) => AuthorModel(
        id: json["id"],
        creditId: json["credit_id"],
        name: json["name"],
        gender: json["gender"],
        profilePath: json["profile_path"],
      );

  @override
  List<Object?> get props => [
        id,
        creditId,
        name,
        gender,
        profilePath,
      ];

  Author toEntity() => Author(
        id: id,
        creditId: creditId ?? "",
        name: name ?? "",
        gender: gender ?? 0,
        profilePath: profilePath ?? "",
      );
}
