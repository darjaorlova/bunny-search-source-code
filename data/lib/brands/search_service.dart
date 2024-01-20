import 'dart:math';

import 'package:data/database/model/brand_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class SearchService {
  Future<List<BrandEntity>> search({
    required List<BrandEntity> allBrands,
    required String query,
  }) async =>
      compute(
        searchSync,
        SearchQuery(allBrands, query),
      );

  @visibleForTesting
  static List<BrandEntity> searchSync(SearchQuery query) {
    final searchTerm = query.query.toLowerCase();
    final filtered = query.allBrands.expand<SearchResult>((brand) {
      final title = brand.title.toLowerCase();
      if (title == searchTerm) {
        return [SearchResult(0, brand)];
      }
      if (title.contains(searchTerm)) {
        return [SearchResult(1, brand)];
      }
      final maxDistance = title.length > 7 ? 4 : 2;
      final nameDistance = levenshteinDistance(title, searchTerm, maxDistance);
      if (nameDistance <= maxDistance) {
        return [SearchResult(nameDistance, brand)];
      } else {
        return [];
      }
    }).toList();
    filtered.sort((a, b) {
      return a.distance.compareTo(b.distance);
    });
    return filtered.map((result) => result.brand).toList();
  }

  @visibleForTesting
  static int levenshteinDistance(String a, String b, int maxDistance) {
    if (a == b) {
      return 0;
    }
    if (a.isEmpty) {
      return b.length <= maxDistance ? b.length : maxDistance + 1;
    }
    if (b.isEmpty) {
      return a.length <= maxDistance ? a.length : maxDistance + 1;
    }

    int aLength = a.length;
    int bLength = b.length;
    List<List<int>> matrix = List.generate(
      bLength + 1,
      (i) => List.generate(aLength + 1, (j) => 0, growable: false),
      growable: false,
    );

    for (int i = 0; i <= aLength; i++) {
      matrix[0][i] = i;
    }
    for (int i = 0; i <= bLength; i++) {
      matrix[i][0] = i;
    }

    for (int i = 1; i <= bLength; i++) {
      int minRowValue = maxDistance + 1;
      for (int j = 1; j <= aLength; j++) {
        int cost = (a[j - 1] == b[i - 1]) ? 0 : 1;
        matrix[i][j] = _min(
          matrix[i - 1][j] + 1, // deletion
          matrix[i][j - 1] + 1, // insertion
          matrix[i - 1][j - 1] + cost, // substitution
        );

        minRowValue = min(minRowValue, matrix[i][j]);
      }

      if (minRowValue > maxDistance) {
        return maxDistance + 1;
      }
    }

    return matrix[bLength][aLength];
  }

  static int _min(int a, int b, int c) {
    return (a < b) ? (a < c ? a : c) : (b < c ? b : c);
  }

  @visibleForTesting
  static int hammingDistance(String a, String b) {
    if (a.length != b.length) {
      throw ArgumentError('Strings must be of equal length');
    }

    int distance = 0;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) {
        distance++;
      }
    }
    return distance;
  }
}

// TODO: Update to Dart 3 & use records
class SearchQuery extends Equatable {
  final List<BrandEntity> allBrands;
  final String query;

  const SearchQuery(this.allBrands, this.query);

  @override
  List<Object?> get props => [
        allBrands,
        query,
      ];
}

class SearchResult extends Equatable {
  final int distance;
  final BrandEntity brand;

  const SearchResult(this.distance, this.brand);

  @override
  List<Object?> get props => [
        distance,
        brand,
      ];
}
