import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'outlet_list_state.dart';
import 'package:selleri/data/network/api.dart' show OutletApi;
import 'package:selleri/data/models/outlet.dart';

part 'outlet_list_provider.g.dart';

@riverpod
class OutletListNotifier extends _$OutletListNotifier {
  @override
  OutletListState build() {
    return OutletListLoading();
  }

  Future<void> fetchOutletList() async {
    final api = OutletApi();
    try {
      final json = await api.outlets();
      List<Outlet> outlets =
          List<Outlet>.from(json['data'].map((o) => Outlet.fromJson(o)));
      state = OutletListLoaded(outlets: outlets);
    } on DioException catch (e) {
      String message = e.response?.data['message'] ?? e.message;
      state = OutletListFailure(message: message);
    }
  }
}
