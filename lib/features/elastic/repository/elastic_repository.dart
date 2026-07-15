import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:selleri/features/auth/provider/auth_provider.dart';
import 'package:selleri/features/elastic/model/elastic.dart';
import 'package:selleri/features/outlet/provider/outlet_provider.dart';
import 'package:selleri/shared/constants/app_config.dart';
import 'package:selleri/shared/utils/formater.dart';

String syncKey = 'LAST_UPDATE/ITEMS';

abstract class ElasticRepositoryInterface {
  Future<ElasticResponse> items();
}

class ElasticRepository implements ElasticRepositoryInterface {
  final Dio api;
  final String companyId;
  final String outletId;

  final storage = FlutterSecureStorage();

  ElasticRepository({
    required this.api,
    required this.companyId,
    required this.outletId,
  });

  @override
  Future<ElasticResponse> items({
    String? idCategory,
    DateTime? lastUpdate,
    int? from = 0,
    int? size = 10,
    Function(int current, int total)? onProgress,
  }) async {
    final index = '/selleri_${companyId}_outlet_${outletId}_item';
    final Map<String, dynamic> data = {
      // 'pretty': 'true',
      'size': size,
      'from': from,
    };

    final query = {};

    if (lastUpdate != null) {
      query['range'] = {
        'updated_at': {
          'gte': DateTimeFormater.dateToString(lastUpdate),
          'lt': DateTimeFormater.dateToString(DateTime.now()),
        },
      };
    }

    if (idCategory != null) {
      query['match'] = {'id_category': idCategory};
    }

    if (query.isNotEmpty) {
      data['query'] = query;
    }

    final res = await api.post('$index/_search', data: data);
    return ElasticResponse.fromJson(res.data);
  }
}

final elasticRepositoryProvider = Provider<ElasticRepository>((ref) {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: AppConfig.esHost,
      headers: {'Authorization': 'ApiKey ${AppConfig.esKey}'},
    ),
  );

  final auth = ref.read(authProvider).value as Authenticated;
  final outlet = ref.read(outletProvider).value as OutletSelected;

  final String companyId = auth.user.user.company.idCompany;
  final String outletId = outlet.outlet.idOutlet;

  return ElasticRepository(
    api: dio,
    companyId: companyId,
    outletId: outletId,
  );
});
