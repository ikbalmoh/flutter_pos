// ignore_for_file: avoid_manual_providers_as_generated_provider_dependency
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:selleri/data/models/outlet.dart';
import 'package:selleri/data/network/outlet.dart';

part 'outlet_list_provider.g.dart';

@riverpod
class OutletList extends _$OutletList {
  @override
  Future<List<Outlet>> build() async {
    final api = ref.watch(outletApiProvider);
    final outlets = await api.outlets();
    return outlets;
  }

  Future<void> fetchOutletList() async {
    state = const AsyncLoading();
    final api = ref.watch(outletApiProvider);
    try {
      final outlets = await api.outlets();
      state = AsyncData(outlets);
    } catch (e, trace) {
      state = AsyncError(e, trace);
    }
  }
}
