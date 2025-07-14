enum StoreKey {
  device('DEVICE'),
  deviceName('DEVICE_NAME'),
  token('TOKEN'),
  user('USER'),
  outlet('OUTLET'),
  outletConfig('OUTLET_CONFIG'),
  shift('SHIFT'),
  fcmSubscribe('FCM_SUBSCRIBE'),
  notification('NOTIFICATION');

  final String name;
  const StoreKey(this.name);
}
