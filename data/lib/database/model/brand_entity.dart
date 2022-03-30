import 'package:equatable/equatable.dart';
import 'package:floor/floor.dart';

@Entity(tableName: 'brands')
class BrandEntity extends Equatable {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final String title;
  final String description;
  final List<String> organizationsIds;
  final bool? hasVeganProducts;
  final String? logoUrl;
  final bool popular;

  BrandEntity(
      {this.id,
      required this.title,
      required this.description,
      required this.organizationsIds,
      required this.hasVeganProducts,
      required this.logoUrl,
      required this.popular});

  @override
  List<Object?> get props => [
        title,
        description,
        organizationsIds,
        hasVeganProducts,
        logoUrl,
        popular
      ];
}
