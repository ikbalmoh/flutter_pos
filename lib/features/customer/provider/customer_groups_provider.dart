import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:selleri/shared/model/option.dart';
import 'package:selleri/features/customer/api/customer_api.dart';

part 'customer_groups_provider.g.dart';

@Riverpod(keepAlive: true)
Future<List<Option>> customerGroups(Ref ref) async {
  final api = ref.watch(customerApiProvider);
  final customerGroups = await api.customerGroups();
  return customerGroups;
}
