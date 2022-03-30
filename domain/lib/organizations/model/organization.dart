import 'package:domain/organizations/model/organization_type.dart';
import 'package:equatable/equatable.dart';

class Organization extends Equatable {
  final String id;
  final OrganizationType type;
  final int brandsCount;
  final String website;

  const Organization({required this.id, required this.type, required this.brandsCount, required this.website});

  @override
  List<Object> get props => [id, type, brandsCount, website];
}
