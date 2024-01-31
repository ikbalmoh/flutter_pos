import 'package:equatable/equatable.dart';
import 'package:selleri/models/outlet.dart';

class OutletState extends Equatable {
  const OutletState();

  @override
  List<Object> get props => [];

  @override
  bool get stringify => true;
}

class OutletLoading extends OutletState {}

class OutletListLoaded extends OutletState {
  final List<Outlet> outlets;

  const OutletListLoaded({required this.outlets});

  @override
  List<Object> get props => [outlets];

  @override
  bool get stringify => true;
}

class OutletListFailure extends OutletState {
  final String message;

  const OutletListFailure({required this.message});

  @override
  List<Object> get props => [message];

  @override
  bool get stringify => true;
}

class OutletSelected extends OutletState {
  final Outlet outlet;

  const OutletSelected({required this.outlet});

  @override
  List<Object> get props => [outlet];

  @override
  bool get stringify => true;
}
