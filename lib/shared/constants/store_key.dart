enum StoreKey {
  device('DEVICE'),
  deviceName('DEVICE_NAME'),
  token('TOKEN'),
  user('USER'),
  outlet('OUTLET'),
  outletConfig('OUTLET_CONFIG'),
  shift('SHIFT'),
  shiftInfo('SHIFT_INFO'),
  fcmSubscribe('FCM_SUBSCRIBE'),
  notification('NOTIFICATION'),
  lastSync('LAST_SYNC');

  final String name;
  const StoreKey(this.name);
}
