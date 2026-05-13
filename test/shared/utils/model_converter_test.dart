import 'package:flutter_test/flutter_test.dart';
import 'package:selleri/shared/utils/model_converter.dart';

void main() {
  group('ModelConverter', () {
    test('dynamicToDouble converts various types correctly', () {
      expect(ModelConverter.dynamicToDouble('10.5'), 10.5);
      expect(ModelConverter.dynamicToDouble(10), 10.0);
      expect(ModelConverter.dynamicToDouble(10.5), 10.5);
      expect(ModelConverter.dynamicToDouble(null), 0.0);
    });

    test('dynamicToBool converts various types correctly', () {
      expect(ModelConverter.dynamicToBool('true'), true);
      expect(ModelConverter.dynamicToBool('false'), false);
      expect(ModelConverter.dynamicToBool(1), true);
      expect(ModelConverter.dynamicToBool(0), false);
      expect(ModelConverter.dynamicToBool(true), true);
      expect(ModelConverter.dynamicToBool(false), false);
      expect(ModelConverter.dynamicToBool(null), false);
    });

    test('dynamicToNum converts correctly', () {
      expect(ModelConverter.dynamicToNum(10), 10);
      expect(ModelConverter.dynamicToNum(10.5), 10.5);
      expect(ModelConverter.dynamicToNum('string'), null);
      expect(ModelConverter.dynamicToNum(null), null);
    });

    test('dynamicToInt converts correctly', () {
      expect(ModelConverter.dynamicToInt(10), 10);
      expect(ModelConverter.dynamicToInt('string'), null);
      expect(ModelConverter.dynamicToInt(null), null);
    });

    test('dynamicToString and nullableToString convert correctly', () {
      expect(ModelConverter.dynamicToString(10), '10');
      expect(ModelConverter.dynamicToString(null), null);
      expect(ModelConverter.dynamicToString(null, returnEmptyString: true), '');
      
      expect(ModelConverter.nullableToString(10), '10');
      expect(ModelConverter.nullableToString(null), '');
    });

    test('toStringList converts correctly', () {
      expect(ModelConverter.toStringList(['a', 1, true]), ['a', '1', 'true']);
      expect(ModelConverter.toStringList(null), []);
      expect(ModelConverter.toStringList('not a list'), []);
    });

    test('stringToMap converts correctly', () {
      const jsonStr = '{"key": "value", "id": 1}';
      final map = ModelConverter.stringToMap(jsonStr);
      expect(map, isA<Map<String, dynamic>>());
      expect(map['key'], 'value');
      expect(map['id'], 1);
    });
  });
}
