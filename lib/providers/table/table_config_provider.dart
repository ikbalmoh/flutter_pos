import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:selleri/providers/auth/auth_provider.dart';
import 'package:selleri/providers/outlet/outlet_provider.dart';
import 'package:selleri/data/models/table.dart' as model;

part 'table_config_provider.g.dart';

@riverpod
class TableConfig extends _$TableConfig {
  static final db = FirebaseFirestore.instance;

  @override
  Stream<model.TableConfig> build() {
    final authState = ref.watch(authProvider).value;
    final outletState = ref.watch(outletProvider).value;

    if (authState is Authenticated && outletState is OutletSelected) {
      final configSnapshot = db
          .collection(authState.user.user.company.idCompany)
          .doc(outletState.outlet.idOutlet)
          .withConverter<model.TableConfig>(
              fromFirestore: model.TableConfig.fromFirestore,
              toFirestore: (model.TableConfig config, _) => config.toJson())
          .snapshots();
      return configSnapshot.map((snapshot) {
        return snapshot.data() ?? model.TableConfig(totalFloor: 1);
      });
    }
    return Stream.empty();
  }

  void setTotalFloor(int total) {
    final authState = ref.watch(authProvider).value as Authenticated;
    final outletState = ref.watch(outletProvider).value as OutletSelected;
    db
        .collection(authState.user.user.company.idCompany)
        .doc(outletState.outlet.idOutlet)
        .set({"total_floor": total < 1 ? 1 : total});
  }
}
