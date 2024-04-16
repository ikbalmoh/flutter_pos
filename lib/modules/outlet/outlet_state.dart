import 'package:equatable/equatable.dart';
import 'package:selleri/models/outlet.dart';
import 'package:selleri/models/outlet_config.dart';

class OutletState extends Equatable {
  const OutletState();

  @override
  List<Object> get props => [];

  @override
  bool get stringify => true;
}

class OutletInitial extends OutletState {}

class OutletLoading extends OutletState {}

class OutletSelected extends OutletState {
  final Outlet outlet;
  final OutletConfig config;

  const OutletSelected({required this.outlet, required this.config});

  @override
  List<Object> get props => [outlet];

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
