import 'package:domain/organizations/model/organization_brand.dart';
import 'package:equatable/equatable.dart';

class OrganizationBrandDetails extends Equatable {
  final OrganizationBrand info;
  final String logoSrc;

  const OrganizationBrandDetails({
    required this.info,
    required this.logoSrc,
  });

  @override
  List<Object?> get props => [info, logoSrc];
}
