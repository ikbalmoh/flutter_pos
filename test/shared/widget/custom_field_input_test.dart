import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:selleri/shared/model/custom_field.dart' as model;
import 'package:selleri/shared/widget/custom_field_input.dart';

void main() {
  group('CustomFieldInput RadioButton tests', () {
    testWidgets('renders RadioButton field when value is String "true" without error',
        (WidgetTester tester) async {
      const field = model.CustomField(
        id: '1',
        label: 'Is Active',
        field: 'is_active',
        typeData: model.TypeData.boolean,
        inputType: model.FieldType.radioButton,
        isRequired: true,
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CustomFieldInput(
              field: field,
              value: 'true',
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      expect(find.textContaining('Is Active'), findsOneWidget);
    });

    testWidgets('renders RadioButton field when value is String "false" without error',
        (WidgetTester tester) async {
      const field = model.CustomField(
        id: '2',
        label: 'Is Member',
        field: 'is_member',
        typeData: model.TypeData.boolean,
        inputType: model.FieldType.radioButton,
        isRequired: false,
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CustomFieldInput(
              field: field,
              value: 'false',
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      expect(find.textContaining('Is Member'), findsOneWidget);
    });
  });
}
