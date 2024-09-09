import 'dart:convert';

class Outlet {
  String idOutlet;
  String outletName;
  String outletCode;
  String? outletPhone;
  String? outletAddress;
  int? idCity;
  String? cityName;
  int? idRegion;
  String? regionName;
  String? zipCode;
  bool? isActive;
  bool? stockMinus;
  int? akunKasKecilId;
  int? akunKasBesarId;
  bool? isOnlineStore;
  String? integrationWith;
  String? morphName;
  String? akunKasKecil;
  String? akunKasBesar;

  Outlet({
    required this.idOutlet,
    required this.outletName,
    required this.outletCode,
    required this.outletPhone,
    required this.outletAddress,
    this.idCity,
    this.cityName,
    this.idRegion,
    this.regionName,
    this.zipCode,
    this.isActive,
    this.stockMinus,
    this.akunKasKecilId,
    this.akunKasBesarId,
    this.isOnlineStore,
    this.integrationWith,
    this.morphName,
    this.akunKasKecil,
    this.akunKasBesar,
  });

  Outlet.fromJson(Map<dynamic, dynamic> json)
      : idOutlet = json['id_outlet'],
        outletName = json['outlet_name'],
        outletCode = json['outlet_code'],
        outletPhone = json['outlet_phoe'] ?? '',
        outletAddress = json['outlet_address'],
        idCity = json.containsKey('id_city') ? json['id_city'] : null,
        cityName = json.containsKey('city_name') ? json['city_name'] : '',
        idRegion = json.containsKey('id_region') ? json['id_region'] : null,
        regionName = json.containsKey('region_name') ? json['region_name'] : '',
        zipCode = json.containsKey('zip_code') ? json['zip_code'] : '',
        isActive =
            json.containsKey('is_active') ? json['is_active'] == 1 : false,
        stockMinus =
            json.containsKey('stock_minus') ? json['stock_minus'] == 1 : false,
        akunKasKecilId = json.containsKey('akun_kas_kecil_id')
            ? json['akun_kas_kecil_id']
            : 0,
        akunKasBesarId = json.containsKey('akun_kas_besar_id')
            ? json['akun_kas_besar_id']
            : 0,
        isOnlineStore = json.containsKey('is_online_store')
            ? json['is_online_store']
            : false,
        integrationWith = json.containsKey('integration_with')
            ? json['integration_with']
            : '',
        morphName = json.containsKey('morph_name') ? json['morph_name'] : '',
        akunKasKecil =
            json.containsKey('akun_kas_kecil') ? json['akun_kas_kecil'] : '',
        akunKasBesar =
            json.containsKey('akun_kas_besar') ? json['akun_kas_besar'] : '';

  Map<String, dynamic> toJson() => {
        'id_outlet': idOutlet,
        'outlet_name': outletName,
        'outlet_code': outletCode,
        'outlet_phone': outletPhone,
        'outlet_address': outletAddress,
        'id_city': idCity,
        'city_name': cityName,
        'id_region': idRegion,
        'region_name': regionName,
        'zip_code': zipCode,
        'is_active': isActive,
        'stock_minus': stockMinus,
        'akun_kas_kecil_id': akunKasKecilId,
        'akun_kas_besar_id': akunKasBesarId,
        'is_online_store': isOnlineStore,
        'integration_with': integrationWith,
        'morph_name': morphName,
        'akun_kas_kecil': akunKasKecil,
        'akun_kas_besar': akunKasBesar,
      };

  @override
  String toString() {
    final jsonToken = toJson();
    return json.encode(jsonToken);
  }
}
