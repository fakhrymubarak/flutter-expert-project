import 'package:equatable/equatable.dart';

class AuthorModel extends Equatable {
  AuthorModel({
    required this.id,
    required this.creditId,
    required this.name,
    required this.gender,
    required this.profilePath,
  });

  int id;
  String creditId;
  String name;
  int gender;
  String profilePath;

  factory AuthorModel.fromJson(Map<String, dynamic> json) => AuthorModel(
    id: json["id"],
    creditId: json["credit_id"],
    name: json["name"],
    gender: json["gender"],
    profilePath: json["profile_path"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "credit_id": creditId,
    "name": name,
    "gender": gender,
    "profile_path": profilePath,
  };

  @override
  List<Object?> get props => [
    id,
    creditId,
    name,
    gender,
    profilePath,
  ];
}
