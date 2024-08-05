import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:selleri/data/network/api.dart' show OutletApi;
import 'package:selleri/data/models/outlet.dart';

part 'outlet_list_provider.g.dart';

@riverpod
class OutletList extends _$OutletList {
  @override
  Future<List<Outlet>> build() async {
    final api = OutletApi();
    final outlets = await api.outlets();
    return outlets;
  }

  Future<void> fetchOutletList() async {
    state = const AsyncLoading();
    final api = OutletApi();
    try {
      final outlets = await api.outlets();
      state = AsyncData(outlets);
    } catch (e, trace) {
      state = AsyncError(e, trace);
    }
  }
}
