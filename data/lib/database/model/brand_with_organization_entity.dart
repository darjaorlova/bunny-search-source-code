import 'package:equatable/equatable.dart';
import 'package:floor/floor.dart';

@Entity(
  tableName: 'brands_with_organizations',
  primaryKeys: ['brand_title', 'org_id'],
)
class BrandWithOrganizationEntity extends Equatable {
  @ColumnInfo(name: 'brand_title')
  final String brandTitle;
  @ColumnInfo(name: 'org_id')
  final String orgId;

  const BrandWithOrganizationEntity({
    required this.brandTitle,
    required this.orgId,
  });

  @override
  List<Object?> get props => [brandTitle, orgId];
}
