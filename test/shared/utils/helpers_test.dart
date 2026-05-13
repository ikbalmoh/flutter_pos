import 'package:flutter_test/flutter_test.dart';
import 'package:selleri/shared/utils/helpers.dart';

void main() {
  group('Helpers', () {
    final helpers = Helpers();

    test('ceilToNearestIDR rounds correctly', () {
      // Already a multiple of 1000
      expect(helpers.ceilToNearestIDR(1000), 1000);
      expect(helpers.ceilToNearestIDR(2000), 2000);

      // Remainder <= 500 (Round up to nearest 500)
      expect(helpers.ceilToNearestIDR(1100), 1500);
      expect(helpers.ceilToNearestIDR(1500), 1500);
      expect(helpers.ceilToNearestIDR(1250), 1500);

      // Remainder > 500 (Round up to nearest 1000)
      expect(helpers.ceilToNearestIDR(1600), 2000);
      expect(helpers.ceilToNearestIDR(1750), 2000);
      expect(helpers.ceilToNearestIDR(1999), 2000);
    });
  });
}
