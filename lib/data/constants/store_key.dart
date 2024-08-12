enum StoreKey {
  device('DEVICE'),
  deviceName('DEVICE_NAME'),
  token('TOKEN'),
  user('USER'),
  outlet('OUTLET'),
  outletConfig('OUTLET_CONFIG'),
  shift('SHIFT');

  final String name;
  const StoreKey(this.name);
}
