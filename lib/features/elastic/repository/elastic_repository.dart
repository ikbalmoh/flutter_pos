import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:selleri/features/auth/provider/auth_provider.dart';
import 'package:selleri/features/elastic/model/elastic.dart';
import 'package:selleri/features/outlet/provider/outlet_provider.dart';
import 'package:selleri/features/outlet/repository/outlet_repository.dart';
import 'package:selleri/shared/constants/app_config.dart';
import 'package:selleri/shared/utils/exception.dart';
import 'package:selleri/shared/utils/formater.dart';

abstract class ElasticRepositoryInterface {
  Future<ElasticResponse> items();
}

class ElasticRepository implements ElasticRepositoryInterface {
  final Dio api;
  final String? companyId;
  final String? outletId;
  final Ref ref;

  final storage = const FlutterSecureStorage();

  ElasticRepository({
    required this.api,
    this.companyId,
    this.outletId,
    required this.ref,
  });

  @override
  Future<ElasticResponse> items({
    String? idCategory,
    DateTime? lastUpdate,
    int? from = 0,
    int? size = 10,
    Function(int current, int total)? onProgress,
  }) async {
    String? activeCompanyId = companyId;
    if (activeCompanyId == null) {
      final authState = ref.read(authProvider).value;
      if (authState is Authenticated) {
        activeCompanyId = authState.user.user.company.idCompany;
      }
    }

    String? activeOutletId = outletId;
    if (activeOutletId == null) {
      final outletState = ref.read(outletProvider).value;
      if (outletState is OutletSelected) {
        activeOutletId = outletState.outlet.idOutlet;
      } else {
        // Fallback: Try reading the selected outlet from database/secure storage directly
        final outletRepo = ref.read(outletRepositoryProvider);
        final outlet = await outletRepo.retrieveOutlet();
        activeOutletId = outlet?.idOutlet;
      }
    }

    if (activeCompanyId == null || activeOutletId == null) {
      throw Exception('Missing companyId ($activeCompanyId) or outletId ($activeOutletId)');
    }

    final index = '/selleri_tenant_${activeCompanyId}_outlet_${activeOutletId}_item';

    try {
      final Map<String, dynamic> data = {
        'size': size,
        'from': from,
      };

      final query = {};

      if (lastUpdate != null) {
        query['range'] = {
          'updated_at': {
            'gte': DateTimeFormater.dateToString(lastUpdate.copyWith(hour: 0, minute: 0, second: 0)),
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
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw NotFoundException();
      }
      rethrow;
    }
  }
}

final elasticRepositoryProvider = Provider<ElasticRepository>((ref) {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: AppConfig.esHost,
      headers: {'Authorization': 'ApiKey ${AppConfig.esKey}'},
    ),
  );

  final authState = ref.read(authProvider).value;
  final outletState = ref.read(outletProvider).value;

  final String? companyId = authState is Authenticated
      ? authState.user.user.company.idCompany
      : null;

  final String? outletId = outletState is OutletSelected
      ? outletState.outlet.idOutlet
      : null;

  return ElasticRepository(
    api: dio,
    companyId: companyId,
    outletId: outletId,
    ref: ref,
  );
});
