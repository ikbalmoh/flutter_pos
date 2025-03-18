import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:selleri/data/models/table.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:selleri/providers/auth/auth_provider.dart';
import 'package:selleri/providers/outlet/outlet_provider.dart';

part 'tables_provider.g.dart';

@riverpod
class Tables extends _$Tables {
  final db = FirebaseFirestore.instance;

  @override
  Stream<List<Table>> build({int? floor}) {
    final authState = ref.watch(authProvider).value;
    final outletState = ref.watch(outletProvider).value;

    if (authState is Authenticated && outletState is OutletSelected) {
      Query<Table> tablesRef = db
          .collection(
              '${authState.user.user.company.idCompany}/${outletState.outlet.idOutlet}/tables')
          .orderBy('name')
          .orderBy('capacity')
          .withConverter<Table>(
              fromFirestore: Table.fromFirestore,
              toFirestore: (Table table, _) => table.toJson());

      if (floor != null) {
        tablesRef = tablesRef.where('floor', isEqualTo: floor);
      }

      return tablesRef.snapshots().map((snapshot) {
        final tables = snapshot.docs.map((doc) => doc.data()).toList();
        return tables;
      });
    }
    return Stream.empty();
  }

  Future<List<Table>> getTables(List<String> names) async {
    final authState = ref.read(authProvider).value as Authenticated;
    final outletState = ref.read(outletProvider).value as OutletSelected;

    String collectionPath =
        '${authState.user.user.company.idCompany}/${outletState.outlet.idOutlet}/tables';

    final tables = await db
        .collection(collectionPath)
        .withConverter(
            fromFirestore: Table.fromFirestore,
            toFirestore: (Table table, _) => table.toJson())
        .where('name', whereIn: names)
        .get();
    return tables.docs.map((doc) => doc.data()).toList();
  }

  void markTables(String transactionNo, List<Table> tables) async {
    final authState = ref.read(authProvider).value as Authenticated;
    final outletState = ref.read(outletProvider).value as OutletSelected;

    String collectionPath =
        '${authState.user.user.company.idCompany}/${outletState.outlet.idOutlet}/tables';

    db
        .collection(collectionPath)
        .where('used_by', isEqualTo: transactionNo)
        .get()
        .then((snapshot) {
      for (var doc in snapshot.docs) {
        db.collection(collectionPath).doc(doc.id).update({"used_by": null});
      }
    });

    for (var table in tables) {
      await db
          .collection(collectionPath)
          .doc(table.id)
          .update({"used_by": transactionNo, "used_from": DateTime.now()});
    }
  }

  Future<void> addNewTable(
      {required String name, required int capacity, required int floor}) async {
    final authState = ref.read(authProvider).value as Authenticated;
    final outletState = ref.read(outletProvider).value as OutletSelected;

    String collectionPath =
        '${authState.user.user.company.idCompany}/${outletState.outlet.idOutlet}/tables';

    final existTable = await db
        .collection(collectionPath)
        .withConverter(
            fromFirestore: Table.fromFirestore,
            toFirestore: (Table table, _) => table.toJson())
        .where('name', isEqualTo: name)
        .get();

    if (existTable.size > 0) {
      throw "table_name_added".tr(args: [name]);
    }

    db
        .collection(collectionPath)
        .add({"name": name, "capacity": capacity, "floor": floor});
  }

  void clearTable(Table table) {
    final authState = ref.read(authProvider).value as Authenticated;
    final outletState = ref.read(outletProvider).value as OutletSelected;

    String collectionPath =
        '${authState.user.user.company.idCompany}/${outletState.outlet.idOutlet}/tables';

    db.collection(collectionPath).doc(table.id).update({"used_by": null});
  }

  void editTable(String id, {required int capacity}) {
    final authState = ref.read(authProvider).value as Authenticated;
    final outletState = ref.read(outletProvider).value as OutletSelected;

    String collectionPath =
        '${authState.user.user.company.idCompany}/${outletState.outlet.idOutlet}/tables';

    db.collection(collectionPath).doc(id).update({"capacity": capacity});
  }

  void deleteTable(String id) {
    final authState = ref.read(authProvider).value as Authenticated;
    final outletState = ref.read(outletProvider).value as OutletSelected;

    String collectionPath =
        '${authState.user.user.company.idCompany}/${outletState.outlet.idOutlet}/tables';

    db.collection(collectionPath).doc(id).delete();
  }
}
