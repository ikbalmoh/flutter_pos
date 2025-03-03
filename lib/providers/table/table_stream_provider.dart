import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:selleri/data/models/table.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:selleri/providers/auth/auth_provider.dart';
import 'package:selleri/providers/outlet/outlet_provider.dart';

part 'table_stream_provider.g.dart';

@riverpod
class TableStream extends _$TableStream {
  @override
  Stream<TableData> build() {
    final authState = ref.watch(authProvider);
    final outletState = ref.watch(outletProvider);

    final db = FirebaseFirestore.instance;

    if (authState is Authenticated && outletState is OutletSelected) {
      final auth = authState as Authenticated;
      final outlet = outletState as OutletSelected;
      final DocumentReference<TableData> doc = db
          .collection(auth.user.user.company.idCompany)
          .doc(outlet.outlet.idOutlet)
          .withConverter<TableData>(
            fromFirestore: (snapshot, _) =>
                TableData.fromJson(snapshot.data()!),
            toFirestore: (model, _) => model.toJson(),
          );

      final Stream<DocumentSnapshot<TableData>> querySnapshot = doc.snapshots();

      return querySnapshot.asyncMap((snapshot) async {
        if (snapshot.exists) {
          return snapshot.data()!;
        }
        throw Exception('no data');
      });
    }
    return Stream.empty();
  }
}
