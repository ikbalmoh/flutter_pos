import 'package:equatable/equatable.dart';
import 'package:selleri/data/models/outlet.dart';
import 'package:selleri/data/models/outlet_config.dart';

class OutletState extends Equatable {
  const OutletState();

  @override
  List<Object> get props => [];

  @override
  bool get stringify => true;
}

class OutletNotSelected extends OutletState {}

class OutletLoading extends OutletState {
  final String message;

  const OutletLoading({required this.message});

  @override
  List<Object> get props => [message];

  @override
  bool get stringify => true;
}

class OutletSelected extends OutletState {
  final Outlet outlet;
  final OutletConfig config;
  final bool? isSyncing;

  const OutletSelected(
      {required this.outlet, required this.config, this.isSyncing});

  @override
  List<Object> get props => [outlet, config];

  @override
  bool get stringify => true;
}

class OutletFailure extends OutletState {
  final String message;

  const OutletFailure({required this.message});

  @override
  List<Object> get props => [message];

  @override
  bool get stringify => true;
}
