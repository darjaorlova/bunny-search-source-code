import 'package:domain/organizations/model/organization_type.dart';
import 'package:equatable/equatable.dart';

class OrganizationDetails extends Equatable {
  final String id;
  final String title;
  final String logoSrc;
  final int brandsCount;
  final OrganizationType type;

  const OrganizationDetails({
    required this.id,
    required this.title,
    required this.logoSrc,
    required this.brandsCount,
    required this.type,
  });

  @override
  List<Object?> get props => [id, title, logoSrc, brandsCount, type];
}
