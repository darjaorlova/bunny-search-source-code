import 'package:data/brands/search_service.dart';
import 'package:data/database/model/brand_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Levenshtein Distance Tests', () {
    test('Identical Strings', () {
      expect(
        SearchService.levenshteinDistance('example', 'example', 10),
        equals(0),
      );
    });

    test('Empty Strings', () {
      expect(SearchService.levenshteinDistance('', '', 5), equals(0));
    });

    test('One Empty String', () {
      expect(SearchService.levenshteinDistance('', 'nonempty', 8), equals(8));
    });

    test('Strings with Max Distance Exceeded', () {
      expect(
        SearchService.levenshteinDistance('short', 'verylongstring', 3),
        4, // maxDistance (3) + 1
      );
    });

    test('Kitten to Sitting', () {
      expect(
        SearchService.levenshteinDistance('kitten', 'sitting', 10),
        equals(3),
      );
    });

    test('Urvan Deca to Urban Decay', () {
      expect(
        SearchService.levenshteinDistance('Urvan Deca', 'Urban Decay', 10),
        equals(2),
      );
    });

    test('Apple and Appel', () {
      expect(SearchService.levenshteinDistance('Apple', 'Appel', 2), equals(2));
    });

    test('Apple and Apple', () {
      expect(SearchService.levenshteinDistance('Apple', 'Apple', 0), equals(0));
    });

    test('Cat and Cot', () {
      expect(SearchService.levenshteinDistance('cat', 'cot', 1), equals(1));
    });

    test('Bapple and Appleb', () {
      expect(
        SearchService.levenshteinDistance('bapple', 'appleb', 2),
        equals(2),
      );
    });

    test('Completely Different Strings', () {
      expect(SearchService.levenshteinDistance('abcd', 'xyz', 10), equals(4));
    });

    test('Long String with Max Distance Not Exceeded', () {
      expect(
        SearchService.levenshteinDistance('a' * 100, 'a' * 99 + 'b', 2),
        equals(1),
      );
    });

    test('Case Sensitivity', () {
      expect(
        SearchService.levenshteinDistance('Case', 'case', 4),
        equals(1),
      );
    });

    test('Max Distance Zero', () {
      expect(
        SearchService.levenshteinDistance('example', 'sample', 0),
        1, // maxDistance (0) + 1
      );
    });

    test('Max Distance Five', () {
      expect(
        SearchService.levenshteinDistance('example', 'sampleverylong', 5),
        6, // maxDistance (5) + 1
      );
    });
  });

  group('Makeup Brand Search Tests', () {
    List<BrandEntity> makeupBrands = [];

    setUp(() {
      makeupBrands = _createMockBrands(
        [
          'Maybelline',
          'Lancome',
          'Estee Lauder',
          'Loreal',
          'Nars',
          'Revlon',
          'Clinique',
          'MAC',
          'Bobbi Brown',
          'Dior',
          'Chanel',
          'Yves Saint Laurent',
          'Fenty Beauty',
          'Huda Beauty',
          'Anastasia Beverly Hills',
          'Charlotte Tilbury',
          'NYX',
          'Tarte',
          'Too Faced',
          'Urban Decay',
        ],
      );
    });

    test('Exact Match: Loreal', () {
      var query = SearchQuery(makeupBrands, 'Loreal');
      var results =
          SearchService.searchSync(query).map((b) => b.title).toList();
      expect(results, contains(matches('Loreal')));
    });

    test('Typo in Brand Name (1 character off): Nars as Narsa', () {
      var query = SearchQuery(makeupBrands, 'Narsa');
      var results =
          SearchService.searchSync(query).map((b) => b.title).toList();
      expect(results, contains(matches('Nars')));
    });

    test('Typo in Brand Name (2 characters off): Revlon as Revoln', () {
      var query = SearchQuery(makeupBrands, 'Revoln');
      var results =
          SearchService.searchSync(query).map((b) => b.title).toList();
      expect(results, contains(matches('Revlon')));
    });

    test(
        'Typo in Longer Brand Name (3 characters off): Maybelline as Maybeline',
        () {
      var query = SearchQuery(makeupBrands, 'Maybeline');
      var results =
          SearchService.searchSync(query).map((b) => b.title).toList();
      expect(results, contains(matches('Maybelline')));
    });

    test('Typo in Longer Brand Name (4 characters off): Lancome as Lankomee',
        () {
      var query = SearchQuery(makeupBrands, 'Lankomee');
      var results =
          SearchService.searchSync(query).map((b) => b.title).toList();
      expect(results, contains(matches('Lancome')));
    });

    test('No Match for Completely Different String', () {
      var query = SearchQuery(makeupBrands, 'Random Brand');
      var results =
          SearchService.searchSync(query).map((b) => b.title).toList();
      expect(results.isEmpty, isTrue);
    });

    test('No Match for Long String with High Levenshtein Distance', () {
      var query = SearchQuery(makeupBrands, 'ThisIsNotAMakeupBrand');
      var results =
          SearchService.searchSync(query).map((b) => b.title).toList();
      expect(results.isEmpty, isTrue);
    });

    // Case Sensitivity and Partial Matches
    test('Case Insensitivity: CHANEL as chanel', () {
      var query = SearchQuery(makeupBrands, 'chanel');
      var results =
          SearchService.searchSync(query).map((b) => b.title).toList();
      expect(results, contains(matches('Chanel')));
    });

    test('Partial Match: Estee for Estee Lauder', () {
      var query = SearchQuery(makeupBrands, 'Estee');
      var results =
          SearchService.searchSync(query).map((b) => b.title).toList();
      expect(results, contains(matches('Estee Lauder')));
    });

    test('Mixed Case: Yves Saint Laurent as yvEs SAINT lauRent', () {
      var query = SearchQuery(makeupBrands, 'yvEs SAINT lauRent');
      var results =
          SearchService.searchSync(query).map((b) => b.title).toList();
      expect(results, contains(matches('Yves Saint Laurent')));
    });

    test('Typo in Medium Length Brand Name (1 character off): Dior as Diorr',
        () {
      var query = SearchQuery(makeupBrands, 'Diorr');
      var results =
          SearchService.searchSync(query).map((b) => b.title).toList();
      expect(results, contains(matches('Dior')));
    });

    test('Typo in Short Brand Name (1 character off): MAC as MCA', () {
      var query = SearchQuery(makeupBrands, 'MCA');
      var results =
          SearchService.searchSync(query).map((b) => b.title).toList();
      expect(results, contains(matches('MAC')));
    });

    test(
        'Typo in Short Brand Name (1 character off and extra character): NYX as NYDX',
        () {
      var query = SearchQuery(makeupBrands, 'NYDX');
      var results =
          SearchService.searchSync(query).map((b) => b.title).toList();
      expect(results, contains(matches('NYX')));
    });

    test('Typo in Brand Name with Numeric Character: Too Faced as To0 Faced',
        () {
      var query = SearchQuery(makeupBrands, 'To0 Faced');
      var results =
          SearchService.searchSync(query).map((b) => b.title).toList();
      expect(results, contains(matches('Too Faced')));
    });

    test(
        'Typo in Long Brand Name (Multiple characters off): Anastasia as Anastsia',
        () {
      var query = SearchQuery(makeupBrands, 'Anastsia');
      var results =
          SearchService.searchSync(query).map((b) => b.title).toList();
      expect(results, contains(matches('Anastasia Beverly Hills')));
    });
  });
}

List<BrandEntity> _createMockBrands(List<String> titles) {
  return titles
      .map(
        (t) => BrandEntity(
          title: t,
          description: '',
          organizationsIds: [],
          hasVeganProducts: true,
          logoUrl: '',
          popular: false,
        ),
      )
      .toList();
}
