import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:selleri/data/models/table.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:selleri/providers/auth/auth_provider.dart';
import 'package:selleri/providers/cart/cart_provider.dart';
import 'package:selleri/providers/outlet/outlet_provider.dart';

part 'tables_provider.g.dart';

@riverpod
class Tables extends _$Tables {
  final db = FirebaseFirestore.instance;

  @override
  Stream<List<Table>> build({int floor = 1}) {
    final authState = ref.watch(authProvider).value;
    final outletState = ref.watch(outletProvider).value;

    if (authState is Authenticated && outletState is OutletSelected) {
      final tablesRef = db
          .collection(
              '${authState.user.user.company.idCompany}/${outletState.outlet.idOutlet}/tables')
          .where('floor', isEqualTo: floor)
          .orderBy('name')
          .orderBy('capacity')
          .withConverter<Table>(
              fromFirestore: Table.fromFirestore,
              toFirestore: (Table table, _) => table.toJson());

      return tablesRef.snapshots().map((snapshot) {
        final tables = snapshot.docs.map((doc) => doc.data()).toList();
        return tables;
      });
    }
    return Stream.empty();
  }

  void markTables(List<Table> tables) async {
    final cart = ref.watch(cartProvider);
    final authState = ref.read(authProvider).value as Authenticated;
    final outletState = ref.read(outletProvider).value as OutletSelected;

    String collection =
        '${authState.user.user.company.idCompany}/${outletState.outlet.idOutlet}/tables';

    for (var table in tables) {
      await db
          .collection(collection)
          .doc(table.id)
          .update({"used_by": cart.idTransaction});
    }
  }
}
