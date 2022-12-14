import 'package:equatable/equatable.dart';
import 'package:tv_shows/domain/entities/tv_show_detail.dart';

class NetworkModel extends Equatable {
  NetworkModel({
    required this.id,
    required this.name,
    required this.logoPath,
    required this.originCountry,
  });

  final int id;
  final String? name;
  final String? logoPath;
  final String? originCountry;

  factory NetworkModel.fromJson(Map<String, dynamic> json) => NetworkModel(
        id: json["id"],
        name: json["name"],
        logoPath: json["logo_path"] == null ? null : json["logo_path"],
        originCountry: json["origin_country"],
      );

  @override
  List<Object?> get props => [
        id,
        name,
        logoPath,
        originCountry,
      ];

  Network toEntity() => Network(
        id: id,
        name: name ?? "",
        logoPath: logoPath ?? "",
        originCountry: originCountry ?? "",
      );
}
