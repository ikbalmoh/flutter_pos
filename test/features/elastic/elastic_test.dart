import 'package:flutter_test/flutter_test.dart';
import 'package:selleri/features/elastic/model/elastic.dart';

class MockModel {
  final String id;
  final String name;

  MockModel({required this.id, required this.name});

  factory MockModel.fromJson(Map<String, dynamic> json) {
    if (json['id'] == null || json['name'] == null) {
      throw FormatException('Missing fields');
    }
    return MockModel(
      id: json['id'] as String,
      name: json['name'] as String,
    );
  }
}

void main() {
  group('ElasticHits Deserialization', () {
    test('sources mapping parses valid models and ignores failed models', () {
      final hits = ElasticHits(
        total: const ElasticTotal(value: 3, relation: 'eq'),
        hits: [
          const ElasticHit(
            id: '1',
            source: {'id': '1', 'name': 'Item 1'},
          ),
          const ElasticHit(
            id: '2',
            source: {'id': '2'}, // Missing 'name', will throw FormatException in fromJson
          ),
          const ElasticHit(
            id: '3',
            source: {'id': '3', 'name': 'Item 3'},
          ),
        ],
      );

      final results = hits.sources(MockModel.fromJson);

      expect(results.length, 2);
      expect(results[0].id, '1');
      expect(results[0].name, 'Item 1');
      expect(results[1].id, '3');
      expect(results[1].name, 'Item 3');
    });

    test('sources mapping handles null sources correctly', () {
      final hits = ElasticHits(
        total: const ElasticTotal(value: 2, relation: 'eq'),
        hits: [
          const ElasticHit(
            id: '1',
            source: {'id': '1', 'name': 'Item 1'},
          ),
          const ElasticHit(
            id: '2',
            source: null,
          ),
        ],
      );

      final results = hits.sources(MockModel.fromJson);

      expect(results.length, 1);
      expect(results[0].id, '1');
    });
  });
}
