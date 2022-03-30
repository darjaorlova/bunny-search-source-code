import 'package:domain/organizations/model/organization.dart';
import 'package:equatable/equatable.dart';

class Brand extends Equatable {
  final String title;
  final String description;
  final Map<String, Organization> organizations;
  final bool? hasVeganProducts;
  final String? logoUrl;

  Brand(
      {required this.title,
      required this.description,
      required this.organizations,
      required this.hasVeganProducts,
      required this.logoUrl});

  Brand copyWith(
          {String? title,
          String? description,
          Map<String, Organization>? organizations,
          bool? hasVeganProducts,
          String? logoUrl}) =>
      Brand(
          title: title ?? this.title,
          description: description ?? this.description,
          organizations: organizations ?? this.organizations,
          hasVeganProducts: hasVeganProducts ?? this.hasVeganProducts,
          logoUrl: logoUrl);

  @override
  List<Object?> get props =>
      [title, description, organizations, hasVeganProducts, logoUrl];
}
