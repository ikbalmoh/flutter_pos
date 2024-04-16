import 'package:equatable/equatable.dart';
import 'package:selleri/models/outlet.dart';

class OutletListState extends Equatable {
  const OutletListState();

  @override
  List<Object> get props => [];

  @override
  bool get stringify => true;
}

class OutletListLoading extends OutletListState {}

class OutletListLoaded extends OutletListState {
  final List<Outlet> outlets;

  const OutletListLoaded({required this.outlets});

  @override
  List<Object> get props => [outlets];

  @override
  bool get stringify => true;
}

class OutletListFailure extends OutletListState {
  final String message;

  const OutletListFailure({required this.message});

  @override
  List<Object> get props => [message];

  @override
  bool get stringify => true;
}
