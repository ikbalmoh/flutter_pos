import 'package:equatable/equatable.dart';

class ItemState extends Equatable {
  @override
  List<Object> get props => [];

  @override
  bool get stringify => true;
}

class ItemLoading extends ItemState {
  final String message;

  ItemLoading({ required this.message });

  @override
  List<Object> get props => [message];

  @override
  bool get stringify => true;
}

class ItemLoaded extends ItemState {
  @override
  bool get stringify => true;
}

class LoadItemFailed extends ItemState {
  final String message;

  LoadItemFailed({required this.message});

  @override
  List<Object> get props => [message];

  @override
  bool get stringify => true;
}
